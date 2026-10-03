import { BookingStatus } from '../generated/prisma/client.js';

/**
 * The booking lifecycle. Every status change goes through canTransition so
 * the rules live in one place.
 *
 * SEARCHING ─▶ ASSIGNED ─▶ EN_ROUTE ─▶ ARRIVED ─▶ AWAITING_APPROVAL ─▶ IN_PROGRESS ─▶ COMPLETED ─▶ PAID
 *     │            ▲                     ▲  │            │      ▲            │
 *     ▼            │                     │  └────────────┼──────┼────────────┤ (visit-fee only)
 * OPERATOR_ASSIGNING                     └── declined ───┘      └─ cost changed
 */
const TRANSITIONS: Record<BookingStatus, readonly BookingStatus[]> = {
  SEARCHING: ['OPERATOR_ASSIGNING', 'ASSIGNED', 'CANCELLED'],
  OPERATOR_ASSIGNING: ['ASSIGNED', 'CANCELLED'],
  ASSIGNED: ['EN_ROUTE', 'CANCELLED'],
  EN_ROUTE: ['ARRIVED', 'CANCELLED'],
  ARRIVED: ['AWAITING_APPROVAL', 'COMPLETED', 'CANCELLED'],
  AWAITING_APPROVAL: ['IN_PROGRESS', 'ARRIVED', 'CANCELLED'],
  IN_PROGRESS: ['AWAITING_APPROVAL', 'COMPLETED', 'CANCELLED'],
  COMPLETED: ['PAID'],
  PAID: [],
  CANCELLED: [],
};

/** Statuses in which the customer may still cancel (before the technician arrives). */
export const CUSTOMER_CANCELLABLE: readonly BookingStatus[] = [
  'SEARCHING',
  'OPERATOR_ASSIGNING',
  'ASSIGNED',
  'EN_ROUTE',
];

/** Statuses in which a technician is attached and chat is open. */
export const CHAT_OPEN: readonly BookingStatus[] = [
  'ASSIGNED',
  'EN_ROUTE',
  'ARRIVED',
  'AWAITING_APPROVAL',
  'IN_PROGRESS',
  'COMPLETED',
];

/** Statuses in which the customer sees the job code (until it is verified on arrival). */
export const JOB_CODE_VISIBLE: readonly BookingStatus[] = [
  'ASSIGNED',
  'EN_ROUTE',
];

/** Statuses in which the customer may still add problem photos. */
export const PHOTOS_OPEN: readonly BookingStatus[] = [
  'SEARCHING',
  'OPERATOR_ASSIGNING',
  'ASSIGNED',
  'EN_ROUTE',
];

export const BOOKING_TABS = {
  active: [
    'SEARCHING',
    'OPERATOR_ASSIGNING',
    'ASSIGNED',
    'EN_ROUTE',
    'ARRIVED',
    'AWAITING_APPROVAL',
    'IN_PROGRESS',
    'COMPLETED',
  ],
  completed: ['PAID'],
  cancelled: ['CANCELLED'],
} as const satisfies Record<string, readonly BookingStatus[]>;

export type BookingTab = keyof typeof BOOKING_TABS;

export function canTransition(from: BookingStatus, to: BookingStatus): boolean {
  return TRANSITIONS[from].includes(to);
}

export function formatReference(referenceNumber: number): string {
  return `RM-${String(referenceNumber).padStart(5, '0')}`;
}

export function formatLkr(cents: number): string {
  const rupees = cents / 100;
  return `Rs. ${rupees.toLocaleString('en-US', {
    minimumFractionDigits: Number.isInteger(rupees) ? 0 : 2,
    maximumFractionDigits: 2,
  })}`;
}
