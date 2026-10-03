import type { Prisma } from '../generated/prisma/client.js';
import {
  CHAT_OPEN,
  CUSTOMER_CANCELLABLE,
  formatReference,
  JOB_CODE_VISIBLE,
  PHOTOS_OPEN,
} from './booking-status.js';

const technicianSelect = {
  id: true,
  displayName: true,
  ratingSum: true,
  ratingCount: true,
  jobsCompleted: true,
  userId: true,
} satisfies Prisma.TechnicianSelect;

type TechnicianRow = Prisma.TechnicianGetPayload<{
  select: typeof technicianSelect;
}>;

function technicianView(technician: TechnicianRow | null) {
  if (!technician) return null;
  return {
    id: technician.id,
    displayName: technician.displayName,
    rating:
      technician.ratingCount > 0
        ? Math.round((technician.ratingSum / technician.ratingCount) * 10) / 10
        : null,
    ratingCount: technician.ratingCount,
    jobsCompleted: technician.jobsCompleted,
  };
}

// ─── List ────────────────────────────────────────────────────────────────────

export const bookingSummaryInclude = {
  category: { select: { name: true, slug: true, iconKey: true } },
  problemType: { select: { name: true } },
  technician: { select: technicianSelect },
  payment: { select: { amountCents: true, status: true } },
} satisfies Prisma.BookingInclude;

type BookingSummaryRow = Prisma.BookingGetPayload<{
  include: typeof bookingSummaryInclude;
}>;

export function bookingSummaryView(booking: BookingSummaryRow) {
  return {
    id: booking.id,
    reference: formatReference(booking.referenceNumber),
    type: booking.type,
    status: booking.status,
    title: booking.problemType?.name ?? booking.category.name,
    category: booking.category,
    technician: technicianView(booking.technician),
    addressArea: booking.addressArea,
    scheduledStart: booking.scheduledStart,
    scheduledEnd: booking.scheduledEnd,
    totalCents: booking.payment?.amountCents ?? null,
    cancelledBy: booking.cancelledBy,
    createdAt: booking.createdAt,
  };
}

// ─── Detail ──────────────────────────────────────────────────────────────────

export const bookingDetailInclude = {
  ...bookingSummaryInclude,
  events: {
    orderBy: { createdAt: 'asc' },
    select: { status: true, note: true, createdAt: true },
  },
  photos: {
    orderBy: { createdAt: 'asc' },
    select: { id: true, kind: true, createdAt: true },
  },
  quotations: {
    orderBy: { version: 'desc' },
    take: 1,
    include: { items: { orderBy: { id: 'asc' } } },
  },
  payment: true,
  review: { select: { rating: true, tags: true, comment: true, createdAt: true } },
} satisfies Prisma.BookingInclude;

type BookingDetailRow = Prisma.BookingGetPayload<{
  include: typeof bookingDetailInclude;
}>;

export function bookingDetailView(
  booking: BookingDetailRow,
  unreadMessages: number,
) {
  const quotation = booking.quotations[0] ?? null;
  return {
    ...bookingSummaryView(booking),
    description: booking.description,
    symptoms: booking.symptoms,
    address: {
      line1: booking.addressLine1,
      area: booking.addressArea,
      city: booking.addressCity,
      houseNumber: booking.houseNumber,
      landmark: booking.landmark,
      latitude: booking.latitude?.toNumber() ?? null,
      longitude: booking.longitude?.toNumber() ?? null,
    },
    paymentMethod: booking.paymentMethod,
    visitFeeCents: booking.visitFeeCents,
    etaMinutes: booking.etaMinutes,
    jobCode: JOB_CODE_VISIBLE.includes(booking.status) ? booking.jobCode : null,
    cancelReason: booking.cancelReason,
    events: booking.events,
    photos: booking.photos,
    quotation: quotation && {
      id: quotation.id,
      version: quotation.version,
      status: quotation.status,
      note: quotation.note,
      visitFeeCents: quotation.visitFeeCents,
      labourCents: quotation.labourCents,
      partsCents: quotation.partsCents,
      totalCents: quotation.totalCents,
      items: quotation.items.map((item) => ({
        description: item.description,
        quantity: item.quantity,
        unitPriceCents: item.unitPriceCents,
        totalCents: item.quantity * item.unitPriceCents,
      })),
      createdAt: quotation.createdAt,
      decidedAt: quotation.decidedAt,
    },
    payment: booking.payment && {
      method: booking.payment.method,
      status: booking.payment.status,
      amountCents: booking.payment.amountCents,
      paidAt: booking.payment.paidAt,
    },
    review: booking.review,
    unreadMessages,
    canCancel: CUSTOMER_CANCELLABLE.includes(booking.status),
    canChat: booking.technician !== null && CHAT_OPEN.includes(booking.status),
    canAddPhotos: PHOTOS_OPEN.includes(booking.status),
  };
}
