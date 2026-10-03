/**
 * Seeds reference data. Safe to run repeatedly (upserts by slug / phone).
 *   npm run prisma:seed
 * Demo technicians are only created outside production.
 */
import { PrismaPg } from '@prisma/adapter-pg';
import { AppConfig } from '../config/app-config.js';
import { PrismaClient } from '../generated/prisma/client.js';

const VISIT_FEE_CENTS = 50_000; // Rs. 500

const CATEGORIES = [
  {
    slug: 'electrical',
    name: 'Electrical',
    description: 'Wiring, sockets, breakers',
    iconKey: 'electrical',
    isPopular: true,
    problems: ['Breaker keeps tripping', 'Socket not working', 'Light or fan fault', 'Power outage', 'New wiring or points'],
  },
  {
    slug: 'plumbing',
    name: 'Plumbing',
    description: 'Taps, pipes, leaks',
    iconKey: 'plumbing',
    isPopular: true,
    problems: ['Leaking tap', 'Burst or leaking pipe', 'Blocked drain', 'Toilet or cistern fault', 'Water pump problem'],
  },
  {
    slug: 'ac',
    name: 'AC',
    description: 'Service, gas, repairs',
    iconKey: 'ac',
    isPopular: true,
    problems: ['Not cooling', 'Water leaking', 'Strange noise', 'Regular service', 'Gas refill'],
  },
  {
    slug: 'refrigerators',
    name: 'Refrigerators',
    description: 'Not cooling, leaks',
    iconKey: 'fridge',
    isPopular: false,
    problems: ['Not cooling', 'Water leaking', 'Strange noise', 'Not turning on'],
  },
  {
    slug: 'washing-machines',
    name: 'Washing machines',
    description: 'Drain, noise, no power',
    iconKey: 'washing-machine',
    isPopular: true,
    problems: ['Not draining', 'Not spinning', 'Strange noise', 'No power', 'Water leaking'],
  },
  {
    slug: 'mechanic',
    name: 'Mechanic',
    description: 'Bikes and vehicles',
    iconKey: 'mechanic',
    isPopular: true,
    problems: ['Will not start', 'Battery problem', 'Flat tyre', 'Breakdown on the road', 'Regular service'],
  },
  {
    slug: 'fans-lights',
    name: 'Fans and lights',
    description: 'Install and repair',
    iconKey: 'fan',
    isPopular: false,
    problems: ['Install a fan', 'Fan not working', 'Install lights', 'Light not working'],
  },
  {
    slug: 'doors-locks',
    name: 'Doors and locks',
    description: 'Locks, handles, hinges',
    iconKey: 'lock',
    isPopular: false,
    problems: ['Locked out', 'Broken lock', 'Door not closing', 'Replace handle or hinge'],
  },
  {
    slug: 'general',
    name: 'General',
    description: 'Small jobs around the home',
    iconKey: 'general',
    isPopular: true,
    problems: ['Furniture assembly', 'Wall mounting', 'Small repairs'],
  },
];

const DEMO_TECHNICIANS = [
  { phone: '+94770000001', name: 'Kasun Perera', categories: ['electrical', 'fans-lights', 'general'], ratingSum: 1018, ratingCount: 212, jobs: 212 },
  { phone: '+94770000002', name: 'Amal Bandara', categories: ['plumbing', 'general'], ratingSum: 470, ratingCount: 98, jobs: 104 },
  { phone: '+94770000003', name: 'Saman Kumara', categories: ['ac', 'refrigerators', 'washing-machines'], ratingSum: 690, ratingCount: 147, jobs: 160 },
  { phone: '+94770000004', name: 'Nuwan Silva', categories: ['mechanic', 'doors-locks'], ratingSum: 312, ratingCount: 67, jobs: 70 },
];

const slugify = (value: string) =>
  value.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');

async function main() {
  const config = AppConfig.load();
  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString: config.databaseUrl }),
  });

  try {
    for (const [index, category] of CATEGORIES.entries()) {
      const { problems, ...fields } = category;
      const saved = await prisma.serviceCategory.upsert({
        where: { slug: category.slug },
        update: { ...fields, sortOrder: index },
        create: { ...fields, sortOrder: index, visitFeeCents: VISIT_FEE_CENTS },
      });
      for (const [problemIndex, name] of [...problems, 'Something else'].entries()) {
        const slug = slugify(name);
        await prisma.problemType.upsert({
          where: { categoryId_slug: { categoryId: saved.id, slug } },
          update: { name, sortOrder: problemIndex },
          create: { categoryId: saved.id, slug, name, sortOrder: problemIndex },
        });
      }
    }
    console.log(`Seeded ${CATEGORIES.length} service categories`);

    if (config.nodeEnv === 'production') return;

    const categories = await prisma.serviceCategory.findMany({
      select: { id: true, slug: true },
    });
    const idBySlug = new Map(categories.map((c) => [c.slug, c.id]));

    for (const demo of DEMO_TECHNICIANS) {
      const user = await prisma.user.upsert({
        where: { phoneNumber: demo.phone },
        update: { fullName: demo.name },
        create: {
          phoneNumber: demo.phone,
          fullName: demo.name,
          role: 'TECHNICIAN',
        },
      });
      const technician = await prisma.technician.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          displayName: demo.name,
          status: 'VERIFIED',
          isOnline: true,
          latitude: 6.8741,
          longitude: 79.8606,
          ratingSum: demo.ratingSum,
          ratingCount: demo.ratingCount,
          jobsCompleted: demo.jobs,
        },
      });
      await prisma.technicianService.createMany({
        data: demo.categories.map((slug) => ({
          technicianId: technician.id,
          categoryId: idBySlug.get(slug)!,
        })),
        skipDuplicates: true,
      });
    }
    console.log(`Seeded ${DEMO_TECHNICIANS.length} demo technicians (development only)`);
  } finally {
    await prisma.$disconnect();
  }
}

await main();
