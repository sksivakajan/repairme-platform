export type LegalDocumentStatus = 'DRAFT' | 'PUBLISHED' | 'ARCHIVED';

export interface LegalDocument {
  id: string;
  /** Stable key the apps use: terms, privacy, cancellation, refund, payment, data-deletion. */
  type: string;
  title: string;
  version: string;
  /** ISO dates. */
  effectiveDate: string;
  lastUpdated: string;
  status: LegalDocumentStatus;
  /** Customers must accept this document (and its newer versions). */
  requiresAcceptance: boolean;
  /**
   * Text with a tiny markup: "## Heading", "### Subheading", "- bullet",
   * blank line between paragraphs. [Square brackets] are placeholders for
   * company details the apps fill in from configuration.
   */
  content: string;
}

const SAMPLE_DATE = '2026-10-05';

/**
 * SAMPLE / PROTOTYPE TEXT. These documents have NOT been reviewed by a lawyer.
 * Before launch they must be replaced with final policies that match
 * RepairMe's registered business, service model, payment provider, data
 * practices and applicable Sri Lankan law. Bump `version` whenever the text
 * changes in a way customers must re-accept.
 */
export const LEGAL_DOCUMENTS: readonly LegalDocument[] = [
  {
    id: 'legal-terms-1',
    type: 'terms',
    title: 'Terms & Conditions',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: true,
    content: `Welcome to RepairMe.

These Terms & Conditions govern access to and use of the RepairMe application and related services.

By creating an account, accessing RepairMe or requesting a service through the platform, you agree to these Terms & Conditions.

## 1. About RepairMe

RepairMe is a technology platform designed to help customers discover, request and connect with technicians and service professionals for repair and maintenance services.

Available services may include electrical work, plumbing, air-conditioning and refrigeration repair, appliance repair, mechanical services, roadside assistance and other supported repair or maintenance categories.

Service availability may depend on location, service type and technician availability.

## 2. User Accounts

Users may create an account using a valid mobile number.

RepairMe may verify mobile-number ownership through OTP verification.

Users are responsible for providing accurate account information and protecting access to their devices/accounts.

Users must not intentionally use another person's mobile number or impersonate another person.

## 3. Service Requests

RepairMe may support:

- Emergency requests
- Scheduled requests
- Measurement or inspection requests

Customers must provide reasonably accurate information about:

- Problem/service required
- Location
- Relevant instructions
- Safety concerns

Submitting a request does not guarantee immediate technician availability.

## 4. Technicians

RepairMe may perform verification procedures for technicians using the platform.

Verification does not guarantee that every service will be error-free.

Technicians remain responsible for carrying out agreed services professionally and safely.

## 5. Pricing & Estimates

Some services may have fixed pricing.

Other services may require inspection or measurement before a final price is available.

Where additional work, materials or charges become necessary, customers should be informed before additional chargeable work is performed.

## 6. Payments

RepairMe may support:

- Cash
- Card
- Approved online/digital payments

Payment availability may vary.

Third-party payment providers may have their own terms and security requirements.

## 7. Cancellations

Bookings may be cancelled according to the RepairMe Cancellation Policy.

A cancellation or call-out fee may apply in certain circumstances, including where a technician has already travelled to or arrived at the service location.

## 8. Customer Responsibilities

Customers should:

- Provide accurate information.
- Provide an accessible service location.
- Provide a reasonably safe working environment.
- Treat technicians respectfully.
- Pay legitimate agreed charges.
- Avoid requesting unlawful or dangerous services.

## 9. Prohibited Activities

Users must not:

- Commit fraud.
- Make intentionally false bookings.
- Harass technicians or other users.
- Manipulate ratings.
- Manipulate payments.
- Attempt unauthorized account access.
- Use RepairMe for unlawful purposes.

RepairMe may suspend or restrict accounts where serious misuse, fraud or safety concerns are identified.

## 10. Ratings & Reviews

Customers may rate technicians after completed services.

Reviews should represent genuine experiences.

RepairMe may moderate content that is fraudulent, abusive, unlawful or otherwise violates platform rules.

## 11. Complaints

Customers can report service problems through:

Profile → Help & Support

RepairMe may review booking information and relevant records when investigating complaints.

## 12. Applicable Rights

Nothing in these Terms is intended to exclude rights or remedies that cannot legally be excluded.

## 13. Changes

RepairMe may update these Terms as services, technology or legal requirements change.

Users may be notified of material updates where appropriate.

## 14. Contact

RepairMe

Email: [Official Email]

Phone: [Official Phone]

Address: [Official Address]`,
  },
  {
    id: 'legal-privacy-1',
    type: 'privacy',
    title: 'Privacy Policy',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: true,
    content: `RepairMe respects user privacy.

This Privacy Policy describes information RepairMe may collect and how that information may be used, disclosed and protected.

## 1. Information We May Collect

### Account Information

- First Name
- Last Name
- Mobile Number
- Email
- Birthday
- Gender
- Preferred Language

### Booking Information

- Service requests
- Booking history
- Technician assignments
- Service status
- Ratings
- Reviews

### Location Information

- Saved addresses
- Selected service location
- Map coordinates
- Location information when permission is provided

### Emergency Contact

- Contact name
- Relationship
- Mobile number

Users should have appropriate permission to provide another person's information.

### Technical Information

RepairMe may process relevant technical information such as:

- Device/app information
- Application version
- Security/login records
- Diagnostics
- Relevant application activity

### Payment Information

Payment transactions may be processed through approved third-party payment providers.

RepairMe should avoid storing complete card numbers or sensitive card authentication information when secure provider-hosted/tokenized payment functionality is available.

## 2. How Information May Be Used

RepairMe may use information to:

- Create accounts.
- Authenticate users.
- Verify mobile numbers.
- Process bookings.
- Connect customers and technicians.
- Provide location-related functionality.
- Process/facilitate payments.
- Provide customer support.
- Improve services.
- Prevent fraud.
- Maintain security.
- Send necessary service communications.
- Meet applicable legal obligations.

## 3. Location Information

With appropriate device permission, RepairMe may use location information to:

- Determine service location.
- Show nearby/appropriate technicians.
- Support technician navigation.
- Improve booking functionality.

Users should be able to manage device location permission through operating-system settings.

## 4. Information Sharing

Information may be shared where reasonably necessary with:

- Assigned/relevant technicians
- Payment providers
- Hosting/infrastructure providers
- Support providers
- Authorities where legally required

Only information reasonably necessary for the relevant purpose should be shared.

## 5. Security

RepairMe should use reasonable technical and organizational safeguards designed to protect user information.

No internet-based service can guarantee absolute security.

## 6. Retention

Information should be retained only for as long as reasonably necessary for operational, contractual, security and legal purposes.

Final production retention periods must be defined before launch.

## 7. Account Deletion

Users may request account deletion through:

Profile → Personal Information → Delete Account

Some information may be retained where required or permitted for legal, fraud-prevention, accounting, security or dispute-resolution purposes.

## 8. User Choices

Depending on functionality, users may be able to:

- Update personal information.
- Manage notification preferences.
- Manage saved addresses.
- Manage device permissions.
- Request account deletion.
- Contact RepairMe about privacy matters.

## 9. Children

RepairMe should not knowingly collect information from children where use would require parental/guardian authorization under applicable requirements.

Final minimum-age requirements must be determined before production.

## 10. Policy Updates

This Privacy Policy may be updated as RepairMe changes.

Material changes may be communicated where appropriate.

## 11. Contact

Privacy Email: [Official Privacy Email]

Phone: [Official Phone]

Address: [Official Address]`,
  },
  {
    id: 'legal-cancellation-1',
    type: 'cancellation',
    title: 'Cancellation Policy',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: false,
    content: `RepairMe understands that plans can change.

## Before Technician Acceptance

Customers may normally cancel before technician acceptance without a cancellation fee unless otherwise stated for a particular service.

## After Technician Acceptance

A cancellation fee may apply depending on the booking circumstances.

## Technician Travelling

If the technician has already started travelling, a reasonable cancellation/travel fee may apply where appropriate.

## Technician Arrived

If the technician has arrived, a call-out, inspection or cancellation fee may apply.

## Emergency Bookings

Emergency bookings may have stricter cancellation conditions because technicians may be dispatched immediately.

Applicable charges should be communicated clearly where reasonably possible.

## Technician Cancellation

If the technician cancels, RepairMe may attempt to find another technician.

Customers should not receive a customer cancellation fee where cancellation is caused solely by RepairMe or the assigned technician.

## Exceptional Circumstances

Support may review fees in exceptional circumstances.

Final cancellation windows and fee amounts must be configurable rather than hardcoded into this prototype policy.`,
  },
  {
    id: 'legal-refund-1',
    type: 'refund',
    title: 'Refund Policy',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: false,
    content: `Refund eligibility depends on the booking, payment method and circumstances.

A refund may be considered where:

- A duplicate payment occurred.
- A payment was taken but the relevant service could not be provided.
- A confirmed billing error occurred.
- RepairMe determines after review that a refund is appropriate.

Refunds may not normally be provided simply because a customer changes their mind after agreed work has been satisfactorily completed.

## Requesting a Refund

Navigate to:

Profile → Help & Support → Payment Issue

Provide:

- Booking ID
- Payment/transaction reference
- Description
- Supporting evidence where relevant

## Processing

Approved refunds should normally be returned through the original payment method where technically possible.

Processing times depend on the payment provider and financial institution.

No fixed refund processing period is promised until the selected payment provider's actual rules are confirmed.`,
  },
  {
    id: 'legal-payment-1',
    type: 'payment',
    title: 'Payment Policy',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: false,
    content: `RepairMe may support:

- Cash
- Card
- Approved online/digital payment methods

## Pricing

Customers should receive available pricing information before confirming a service where reasonably possible.

Some jobs require technician inspection or measurement before final pricing.

## Additional Work

If additional work/materials are needed, the technician/customer flow should communicate updated pricing before additional chargeable work proceeds.

## Digital Payments

Digital payments may be processed through approved third-party payment providers.

RepairMe should use secure payment integrations and should avoid directly storing complete card credentials where provider tokenization/hosted payment functionality is available.

## Receipts

Eligible completed transactions should provide customers with payment confirmation or receipt information.

## Payment Problems

Navigate to:

Profile → Help & Support → Payment Issue

Provide booking ID and transaction information.`,
  },
  {
    id: 'legal-data-deletion-1',
    type: 'data-deletion',
    title: 'Account & Data Deletion',
    version: '1.0',
    effectiveDate: SAMPLE_DATE,
    lastUpdated: SAMPLE_DATE,
    status: 'PUBLISHED',
    requiresAcceptance: false,
    content: `RepairMe users may request account deletion through the application.

Navigate to:

Profile → Personal Information → Delete Account

## Deletion Process

- Select Delete Account.
- Review deletion information.
- Select a reason.
- Confirm deletion.
- Verify identity using OTP.
- Process/submit deletion.
- Revoke session.
- Return to authentication screen.

## Information That May Be Deleted or Anonymized

Depending on approved policy:

- Profile information
- Saved addresses
- Emergency contact
- Preferences
- Other personal account information

Certain records may need to be retained where required or permitted for:

- Accounting
- Fraud prevention
- Security
- Legal obligations
- Transaction records
- Disputes

The final production retention schedule must be established before launch.

## Registering Again

If a customer registers again with the same phone number after deletion, the application follows RepairMe's account deletion/retention policy.

A deleted profile is not automatically restored unless the approved policy allows it.`,
  },
];
