import {
  canTransition,
  CUSTOMER_CANCELLABLE,
  formatLkr,
  formatReference,
} from './booking-status.js';

describe('booking lifecycle', () => {
  it('allows the happy path from request to payment', () => {
    const path = [
      'SEARCHING',
      'ASSIGNED',
      'EN_ROUTE',
      'ARRIVED',
      'AWAITING_APPROVAL',
      'IN_PROGRESS',
      'COMPLETED',
      'PAID',
    ] as const;
    for (let i = 0; i < path.length - 1; i++) {
      expect(canTransition(path[i], path[i + 1])).toBe(true);
    }
  });

  it('allows operator escalation, declined quotes and visit-fee-only jobs', () => {
    expect(canTransition('SEARCHING', 'OPERATOR_ASSIGNING')).toBe(true);
    expect(canTransition('OPERATOR_ASSIGNING', 'ASSIGNED')).toBe(true);
    expect(canTransition('AWAITING_APPROVAL', 'ARRIVED')).toBe(true);
    expect(canTransition('ARRIVED', 'COMPLETED')).toBe(true);
    expect(canTransition('IN_PROGRESS', 'AWAITING_APPROVAL')).toBe(true);
  });

  it('rejects skipping steps and leaving terminal states', () => {
    expect(canTransition('SEARCHING', 'ARRIVED')).toBe(false);
    expect(canTransition('ASSIGNED', 'COMPLETED')).toBe(false);
    expect(canTransition('COMPLETED', 'CANCELLED')).toBe(false);
    expect(canTransition('PAID', 'CANCELLED')).toBe(false);
    expect(canTransition('CANCELLED', 'SEARCHING')).toBe(false);
  });

  it('only lets customers cancel before the technician arrives', () => {
    expect(CUSTOMER_CANCELLABLE).toContain('EN_ROUTE');
    expect(CUSTOMER_CANCELLABLE).not.toContain('ARRIVED');
  });

  it('formats references and rupee amounts', () => {
    expect(formatReference(124)).toBe('RM-00124');
    expect(formatLkr(325000)).toBe('Rs. 3,250');
    expect(formatLkr(12550)).toBe('Rs. 125.50');
  });
});
