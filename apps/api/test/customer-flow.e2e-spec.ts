import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { rm } from 'node:fs/promises';
import { join } from 'node:path';
import request from 'supertest';
import { AppModule } from '../src/app.module.js';
import { AppConfig } from '../src/config/app-config.js';
import { PrismaService } from '../src/database/prisma.service.js';
import { setupApp } from '../src/setup-app.js';

// Full customer journey against the real local database, with the dev
// simulator playing the technician. Requires `npm run prisma:seed` once.
process.env.AUTH_DEV_BYPASS = 'true';
process.env.DEV_TOOLS = 'true';

const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  'base64',
);

describe('Customer booking flow (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let config: AppConfig;
  const suffix = String(Date.now()).slice(-7);
  const phone = `+9477${suffix}`;
  const otherPhone = `+9478${suffix}`;
  const auth = { Authorization: `Dev ${phone}` };
  const otherAuth = { Authorization: `Dev ${otherPhone}` };
  const http = () => request(app.getHttpServer());

  let electricalId: string;
  let problemTypeId: string;
  let technicianBefore: { id: string; ratingSum: number; ratingCount: number; jobsCompleted: number };

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    setupApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    config = app.get(AppConfig);
  });

  afterAll(async () => {
    const users = await prisma.user.findMany({
      where: { phoneNumber: { in: [phone, otherPhone] } },
      include: { customer: { include: { bookings: { select: { id: true } } } } },
    });
    for (const user of users) {
      const bookingIds = user.customer?.bookings.map((b) => b.id) ?? [];
      await prisma.payment.deleteMany({ where: { bookingId: { in: bookingIds } } });
      await prisma.review.deleteMany({ where: { bookingId: { in: bookingIds } } });
      await prisma.supportTicket.deleteMany({ where: { customerId: user.customer?.id } });
      await prisma.booking.deleteMany({ where: { id: { in: bookingIds } } });
      if (user.customer) await prisma.customer.delete({ where: { id: user.customer.id } });
      await prisma.user.delete({ where: { id: user.id } });
      for (const id of bookingIds) {
        await rm(join(config.uploadDir, id), { recursive: true, force: true });
      }
    }
    if (technicianBefore) {
      await prisma.technician.update({
        where: { id: technicianBefore.id },
        data: {
          ratingSum: technicianBefore.ratingSum,
          ratingCount: technicianBefore.ratingCount,
          jobsCompleted: technicianBefore.jobsCompleted,
        },
      });
    }
    await app.close();
  });

  it('serves the public service catalogue', async () => {
    const res = await http().get('/v1/service-categories').expect(200);
    const electrical = res.body.categories.find((c: { slug: string }) => c.slug === 'electrical');
    expect(electrical.visitFeeCents).toBe(50_000);
    expect(electrical.problemTypes.length).toBeGreaterThan(0);
    electricalId = electrical.id;
    problemTypeId = electrical.problemTypes[0].id;
  });

  it('lists top-rated technicians by first name only', async () => {
    await http().get('/v1/technicians/top-rated').expect(401);
    const res = await http().get('/v1/technicians/top-rated').set(auth).expect(200);
    expect(res.body.length).toBeGreaterThan(0);
    expect(res.body[0]).toHaveProperty('firstName');
    expect(res.body[0]).not.toHaveProperty('displayName');
    expect(res.body[0]).not.toHaveProperty('id');
  });

  it('rejects unauthenticated and malformed credentials', async () => {
    await http().get('/v1/me').expect(401);
    await http().get('/v1/me').set('Authorization', 'Dev 0771234567').expect(401);
    await http().get('/v1/me').set('Authorization', 'Bearer not-a-token').expect(401);
  });

  it('creates the customer on first sign-in and updates the profile', async () => {
    const me = await http().get('/v1/me').set(auth).expect(200);
    expect(me.body).toMatchObject({ role: 'CUSTOMER', phoneNumber: phone, bookingCount: 0 });

    const updated = await http()
      .patch('/v1/me')
      .set(auth)
      .send({ fullName: 'Nimal Fernando', language: 'SI' })
      .expect(200);
    expect(updated.body).toMatchObject({ fullName: 'Nimal Fernando', language: 'SI' });
  });

  it('validates booking requests', async () => {
    const base = {
      categoryId: electricalId,
      description: 'Main breaker trips when the kettle is on.',
      address: { line1: '24 Station Road', area: 'Wellawatte', city: 'Colombo 06' },
    };
    await http().post('/v1/bookings').set(auth).send({ ...base, type: 'SCHEDULED' }).expect(400);
    await http().post('/v1/bookings').set(auth).send({ ...base, type: 'EMERGENCY', hacker: 1 }).expect(400);
    await http()
      .post('/v1/bookings')
      .set(auth)
      .send({ ...base, type: 'EMERGENCY', paymentMethod: 'CARD' })
      .expect(422);
    await http()
      .post('/v1/bookings')
      .set(auth)
      .send({
        ...base,
        type: 'SCHEDULED',
        scheduledStart: '2020-01-01T10:00:00.000Z',
        scheduledEnd: '2020-01-01T12:00:00.000Z',
      })
      .expect(400);
  });

  it('runs an emergency booking from request to rating', async () => {
    const technician = await prisma.technician.findFirstOrThrow({
      where: { displayName: 'Kasun Perera' },
    });
    technicianBefore = technician;

    const created = await http()
      .post('/v1/bookings')
      .set(auth)
      .send({
        categoryId: electricalId,
        problemTypeId,
        type: 'EMERGENCY',
        description: 'Main breaker trips whenever the kettle is switched on.',
        symptoms: ['Burning smell'],
        address: {
          line1: 'No. 24, Station Road',
          area: 'Wellawatte',
          city: 'Colombo 06',
          landmark: 'Blue gate opposite the bakery',
          latitude: 6.8741,
          longitude: 79.8606,
        },
        saveAddress: true,
      })
      .expect(201);
    const id: string = created.body.id;
    expect(created.body).toMatchObject({
      status: 'SEARCHING',
      jobCode: null,
      canCancel: true,
      visitFeeCents: 50_000,
    });
    expect(created.body.reference).toMatch(/^RM-\d{5}$/);

    const addresses = await http().get('/v1/addresses').set(auth).expect(200);
    expect(addresses.body).toHaveLength(1);
    expect(addresses.body[0].isDefault).toBe(true);

    // Photos: real image accepted, anything else rejected.
    const photo = await http()
      .post(`/v1/bookings/${id}/photos`)
      .set(auth)
      .attach('file', PNG, 'leak.png')
      .expect(201);
    await http()
      .post(`/v1/bookings/${id}/photos`)
      .set(auth)
      .attach('file', Buffer.from('not an image at all'), 'evil.png')
      .expect(400);
    const image = await http().get(`/v1/bookings/${id}/photos/${photo.body.id}`).set(auth).expect(200);
    expect(image.headers['content-type']).toBe('image/png');

    // Another customer cannot see it.
    await http().get(`/v1/bookings/${id}`).set(otherAuth).expect(404);
    await http().get(`/v1/bookings/${id}/photos/${photo.body.id}`).set(otherAuth).expect(404);

    // Nobody accepts, the operator assigns Kasun.
    await http().post(`/v1/dev/bookings/${id}/escalate`).expect(204);
    await http().post(`/v1/dev/bookings/${id}/assign`).send({ technicianId: technician.id }).expect(204);
    const assigned = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(assigned.body.status).toBe('ASSIGNED');
    expect(assigned.body.technician.displayName).toBe('Kasun Perera');
    const jobCode: string = assigned.body.jobCode;
    expect(jobCode).toMatch(/^\d{4}$/);

    // Chat both ways.
    await http().post(`/v1/dev/bookings/${id}/messages`).send({ body: 'I am 15 minutes away.' }).expect(201);
    const withUnread = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(withUnread.body.unreadMessages).toBe(1);
    await http().post(`/v1/bookings/${id}/messages`).set(auth).send({ body: 'The gate is blue.' }).expect(201);
    const chat = await http().get(`/v1/bookings/${id}/messages`).set(auth).expect(200);
    expect(chat.body.map((m: { mine: boolean }) => m.mine)).toEqual([false, true]);
    const conversations = await http().get('/v1/conversations').set(auth).expect(200);
    expect(conversations.body[0]).toMatchObject({
      bookingId: id,
      technicianName: 'Kasun Perera',
      chatOpen: true,
      unreadCount: 0,
      lastMessage: { body: 'The gate is blue.', mine: true },
    });

    // Travel and arrival with the job code.
    await http().post(`/v1/dev/bookings/${id}/en-route`).send({ etaMinutes: 12 }).expect(204);
    const wrongCode = jobCode === '0000' ? '1111' : '0000';
    await http().post(`/v1/dev/bookings/${id}/arrive`).send({ jobCode: wrongCode }).expect(422);
    await http().post(`/v1/dev/bookings/${id}/arrive`).send({ jobCode }).expect(204);
    const arrived = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(arrived.body).toMatchObject({ status: 'ARRIVED', jobCode: null, canCancel: false });
    await http().post(`/v1/bookings/${id}/cancel`).set(auth).send({ reason: 'OTHER' }).expect(409);

    // Cost approval.
    await http()
      .post(`/v1/dev/bookings/${id}/quote`)
      .send({
        note: 'The 20A breaker is faulty and one socket is burnt.',
        labourCents: 200_000,
        items: [
          { description: '20A MCB breaker', quantity: 1, unitPriceCents: 55_000 },
          { description: '13A socket', quantity: 1, unitPriceCents: 20_000 },
        ],
      })
      .expect(204);
    const quoted = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(quoted.body.status).toBe('AWAITING_APPROVAL');
    expect(quoted.body.quotation).toMatchObject({ totalCents: 325_000, partsCents: 75_000, status: 'PENDING' });
    const quotationId: string = quoted.body.quotation.id;
    await http().post(`/v1/bookings/${id}/quotations/${quotationId}/approve`).set(auth).expect(201);
    await http().post(`/v1/bookings/${id}/quotations/${quotationId}/approve`).set(auth).expect(409);

    // Completion and cash payment.
    await http().post(`/v1/dev/bookings/${id}/complete`).expect(204);
    const completed = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(completed.body.payment).toMatchObject({ amountCents: 325_000, status: 'PENDING', method: 'CASH' });
    await http().post(`/v1/bookings/${id}/payment`).set(auth).send({ method: 'CARD' }).expect(422);
    await http().post(`/v1/bookings/${id}/payment`).set(auth).send({ method: 'CASH' }).expect(201);
    await http().post(`/v1/bookings/${id}/review`).set(auth).send({ rating: 5 }).expect(409);
    await http().post(`/v1/dev/bookings/${id}/confirm-cash`).expect(204);

    // Rating.
    await http()
      .post(`/v1/bookings/${id}/review`)
      .set(auth)
      .send({ rating: 5, tags: ['ON_TIME', 'CLEAN_WORK'], comment: 'Fixed it quickly.' })
      .expect(201);
    await http().post(`/v1/bookings/${id}/review`).set(auth).send({ rating: 4 }).expect(409);
    await http().post(`/v1/bookings/${id}/review`).set(auth).send({ rating: 9 }).expect(400);

    const paid = await http().get(`/v1/bookings/${id}`).set(auth).expect(200);
    expect(paid.body.status).toBe('PAID');
    expect(paid.body.events.map((e: { status: string }) => e.status)).toEqual([
      'SEARCHING',
      'OPERATOR_ASSIGNING',
      'ASSIGNED',
      'EN_ROUTE',
      'ARRIVED',
      'AWAITING_APPROVAL',
      'IN_PROGRESS',
      'COMPLETED',
      'PAID',
    ]);

    const completedTab = await http().get('/v1/bookings?tab=completed').set(auth).expect(200);
    expect(completedTab.body[0]).toMatchObject({ id, totalCents: 325_000 });

    const notifications = await http().get('/v1/notifications').set(auth).expect(200);
    expect(notifications.body.length).toBeGreaterThanOrEqual(8);
    await http().post('/v1/notifications/read-all').set(auth).expect(204);
    const me = await http().get('/v1/me').set(auth).expect(200);
    expect(me.body.unreadNotifications).toBe(0);
  });

  it('lets the customer cancel while searching, once', async () => {
    const created = await http()
      .post('/v1/bookings')
      .set(auth)
      .send({
        categoryId: electricalId,
        type: 'SCHEDULED',
        description: 'Install two new sockets in the bedroom.',
        address: { line1: '24 Station Road', area: 'Wellawatte', city: 'Colombo 06' },
        scheduledStart: new Date(Date.now() + 86_400_000).toISOString(),
        scheduledEnd: new Date(Date.now() + 86_400_000 + 7_200_000).toISOString(),
      })
      .expect(201);
    const id: string = created.body.id;

    await http().post(`/v1/bookings/${id}/cancel`).set(auth).send({ reason: 'NOPE' }).expect(400);
    const cancelled = await http()
      .post(`/v1/bookings/${id}/cancel`)
      .set(auth)
      .send({ reason: 'FOUND_SOMEONE_ELSE' })
      .expect(201);
    expect(cancelled.body).toMatchObject({ status: 'CANCELLED', cancelledBy: 'CUSTOMER' });
    await http().post(`/v1/bookings/${id}/cancel`).set(auth).send({ reason: 'OTHER' }).expect(409);

    const tab = await http().get('/v1/bookings?tab=cancelled').set(auth).expect(200);
    expect(tab.body.map((b: { id: string }) => b.id)).toContain(id);
  });

  it('opens support tickets', async () => {
    const res = await http()
      .post('/v1/support/tickets')
      .set(auth)
      .send({ subject: 'Technician arrived late', message: 'He arrived 40 minutes after the ETA.' })
      .expect(201);
    expect(res.body[0]).toMatchObject({ subject: 'Technician arrived late', status: 'OPEN' });
  });
});
