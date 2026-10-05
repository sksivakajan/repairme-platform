import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { AppModule } from '../src/app.module.js';
import { PrismaService } from '../src/database/prisma.service.js';
import { setupApp } from '../src/setup-app.js';

// Account journey against the real local database with dev login.
process.env.AUTH_DEV_BYPASS = 'true';

const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  'base64',
);

describe('Account, profile and legal (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  const suffix = String(Date.now()).slice(-7);
  const phone = `+9475${suffix}`;
  const newPhone = `+9476${suffix}`;
  const takenPhone = `+9473${suffix}`;
  const as = (number: string) => ({ Authorization: `Dev ${number}` });
  const http = () => request(app.getHttpServer());
  const accepted = [
    { type: 'terms', version: '1.0' },
    { type: 'privacy', version: '1.0' },
  ];
  const feedbackMarker = `e2e-${suffix}`;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    setupApp(app);
    await app.init();
    prisma = app.get(PrismaService);
  });

  afterAll(async () => {
    const users = await prisma.user.findMany({
      where: { OR: [{ phoneNumber: { in: [phone, newPhone, takenPhone] } }, { firebaseUid: { startsWith: 'dev:' }, fullName: null, deletedAt: { not: null } }] },
      include: { customer: true },
    });
    for (const user of users) {
      if (user.customer) {
        await prisma.address.deleteMany({ where: { customerId: user.customer.id } });
        await prisma.customer.delete({ where: { id: user.customer.id } });
      }
      await prisma.user.delete({ where: { id: user.id } });
    }
    await prisma.accountDeletionFeedback.deleteMany({ where: { details: feedbackMarker } });
    await app.close();
  });

  it('a verified number with no account starts incomplete and must accept the legal documents', async () => {
    const res = await http().get('/v1/me').set(as(phone)).expect(200);
    expect(res.body.profileComplete).toBe(false);
    expect(res.body.membershipType).toBe('STANDARD');
    expect(res.body.pendingLegal.map((d: { type: string }) => d.type).sort()).toEqual(['privacy', 'terms']);

    await http().post('/v1/me/complete-profile').set(as(phone)).send({ firstName: 'Kajan', lastName: 'Perera', acceptedDocuments: [] }).expect(400);
    await http().post('/v1/me/complete-profile').set(as(phone)).send({ firstName: 'Kajan', lastName: 'Perera', acceptedDocuments: [{ type: 'terms', version: '0.1' }] }).expect(400);
    await http().post('/v1/me/complete-profile').set(as(phone)).send({ firstName: '', lastName: 'Perera', acceptedDocuments: accepted }).expect(400);
  });

  it('completing the profile creates the account once and records which versions were accepted', async () => {
    const done = await http()
      .post('/v1/me/complete-profile')
      .set(as(phone))
      .send({ firstName: ' Kajan ', lastName: 'Perera', email: 'Kajan@Example.com', acceptedDocuments: accepted })
      .expect(201);
    expect(done.body).toMatchObject({ profileComplete: true, firstName: 'Kajan', lastName: 'Perera', fullName: 'Kajan Perera', email: 'kajan@example.com', pendingLegal: [] });

    await http().post('/v1/me/complete-profile').set(as(phone)).send({ firstName: 'Other', lastName: 'Name', acceptedDocuments: accepted }).expect(409);

    // Signing in again with the same number is the same account.
    await http().get('/v1/me').set(as(phone)).expect(200);
    expect(await prisma.user.count({ where: { phoneNumber: phone } })).toBe(1);

    const history = await http().get('/v1/me/legal-acceptances').set(as(phone)).expect(200);
    expect(history.body).toHaveLength(2);
    expect(history.body[0]).toMatchObject({ documentVersion: '1.0' });
  });

  it('edits personal details with validation', async () => {
    await http().patch('/v1/me').set(as(phone)).send({ birthday: '2999-01-01' }).expect(400);
    await http().patch('/v1/me').set(as(phone)).send({ birthday: '2001-02-30' }).expect(400);
    await http().patch('/v1/me').set(as(phone)).send({ email: 'nope' }).expect(400);
    await http().patch('/v1/me').set(as(phone)).send({ gender: 'ROBOT' }).expect(400);

    const res = await http()
      .patch('/v1/me')
      .set(as(phone))
      .send({ birthday: '2001-08-12', gender: 'MALE', language: 'SI', lastName: 'Silva' })
      .expect(200);
    expect(res.body).toMatchObject({ birthday: '2001-08-12', gender: 'MALE', language: 'SI', fullName: 'Kajan Silva' });

    const cleared = await http().patch('/v1/me').set(as(phone)).send({ email: '', birthday: '' }).expect(200);
    expect(cleared.body).toMatchObject({ email: null, birthday: null });
  });

  it('keeps one emergency contact', async () => {
    expect((await http().get('/v1/me/emergency-contact').set(as(phone)).expect(200)).body).toEqual({});
    await http().put('/v1/me/emergency-contact').set(as(phone)).send({ name: 'Nimal Perera', relationship: 'Family', phoneNumber: '0712345678' }).expect(400);
    await http().put('/v1/me/emergency-contact').set(as(phone)).send({ name: 'Nimal Perera', relationship: 'Family', phoneNumber: '+94712345678' }).expect(200);
    const second = await http().put('/v1/me/emergency-contact').set(as(phone)).send({ name: 'Nimal P', relationship: 'Friend', phoneNumber: '+94712345679' }).expect(200);
    expect(second.body).toMatchObject({ name: 'Nimal P', relationship: 'Friend' });
    expect(await prisma.emergencyContact.count({ where: { user: { phoneNumber: phone } } })).toBe(1);
    await http().delete('/v1/me/emergency-contact').set(as(phone)).expect(204);
    expect(await prisma.emergencyContact.count({ where: { user: { phoneNumber: phone } } })).toBe(0);
  });

  it('stores notification choices, with offers off by default', async () => {
    const before = await http().get('/v1/me').set(as(phone)).expect(200);
    expect(before.body.notificationPreferences).toEqual({ bookingUpdates: true, serviceReminders: true, paymentUpdates: true, offers: false, repairmeUpdates: true });
    const res = await http().patch('/v1/me/notification-preferences').set(as(phone)).send({ offers: true, serviceReminders: false }).expect(200);
    expect(res.body).toMatchObject({ offers: true, serviceReminders: false, bookingUpdates: true });
  });

  it('uploads, serves and removes a profile photo', async () => {
    await http().post('/v1/me/photo').set(as(phone)).attach('file', Buffer.from('not an image at all'), 'x.png').expect(400);
    await http().post('/v1/me/photo').set(as(phone)).attach('file', PNG, 'me.png').expect(204);
    expect((await http().get('/v1/me').set(as(phone))).body.hasPhoto).toBe(true);
    const photo = await http().get('/v1/me/photo').set(as(phone)).expect(200);
    expect(photo.headers['content-type']).toContain('image/png');
    await http().delete('/v1/me/photo').set(as(phone)).expect(204);
    await http().get('/v1/me/photo').set(as(phone)).expect(404);
  });

  it('serves the published legal documents without signing in', async () => {
    const list = await http().get('/v1/legal/documents').expect(200);
    expect(list.body.map((d: { type: string }) => d.type)).toEqual(['terms', 'privacy', 'cancellation', 'refund', 'payment', 'data-deletion']);
    expect(list.body[0]).not.toHaveProperty('content');
    const terms = await http().get('/v1/legal/documents/terms').expect(200);
    expect(terms.body).toMatchObject({ version: '1.0', status: 'PUBLISHED', requiresAcceptance: true });
    expect(terms.body.content).toContain('Welcome to RepairMe');
    await http().get('/v1/legal/documents/nope').expect(404);
  });

  it('saves the extra address details', async () => {
    const res = await http()
      .post('/v1/addresses')
      .set(as(phone))
      .send({ label: 'OFFICE', line1: '12 Temple Road', area: 'Nugegoda', city: 'Colombo', district: 'Colombo', contactName: 'Nimal', contactPhone: '+94 71 234 5678', instructions: 'Ring the bell twice' })
      .expect(201);
    expect(res.body).toMatchObject({ district: 'Colombo', contactName: 'Nimal', instructions: 'Ring the bell twice', isDefault: true });
  });

  it('changes the mobile number, but not to one another account has', async () => {
    await http().get('/v1/me').set(as(takenPhone)).expect(200);
    await http().put('/v1/me/phone').set(as(phone)).send({ phoneNumber: takenPhone }).expect(409);
    await http().put('/v1/me/phone').set(as(phone)).send({ phoneNumber: '0771234567' }).expect(400);
    const res = await http().put('/v1/me/phone').set(as(phone)).send({ phoneNumber: newPhone }).expect(200);
    expect(res.body.phoneNumber).toBe(newPhone);
    expect(await prisma.user.count({ where: { phoneNumber: phone } })).toBe(0);
  });

  it('deletes the account: anonymises it, frees the number, and starts fresh next time', async () => {
    await http().post('/v1/me/delete').set(as(newPhone)).send({ reason: 'BECAUSE' }).expect(400);
    await http().post('/v1/me/delete').set(as(newPhone)).send({ reason: 'PRIVACY_CONCERNS', details: feedbackMarker }).expect(204);

    const gone = await prisma.user.findFirst({ where: { accountStatus: 'DELETED', firebaseUid: null, fullName: null, deletedAt: { not: null } }, orderBy: { deletedAt: 'desc' } });
    expect(gone).toMatchObject({ phoneNumber: null, email: null, firstName: null, birthday: null, profilePhotoKey: null });
    expect(await prisma.address.count({ where: { customerId: gone ? undefined : 'none', customer: { userId: gone?.id } } })).toBe(0);
    expect(await prisma.accountDeletionFeedback.count({ where: { details: feedbackMarker, reason: 'PRIVACY_CONCERNS' } })).toBe(1);

    // The same number signing in again gets a brand-new, incomplete account.
    const fresh = await http().get('/v1/me').set(as(newPhone)).expect(200);
    expect(fresh.body).toMatchObject({ profileComplete: false, firstName: null, addressCount: 0 });
    expect(fresh.body.id).not.toBe(gone?.id);
  });
});
