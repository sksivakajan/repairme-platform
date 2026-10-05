// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get tryAgain => 'Try again';

  @override
  String stepOf(String step, String label) {
    return 'Step $step of 4 · $label';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get send => 'Send';

  @override
  String get edit => 'Edit';

  @override
  String get currencyPrefix => 'Rs.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get visitFee => 'Visit fee';

  @override
  String get labour => 'Labour';

  @override
  String get parts => 'Parts';

  @override
  String get total => 'Total';

  @override
  String get statusFinding => 'FINDING';

  @override
  String get statusAssigning => 'ASSIGNING';

  @override
  String get statusAssigned => 'ASSIGNED';

  @override
  String get statusScheduled => 'SCHEDULED';

  @override
  String get statusOnTheWay => 'ON THE WAY';

  @override
  String get statusWorking => 'WORKING';

  @override
  String get statusPaymentDue => 'PAYMENT DUE';

  @override
  String get statusCompleted => 'COMPLETED';

  @override
  String get statusCancelled => 'CANCELLED';

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get chooseService => 'Choose a service';

  @override
  String get searchService => 'Search for a service...';

  @override
  String get noMatchingService => 'No matching service';

  @override
  String get tabActive => 'Active';

  @override
  String get tabCompleted => 'Completed';

  @override
  String get tabCancelled => 'Cancelled';

  @override
  String get noActiveBookings => 'No active bookings';

  @override
  String get noCompletedJobs => 'No completed jobs yet';

  @override
  String get noCancelledBookings => 'No cancelled bookings';

  @override
  String get needAnotherRepair => 'Need another repair?';

  @override
  String get bookTechnicianHint =>
      'Book a verified technician in about 2 minutes.';

  @override
  String get cancelledByYou => 'Cancelled by you';

  @override
  String get notifications => 'Notifications';

  @override
  String get readAll => 'Read all';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get groupToday => 'TODAY';

  @override
  String get groupEarlier => 'EARLIER';

  @override
  String get support => 'Support';

  @override
  String get callRepairMe => 'Call RepairMe';

  @override
  String get open24Hours => 'Open 24 hours';

  @override
  String callNumber(String phone) {
    return 'Call $phone';
  }

  @override
  String get writeToUs => 'Write to us';

  @override
  String get repliesInMinutes => 'Replies in minutes';

  @override
  String get yourTickets => 'Your tickets';

  @override
  String get ticketResolved => 'RESOLVED';

  @override
  String get ticketOpen => 'OPEN';

  @override
  String get commonQuestions => 'Common questions';

  @override
  String get faqReportQ => 'Report a problem with a booking';

  @override
  String get faqReportA =>
      'Open the booking and use \"Report a problem\", or create a ticket below. Our team replies within minutes during the day.';

  @override
  String get faqPriceQ => 'How is the price calculated?';

  @override
  String get faqPriceA =>
      'Every visit has a Rs. 500 visit fee. Labour and parts are quoted by the technician on site, and nothing is charged until you approve the cost in the app.';

  @override
  String get faqVerifiedQ => 'How are technicians verified?';

  @override
  String get faqVerifiedA =>
      'Every RepairMe technician is ID-checked and their trade documents are reviewed by our team before they can accept jobs.';

  @override
  String get faqRefundsQ => 'Refunds and cancellations';

  @override
  String get faqRefundsA =>
      'Cancelling before a technician arrives is free. Every completed job has a 7-day workmanship cover: if the same fault returns, we send someone back at no labour cost.';

  @override
  String get writeToRepairMe => 'Write to RepairMe';

  @override
  String get subject => 'Subject';

  @override
  String get ticketMessageHint =>
      'Tell us what happened (at least 10 characters)';

  @override
  String get ticketThanks => 'Thanks — our team will get back to you shortly';

  @override
  String get addYourName => 'Add your name';

  @override
  String get phoneVerified => 'Phone verified';

  @override
  String get addresses => 'Addresses';

  @override
  String get savedAddresses => 'Saved addresses';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get cash => 'Cash';

  @override
  String get helpAndSupport => 'Help & support';

  @override
  String get language => 'Language';

  @override
  String get termsAndPrivacy => 'Terms and privacy';

  @override
  String get logOut => 'Log out';

  @override
  String get yourName => 'Your name';

  @override
  String get fullName => 'Full name';

  @override
  String get noSavedAddresses => 'No saved addresses';

  @override
  String get noSavedAddressesHint =>
      'Addresses you use for bookings are saved here.';

  @override
  String addressDefault(String label) {
    return '$label · Default';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceSystem => 'System';

  @override
  String get greetMorning => 'Good morning';

  @override
  String get greetAfternoon => 'Good afternoon';

  @override
  String get greetEvening => 'Good evening';

  @override
  String get welcome => 'Welcome';

  @override
  String get addYourAddress => 'Add your address';

  @override
  String get services => 'Services';

  @override
  String get seeAll => 'See all';

  @override
  String get viewAll => 'View all';

  @override
  String get topRatedTechnicians => 'Top rated technicians';

  @override
  String notificationsUnread(String n) {
    return 'Notifications, $n unread';
  }

  @override
  String technicianRated(String name, String trade, String rating) {
    return '$name, $trade, rated $rating';
  }

  @override
  String get bookNow => 'Book now';

  @override
  String get getHelpNow => 'Get help now';

  @override
  String useCode(String code) {
    return 'Use code $code';
  }

  @override
  String get offerNewTag => 'NEW CUSTOMER OFFER';

  @override
  String get offerNewTitle => '20% OFF';

  @override
  String get offerNewSub => 'Your first booking';

  @override
  String get offerHomeTag => 'HOME REPAIRS';

  @override
  String get offerHomeTitle => 'Free inspection';

  @override
  String get offerHomeSub => 'On any home repair this month';

  @override
  String get bookTechnician => 'Book a technician';

  @override
  String get offerRoadTag => 'ROADSIDE ASSIST';

  @override
  String get offerRoadTitle => 'Rs. 500 OFF';

  @override
  String get offerRoadSub => 'Breakdown & towing, 24/7';

  @override
  String get teamLine1 => 'Built in Sri Lanka,';

  @override
  String get teamLine2 => 'for every Sri Lankan';

  @override
  String get meetTheTeam => 'Meet the team';

  @override
  String get emergencyTag => 'EMERGENCY';

  @override
  String get needHelpNow => 'Need help right now?';

  @override
  String techniciansOnline(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n technicians online',
      one: '1 technician online',
    );
    return '$_temp0 · avg. 18 min';
  }

  @override
  String get verifiedTechniciansAllDay =>
      'Verified technicians, 24 hours a day';

  @override
  String get brandTagline => 'Verified expertise. Trusted integrity.';

  @override
  String get chipVerified => 'Verified';

  @override
  String get chipFast => 'Fast';

  @override
  String get chipTrusted => 'Trusted';

  @override
  String get topTechInfo =>
      'When you book, we match you with the nearest available verified technician.';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String tradeAndJobs(String trade, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jobs',
      one: '1 job',
    );
    return '$trade · $_temp0';
  }

  @override
  String get tradeElectrician => 'Electrician';

  @override
  String get tradePlumber => 'Plumber';

  @override
  String get tradeAc => 'AC technician';

  @override
  String get tradeAppliance => 'Appliance repair';

  @override
  String get tradeMechanic => 'Mechanic';

  @override
  String get tradeLocksmith => 'Locksmith';

  @override
  String get tradeCarpenter => 'Carpenter';

  @override
  String get tradeHandyman => 'Handyman';

  @override
  String get tradeTechnician => 'Technician';

  @override
  String get categoryElectricalName => 'Electrical';

  @override
  String get categoryElectricalDescription => 'Wiring, sockets, breakers';

  @override
  String get categoryPlumbingName => 'Plumbing';

  @override
  String get categoryPlumbingDescription => 'Taps, pipes, leaks';

  @override
  String get categoryAcName => 'AC';

  @override
  String get categoryAcDescription => 'Service, gas, repairs';

  @override
  String get categoryRefrigeratorsName => 'Refrigerators';

  @override
  String get categoryRefrigeratorsDescription => 'Not cooling, leaks';

  @override
  String get categoryWashingMachinesName => 'Washing machines';

  @override
  String get categoryWashingMachinesDescription => 'Drain, noise, no power';

  @override
  String get categoryMechanicName => 'Mechanic';

  @override
  String get categoryMechanicDescription => 'Bikes and vehicles';

  @override
  String get categoryFansLightsName => 'Fans and lights';

  @override
  String get categoryFansLightsDescription => 'Install and repair';

  @override
  String get categoryDoorsLocksName => 'Doors and locks';

  @override
  String get categoryDoorsLocksDescription => 'Locks, handles, hinges';

  @override
  String get categoryGeneralName => 'General';

  @override
  String get categoryGeneralDescription => 'Small jobs around the home';

  @override
  String get problemBreakerKeepsTripping => 'Breaker keeps tripping';

  @override
  String get problemSocketNotWorking => 'Socket not working';

  @override
  String get problemLightOrFanFault => 'Light or fan fault';

  @override
  String get problemPowerOutage => 'Power outage';

  @override
  String get problemNewWiringOrPoints => 'New wiring or points';

  @override
  String get problemLeakingTap => 'Leaking tap';

  @override
  String get problemBurstOrLeakingPipe => 'Burst or leaking pipe';

  @override
  String get problemBlockedDrain => 'Blocked drain';

  @override
  String get problemToiletOrCisternFault => 'Toilet or cistern fault';

  @override
  String get problemWaterPumpProblem => 'Water pump problem';

  @override
  String get problemNotCooling => 'Not cooling';

  @override
  String get problemWaterLeaking => 'Water leaking';

  @override
  String get problemStrangeNoise => 'Strange noise';

  @override
  String get problemRegularService => 'Regular service';

  @override
  String get problemGasRefill => 'Gas refill';

  @override
  String get problemNotTurningOn => 'Not turning on';

  @override
  String get problemNotDraining => 'Not draining';

  @override
  String get problemNotSpinning => 'Not spinning';

  @override
  String get problemNoPower => 'No power';

  @override
  String get problemWillNotStart => 'Will not start';

  @override
  String get problemBatteryProblem => 'Battery problem';

  @override
  String get problemFlatTyre => 'Flat tyre';

  @override
  String get problemBreakdownOnTheRoad => 'Breakdown on the road';

  @override
  String get problemInstallAFan => 'Install a fan';

  @override
  String get problemFanNotWorking => 'Fan not working';

  @override
  String get problemInstallLights => 'Install lights';

  @override
  String get problemLightNotWorking => 'Light not working';

  @override
  String get problemLockedOut => 'Locked out';

  @override
  String get problemBrokenLock => 'Broken lock';

  @override
  String get problemDoorNotClosing => 'Door not closing';

  @override
  String get problemReplaceHandleOrHinge => 'Replace handle or hinge';

  @override
  String get problemFurnitureAssembly => 'Furniture assembly';

  @override
  String get problemWallMounting => 'Wall mounting';

  @override
  String get problemSmallRepairs => 'Small repairs';

  @override
  String get problemSomethingElse => 'Something else';

  @override
  String get symptomBurningSmell => 'Burning smell';

  @override
  String get symptomSparksSeen => 'Sparks seen';

  @override
  String get symptomOnlyOneRoom => 'Only one room';

  @override
  String get symptomHappenedBefore => 'Happened before';

  @override
  String get symptomWaterLeakingNow => 'Water leaking now';

  @override
  String get symptomLowPressure => 'Low pressure';

  @override
  String get symptomBadSmell => 'Bad smell';

  @override
  String get symptomWaterDripping => 'Water dripping';

  @override
  String get symptomWaterOnFloor => 'Water on floor';

  @override
  String get symptomIceBuildUp => 'Ice build-up';

  @override
  String get symptomNoisy => 'Noisy';

  @override
  String get symptomErrorCodeShown => 'Error code shown';

  @override
  String get symptomVehicleAtHome => 'Vehicle at home';

  @override
  String get symptomVehicleOnTheRoad => 'Vehicle on the road';

  @override
  String get symptomWarningLightOn => 'Warning light on';

  @override
  String get symptomUrgent => 'Urgent';

  @override
  String get symptomNeedParts => 'Need parts';

  @override
  String get onboard1Title => 'Help in minutes, not days';

  @override
  String get onboard1Body =>
      'Pipe burst or power gone? Press Emergency and the nearest verified technician is on the way.';

  @override
  String get onboard2Title => 'Book a time that suits you';

  @override
  String get onboard2Body =>
      'Choose a day and an arrival window for repairs, servicing, or an inspection and quote first.';

  @override
  String get onboard3Title => 'Verified. And you stay in control';

  @override
  String get onboard3Body =>
      'Every technician is ID-checked. You approve the cost before any work is charged.';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get started';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get welcomeToRepairMe => 'Welcome to RepairMe';

  @override
  String get homeRepairsSimple => 'Home repairs, made simple';

  @override
  String get enterMobile => 'Enter your mobile number';

  @override
  String get oneTimeCodeNote => 'We\'ll send you a one-time code';

  @override
  String get sendCode => 'Send code';

  @override
  String get agreePrefix => 'By continuing you agree to our ';

  @override
  String get termsPrivacy => 'Terms & Privacy';

  @override
  String get agreeSuffix => '';

  @override
  String get enterVerificationCode => 'Enter verification code';

  @override
  String sentTo(String phone) {
    return 'Sent to $phone';
  }

  @override
  String get verify => 'Verify';

  @override
  String resendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get newCodeSent => 'A new code is on its way';

  @override
  String authIncorrectCodeDev(String code) {
    return 'Incorrect code. In development use $code.';
  }

  @override
  String get authRequestNewCode => 'Please request a new code.';

  @override
  String get authIncorrectCode =>
      'Incorrect code. Please check the SMS and try again.';

  @override
  String get authInvalidPhone => 'That mobile number is not valid.';

  @override
  String get authTooMany => 'Too many attempts. Please wait and try again.';

  @override
  String get authExpired => 'The code expired. Please request a new one.';

  @override
  String get authFailed => 'Sign-in failed. Please try again.';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get noMessagesHint =>
      'When a technician accepts your booking, you can chat with them here.';

  @override
  String sayHelloTo(String name) {
    return 'Say hello to $name';
  }

  @override
  String youPrefix(String message) {
    return 'You: $message';
  }

  @override
  String get splashTagline => 'FIXED. FAST. VERIFIED.';

  @override
  String get splashProud => 'Proudly Sri Lankan';

  @override
  String get bookingTypeEmergency => 'Emergency';

  @override
  String get bookingTypeSchedule => 'Schedule';

  @override
  String get bookingTypeInspection => 'Inspection';

  @override
  String get addressHome => 'Home';

  @override
  String get addressOffice => 'Work';

  @override
  String get addressOther => 'Other';

  @override
  String get continueLabel => 'Continue';

  @override
  String get requestDetails => 'Request details';

  @override
  String get howSoon => 'How soon do you need help?';

  @override
  String get typeEmergencyBody =>
      'The nearest available technician comes as soon as possible.';

  @override
  String get typeEmergencyHint => 'Avg. arrival 18 min';

  @override
  String get typeScheduledBody =>
      'Choose a date and a time window that suits you.';

  @override
  String get typeScheduledHint => 'Pick a slot';

  @override
  String get typeInspectionBody =>
      'A visit to inspect, measure and give you a quote first.';

  @override
  String get typeInspectionHint => 'Quote before work';

  @override
  String get howPricingWorks => 'How pricing works';

  @override
  String pricingBody(String fee) {
    return 'Visit fee $fee + labour + parts. The technician sends the final cost and you approve it before any work is charged.';
  }

  @override
  String continueWith(String type) {
    return 'Continue with $type';
  }

  @override
  String get stepProblem => 'Problem';

  @override
  String get whatIsProblem => 'What is the problem?';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get detailsHint =>
      'What happened, when it started, anything the technician should know (at least 10 characters)';

  @override
  String get stepPhotos => 'Photos';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get photosSubtitle =>
      'Optional, but it helps the technician bring the right tools and parts.';

  @override
  String get add => 'Add';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get photoTips => 'Tips for good photos';

  @override
  String get photoTipsBody =>
      '· Show the whole area, then a close-up\n· Include any model or label plate\n· Do not touch exposed wires';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get photoOpenError =>
      'Could not open photos. Please check permissions.';

  @override
  String get stepLocation => 'Location';

  @override
  String get whereShouldComeTitle => 'Where should the technician come?';

  @override
  String get yourArea => 'Your area';

  @override
  String get addNew => 'Add new';

  @override
  String get streetAddress => 'Street address';

  @override
  String get areaLabel => 'Area';

  @override
  String get cityLabel => 'City';

  @override
  String get houseNumber => 'House / apartment number';

  @override
  String get landmarkLabel => 'Landmark or directions';

  @override
  String get saveThisAddress => 'Save this address';

  @override
  String get confirmLocation => 'Confirm location';

  @override
  String get inspectionVisit => 'Inspection visit';

  @override
  String get scheduleVisit => 'Schedule a visit';

  @override
  String get whenShouldWeCome => 'When should we come?';

  @override
  String get arrivalWindow => 'Arrival window';

  @override
  String get visitConfirmNote =>
      'The technician will confirm the visit the day before. You can reschedule free until 2 hours before.';

  @override
  String selectedSlot(String when) {
    return 'Selected: $when';
  }

  @override
  String get reviewRequest => 'Review request';

  @override
  String get stepReview => 'Review';

  @override
  String get checkYourRequest => 'Check your request';

  @override
  String photosAttached(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n photos attached',
      one: '1 photo attached',
    );
    return '$_temp0';
  }

  @override
  String get estimatedCost => 'Estimated cost';

  @override
  String get labourAndParts => 'Labour and parts';

  @override
  String get quotedOnSite => 'Quoted on site';

  @override
  String get approveFinalCost =>
      'You will approve the final cost in the app before any work is charged.';

  @override
  String get payWithCash => 'Pay with Cash';

  @override
  String get afterTheJob => 'After the job';

  @override
  String get requestTechnician => 'Request technician';

  @override
  String photosFailed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n photos could not be uploaded',
      one: '1 photo could not be uploaded',
    );
    return '$_temp0';
  }

  @override
  String get theTechnician => 'the technician';

  @override
  String get yourTechnician => 'your technician';

  @override
  String get otherLabel => 'Other';

  @override
  String get bkFinding => 'Finding a technician';

  @override
  String get bkTeamAssigning => 'Team is assigning';

  @override
  String get bkAssigned => 'Technician assigned';

  @override
  String get bkCancelledRequest => 'Cancelled request';

  @override
  String get bkJobStatus => 'Job status';

  @override
  String get stepRequestReceived => 'Request received';

  @override
  String get stepNoTechAccepted => 'No technician accepted';

  @override
  String get stepTeamAssigning => 'RepairMe team assigning';

  @override
  String get stepTechConfirms => 'Technician confirms';

  @override
  String get stepMatchingNearby => 'Matching technicians nearby';

  @override
  String requestRef(String ref) {
    return 'Request #$ref';
  }

  @override
  String get operatorFindingTitle => 'Our team is finding someone for you';

  @override
  String findingVerifiedTitle(String category) {
    return 'Finding a verified $category technician';
  }

  @override
  String get operatorFindingBody =>
      'No technician accepted yet, so a RepairMe operator is assigning one for you. Usually under 2 minutes.';

  @override
  String matchingNear(String area) {
    return 'Matching you with technicians near $area.';
  }

  @override
  String confirmingFor(String when) {
    return 'We are confirming a technician for $when.';
  }

  @override
  String get ifNobodyAccepts =>
      'If nobody accepts, the RepairMe team assigns a technician for you.';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get cancelThisRequest => 'Cancel this request?';

  @override
  String get noChargeNoTech =>
      'No charge, since no technician has been assigned yet.';

  @override
  String noChargeNotArrived(String name) {
    return 'No charge, since $name has not arrived yet.';
  }

  @override
  String get reasonFoundSomeone => 'Found someone else';

  @override
  String get reasonProblemFixed => 'Problem is fixed';

  @override
  String get reasonWaitingTooLong => 'Waiting too long';

  @override
  String get tellUsMoreOptional => 'Tell us more (optional)';

  @override
  String get keepWaiting => 'Keep waiting';

  @override
  String etaMin(String n) {
    return 'ETA $n MIN';
  }

  @override
  String techOnTheWayTitle(String name) {
    return '$name is on the way';
  }

  @override
  String techWillVisit(String name, String when) {
    return '$name will visit $when';
  }

  @override
  String techAccepted(String name) {
    return '$name accepted your request';
  }

  @override
  String arrivesInAbout(String n) {
    return 'Arrives in about $n min';
  }

  @override
  String get viewJobStatus => 'View job status';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String verifiedCategoryTech(String category) {
    return 'Verified $category technician';
  }

  @override
  String get newTech => 'New';

  @override
  String ratingAndJobs(String rating, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jobs',
      one: '1 job',
    );
    return '$rating · $_temp0';
  }

  @override
  String jobCodeShare(String name) {
    return 'Job code · share only when $name arrives';
  }

  @override
  String messageTech(String name) {
    return 'Message $name';
  }

  @override
  String jobNumber(String ref) {
    return 'Job #$ref';
  }

  @override
  String get costReadyTitle => 'Cost ready for your approval';

  @override
  String costReadyBody(String name, String amount) {
    return '$name sent $amount · Tap to review';
  }

  @override
  String get repairCompleted => 'Repair completed';

  @override
  String payTo(String amount, String name) {
    return 'Pay $amount to $name';
  }

  @override
  String get paymentReceived => 'Payment received';

  @override
  String viewReceiptRate(String name) {
    return 'View receipt and rate $name';
  }

  @override
  String get viewReceipt => 'View receipt';

  @override
  String get bookingWasCancelled => 'This booking was cancelled';

  @override
  String get cancelledByYouNoCharge => 'Cancelled by you · no charge';

  @override
  String get cancelledByRepairMe => 'Cancelled by RepairMe';

  @override
  String get tlRequestCreated => 'Request created';

  @override
  String get tlAccepted => 'Technician accepted';

  @override
  String get tlOnTheWay => 'On the way';

  @override
  String get tlArrived => 'Arrived';

  @override
  String tlJobCodeVerified(String time) {
    return 'Job code verified · $time';
  }

  @override
  String get tlWorking => 'Working';

  @override
  String get tlCostApproved => 'Cost approved, work under way';

  @override
  String get tlInspectionDone => 'Inspection done, cost sent';

  @override
  String get tlCompleted => 'Completed';

  @override
  String get tlPayAndRate => 'Pay and rate';

  @override
  String get yourPhotos => 'Your photos';

  @override
  String beforePhotosBy(String name) {
    return 'Before photos by $name';
  }

  @override
  String get afterPhotos => 'After photos';

  @override
  String get requestHeading => 'Request';

  @override
  String get reportProblemWithJob => 'Report a problem with this job';

  @override
  String problemWithRef(String ref) {
    return 'Problem with $ref';
  }

  @override
  String get chat => 'Chat';

  @override
  String onTheWayEta(String n) {
    return 'On the way · ETA $n min';
  }

  @override
  String chatSafety(String name) {
    return 'Messages are recorded for your safety. Never share your job code until $name arrives.';
  }

  @override
  String timeSeen(String time) {
    return '$time · Seen';
  }

  @override
  String get quickAtHome => 'I am at home';

  @override
  String get quickCallMe => 'Call me';

  @override
  String get quickSideGate => 'Use the side gate';

  @override
  String get messageHint => 'Message';

  @override
  String get chatClosed => 'Chat is closed for this booking.';

  @override
  String get declineCostQ => 'Decline this cost?';

  @override
  String get declineCostBody =>
      'The technician will be told. Only the visit fee applies if no work is done.';

  @override
  String get decline => 'Decline';

  @override
  String get costApprovedToast => 'Cost approved. Work continues.';

  @override
  String get costDeclinedToast => 'Cost declined';

  @override
  String get approveCostTitle => 'Approve cost';

  @override
  String get nothingToApprove => 'Nothing to approve right now';

  @override
  String get totalToApprove => 'Total to approve';

  @override
  String noteFrom(String name) {
    return 'Note from $name';
  }

  @override
  String get workStartsAfterApprove =>
      'Work starts only after you approve. If the cost changes, you will be asked again.';

  @override
  String approveAmount(String amount) {
    return 'Approve $amount';
  }

  @override
  String get askQuestion => 'Ask a question';

  @override
  String get payment => 'Payment';

  @override
  String repairCompletedBy(String name) {
    return 'Repair completed by $name';
  }

  @override
  String repairCompletedByAt(String name, String time) {
    return 'Repair completed by $name · $time';
  }

  @override
  String get paymentMethodHeading => 'Payment method';

  @override
  String payTechDirectly(String name) {
    return 'Pay $name directly';
  }

  @override
  String get card => 'Card';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get mobileWallet => 'Mobile wallet';

  @override
  String handCashTo(String amount, String name) {
    return 'Hand $amount to $name. Your receipt appears as soon as they confirm.';
  }

  @override
  String confirmPaymentAmount(String amount) {
    return 'Confirm payment · $amount';
  }

  @override
  String get receipt => 'Receipt';

  @override
  String paidInCash(String amount) {
    return '$amount paid in cash';
  }

  @override
  String paidIn(String amount, String method) {
    return '$amount paid in $method';
  }

  @override
  String receiptNumber(String ref) {
    return 'Receipt #$ref';
  }

  @override
  String get totalPaid => 'Total paid';

  @override
  String get warrantyTitle => '7-day workmanship cover';

  @override
  String get warrantyBody =>
      'If the same fault returns, we send someone back at no labour cost.';

  @override
  String youRated(String name, String rating) {
    return 'You rated $name $rating★ · Done';
  }

  @override
  String rateName(String name) {
    return 'Rate $name';
  }

  @override
  String get rateExperience => 'Rate your experience';

  @override
  String get tagOnTime => 'On time';

  @override
  String get tagProfessional => 'Professional';

  @override
  String get tagCleanWork => 'Clean work';

  @override
  String get tagFairPrice => 'Fair price';

  @override
  String get tagExplainedClearly => 'Explained clearly';

  @override
  String get ratePoor => 'Poor';

  @override
  String get rateCouldBeBetter => 'Could be better';

  @override
  String get rateGood => 'Good';

  @override
  String get rateGreat => 'Great';

  @override
  String get rateExcellent => 'Excellent';

  @override
  String howWasName(String name) {
    return 'How was $name?';
  }

  @override
  String get whatWentWell => 'What went well?';

  @override
  String get addCommentOptional => 'Add a comment (optional)';

  @override
  String get commentHint => 'Tell others about the job';

  @override
  String get submitRating => 'Submit rating';

  @override
  String get thankYouRating => 'Thank you for your rating!';

  @override
  String get enterMobileToContinue => 'Enter your mobile number to continue';

  @override
  String get legalPrefix => 'By continuing, you agree to RepairMe\'s ';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get legalMiddle => ' and acknowledge the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyLink => 'Privacy Policy';

  @override
  String get legalSuffix => '.';

  @override
  String get verifyYourNumber => 'Verify Your Number';

  @override
  String get sentCodeTo => 'We\'ve sent a verification code to';

  @override
  String get changeNumber => 'Change Number';

  @override
  String get didntReceive => 'Didn\'t receive the code?';

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get completeProfileSub =>
      'Tell us a little about yourself to finish creating your account.';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get emailOptional => 'Email Address (optional)';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get verifiedBadge => 'Verified';

  @override
  String get createAccount => 'Create Account';

  @override
  String get firstNameRequired => 'Enter your first name';

  @override
  String get lastNameRequired => 'Enter your last name';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get phoneInvalid => 'Enter a valid Sri Lankan mobile number';

  @override
  String get createAccountError =>
      'We couldn\'t create your account. Please try again.';

  @override
  String get profileUpdateError =>
      'We couldn\'t update your profile. Please try again.';

  @override
  String get offlineTitle => 'Can\'t reach RepairMe';

  @override
  String get offlineBody => 'Check your internet connection and try again.';

  @override
  String get networkError =>
      'Cannot reach RepairMe. Check your connection and try again.';

  @override
  String get signInAgain => 'Please sign in again.';

  @override
  String get authPhoneInUse =>
      'This mobile number is already associated with another account.';

  @override
  String get viewEditProfile => 'View / Edit Profile';

  @override
  String get sectionAccount => 'ACCOUNT';

  @override
  String get sectionSupport => 'SUPPORT';

  @override
  String get sectionAbout => 'ABOUT';

  @override
  String get membership => 'Membership';

  @override
  String get aboutRepairMe => 'About RepairMe';

  @override
  String get legalAndPrivacy => 'Legal & Privacy';

  @override
  String get followUs => 'Follow Us';

  @override
  String get madeInSriLanka => 'Made in Sri Lanka';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get linkNotAvailable => 'This link isn\'t available yet';

  @override
  String get logOutQ => 'Log out?';

  @override
  String get logOutConfirm => 'Are you sure you want to log out of RepairMe?';

  @override
  String get logOutAction => 'Log Out';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get birthday => 'Birthday';

  @override
  String get birthdayHint => 'DD / MM / YYYY';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderPrefer => 'Prefer not to say';

  @override
  String get selectGender => 'Select gender';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get emergencyContactHint =>
      'Someone we can reach in an emergency. Used only for that purpose.';

  @override
  String get contactName => 'Contact Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get relationshipFamily => 'Family';

  @override
  String get relationshipFriend => 'Friend';

  @override
  String get relationshipNeighbour => 'Neighbour';

  @override
  String get addEmergencyContact => 'Add Emergency Contact';

  @override
  String get remove => 'Remove';

  @override
  String get removeContactQ => 'Remove emergency contact?';

  @override
  String get removeContactBody =>
      'This contact will be deleted from your account.';

  @override
  String get contactSaved => 'Emergency contact saved';

  @override
  String get additionalSettings => 'Additional Settings';

  @override
  String get changeMobileNumber => 'Change Mobile Number';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get enterNewNumber => 'Enter your new mobile number';

  @override
  String get changeNumberNote =>
      'We\'ll send a code to the new number to verify it. Your account and bookings stay the same.';

  @override
  String get sameNumber => 'That is already your number';

  @override
  String get numberChanged => 'Mobile number updated';

  @override
  String get verifyNewNumber => 'Verify New Number';

  @override
  String get notifBooking => 'Booking Updates';

  @override
  String get notifBookingSub =>
      'Technician acceptance, arrival and booking-status updates.';

  @override
  String get notifReminders => 'Service Reminders';

  @override
  String get notifRemindersSub => 'Upcoming scheduled services.';

  @override
  String get notifPayments => 'Payment Updates';

  @override
  String get notifPaymentsSub => 'Receipts, payment status and refunds.';

  @override
  String get notifOffers => 'Offers & Promotions';

  @override
  String get notifOffersSub => 'Marketing messages and promotions.';

  @override
  String get notifUpdates => 'RepairMe Updates';

  @override
  String get notifUpdatesSub => 'Important product and service updates.';

  @override
  String get notifEssentialNote =>
      'Essential account, security and booking-safety messages are always sent.';

  @override
  String get deleteTitle => 'Delete Your RepairMe Account?';

  @override
  String get deleteIntro =>
      'We\'re sorry to see you go. Deleting your account may permanently remove your RepairMe profile and associated personal information, subject to information we are required or permitted to retain.';

  @override
  String get whyLeaving => 'Why are you leaving?';

  @override
  String get delReasonNoNeed => 'I no longer need RepairMe';

  @override
  String get delReasonPrivacy => 'I have privacy concerns';

  @override
  String get delReasonBadExperience => 'I had a bad experience';

  @override
  String get delReasonAnotherAccount => 'I created another account';

  @override
  String get delReasonNotifications => 'I receive too many notifications';

  @override
  String get delReasonServices => 'I couldn\'t find the services I needed';

  @override
  String get tellUsMoreLabel => 'Tell us more';

  @override
  String get continueToDelete => 'Continue to Delete';

  @override
  String get permanentWarningTitle => 'This action may be permanent';

  @override
  String get deleteWillRemove => 'These may be removed or anonymised:';

  @override
  String get delRemoveProfile => 'Your profile and contact details';

  @override
  String get delRemoveAddresses => 'Saved addresses and emergency contact';

  @override
  String get delRemovePrefs => 'Preferences and notifications';

  @override
  String get delKeepNote =>
      'Some records, such as payments and support history, may be kept where required for accounting, security or legal reasons.';

  @override
  String get delConfirmCheck => 'I understand and want to delete my account';

  @override
  String get verifyAndDelete => 'Verify & Delete Account';

  @override
  String get deleteOtpTitle => 'Confirm with a code';

  @override
  String deleteOtpBody(String phone) {
    return 'For your security, enter the code we sent to $phone.';
  }

  @override
  String get deleteAccountAction => 'Delete my account';

  @override
  String get deleteError =>
      'We couldn\'t delete your account. Please try again.';

  @override
  String get accountDeleted => 'Your account has been deleted';

  @override
  String get membershipTitle => 'RepairMe Membership';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get standardMember => 'Standard Member';

  @override
  String get memberSince => 'Member Since';

  @override
  String get yourBenefits => 'Your benefits';

  @override
  String get benefit1 => 'Access to verified technicians';

  @override
  String get benefit2 => 'Emergency service requests';

  @override
  String get benefit3 => 'Scheduled bookings';

  @override
  String get benefit4 => 'Measurement requests';

  @override
  String get benefit5 => 'Booking history';

  @override
  String get benefit6 => 'Saved addresses';

  @override
  String get membershipSoon => 'More membership benefits are coming soon.';

  @override
  String get addNewAddress => '+ Add New Address';

  @override
  String get addAddress => 'Add Address';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get defaultBadge => 'DEFAULT';

  @override
  String get deleteAddressQ => 'Delete this address?';

  @override
  String get deleteAddressBody => 'Your past bookings are not affected.';

  @override
  String get delete => 'Delete';

  @override
  String get noSavedAddressesYet => 'No saved addresses yet';

  @override
  String get saveAddressHint =>
      'Save your home or work address to make future bookings faster.';

  @override
  String get addressLabelField => 'Label';

  @override
  String get recipientName => 'Contact name (optional)';

  @override
  String get contactPhoneField => 'Contact mobile number (optional)';

  @override
  String get districtField => 'District';

  @override
  String get instructionsField => 'Additional instructions (optional)';

  @override
  String get addressSaveError =>
      'We couldn\'t save this address. Please try again.';

  @override
  String get addressSaved => 'Address saved';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get cashDesc => 'Pay your technician directly after the job.';

  @override
  String get cardOnline => 'Card / Online Payment';

  @override
  String get cardOnlineDesc =>
      'Coming soon. Payments will be handled securely by a payment provider.';

  @override
  String get addPaymentMethod => '+ Add Payment Method';

  @override
  String get paymentSoonTitle => 'Online payments are coming soon';

  @override
  String get paymentSoonBody =>
      'For now you can pay with cash after the job. We will let you know when cards and other online payments are available.';

  @override
  String get okLabel => 'OK';

  @override
  String get helpCenterFaqs => 'Help Center / FAQs';

  @override
  String get mySupportRequests => 'My Support Requests';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get reportProblem => 'Report a Problem';

  @override
  String get paymentIssue => 'Payment Issue';

  @override
  String get bookingIssue => 'Booking Issue';

  @override
  String get emergencyHelp => 'Emergency Help';

  @override
  String get emergencyHelpBody =>
      'In an emergency, request a technician right away.';

  @override
  String get requestEmergencyTechnician => 'Request emergency technician';

  @override
  String get issueHint =>
      'Tell us what happened and, if it is about a booking or payment, the booking number.';

  @override
  String get noSupportRequests => 'No support requests yet';

  @override
  String get noSupportHint =>
      'When you contact support, your requests will appear here.';

  @override
  String get callUs => 'Call Us';

  @override
  String get emailUs => 'Email Us';

  @override
  String get chatWithUs => 'Chat With Us';

  @override
  String get supportNotConfigured =>
      'Support contact details will be available soon. You can still write to us from My Support Requests.';

  @override
  String get couldNotOpen => 'We couldn\'t open that';

  @override
  String get faqSearchHint => 'Search help';

  @override
  String get faqNoResults => 'No answers found';

  @override
  String get faqCatAccount => 'Account';

  @override
  String get faqCatBooking => 'Booking';

  @override
  String get faqCatPayments => 'Payments';

  @override
  String get faqCatTechnicians => 'Technicians';

  @override
  String get faqPhoneQ => 'How do I change my mobile number?';

  @override
  String get faqPhoneA =>
      'Go to Profile → Personal Information → Change Mobile Number. We send a code to the new number to verify it.';

  @override
  String get faqProfileQ => 'How do I update my profile?';

  @override
  String get faqProfileA =>
      'Open Profile and tap your name at the top, then change your details and tap Save Changes.';

  @override
  String get faqDeleteQ => 'How do I delete my account?';

  @override
  String get faqDeleteA =>
      'Go to Profile → Personal Information → Delete Account and follow the steps. You will confirm with a code sent to your mobile number.';

  @override
  String get faqBookQ => 'How do I book a technician?';

  @override
  String get faqBookA =>
      'Choose a service on the Home screen, describe the problem, pick a location and confirm. We match you with a verified technician.';

  @override
  String get faqEmergencyQ => 'How do emergency bookings work?';

  @override
  String get faqEmergencyA =>
      'Emergency requests go to the nearest available technician right away. Pick Emergency when you book.';

  @override
  String get faqScheduledQ => 'How do scheduled bookings work?';

  @override
  String get faqScheduledA =>
      'Choose a day and an arrival window. The technician confirms the visit the day before, and you can reschedule free until 2 hours before.';

  @override
  String get faqMeasureQ => 'What is a measurement request?';

  @override
  String get faqMeasureA =>
      'A visit where the technician inspects, measures and gives you a quote before any work starts.';

  @override
  String get faqMethodsQ => 'What payment methods are supported?';

  @override
  String get faqMethodsA =>
      'You can pay with cash after the job. Card and online payments are coming soon.';

  @override
  String get faqRefundQ => 'How do refunds work?';

  @override
  String get faqRefundA =>
      'If you were charged by mistake, open Help & Support → Payment Issue and tell us the booking. We review every request.';

  @override
  String get faqReceiptQ => 'Where can I find my receipt?';

  @override
  String get faqReceiptA =>
      'Open Bookings → Completed, choose the job and tap View receipt.';

  @override
  String get faqRateQ => 'How can I rate a technician?';

  @override
  String get faqRateA =>
      'After a job is paid, open the receipt and tap Rate. Your feedback helps other customers.';

  @override
  String get aboutTagline => 'Help When You Need It.';

  @override
  String get aboutDescription =>
      'RepairMe is an on-demand repair service platform designed to connect customers with trusted and verified technicians for convenient repair and maintenance services.';

  @override
  String get aboutSvc1 => 'Electrical';

  @override
  String get aboutSvc2 => 'Plumbing';

  @override
  String get aboutSvc3 => 'AC & Refrigeration';

  @override
  String get aboutSvc4 => 'Appliance Repair';

  @override
  String get aboutSvc5 => 'Mechanical Services';

  @override
  String get aboutSvc6 => 'Motorcycle / Roadside Repair';

  @override
  String get aboutSvc7 => 'Home Maintenance';

  @override
  String get aboutSvc8 => 'Other supported repair services';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get officialEmail => 'Official Email';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get websiteLabel => 'Website';

  @override
  String get officeAddress => 'Office Address';

  @override
  String get contactSoon => 'Contact details will be added soon.';

  @override
  String get cancellationPolicy => 'Cancellation Policy';

  @override
  String get refundPolicy => 'Refund Policy';

  @override
  String get paymentPolicy => 'Payment Policy';

  @override
  String get dataDeletionPolicy => 'Account & Data Deletion';

  @override
  String lastUpdatedOn(String date) {
    return 'Last Updated: $date';
  }

  @override
  String get legalDraftNote =>
      'Sample text for the prototype. Final policies must be reviewed before launch.';

  @override
  String get legalEnglishNote =>
      'Legal documents are currently available in English only.';

  @override
  String get deleteActiveBookings =>
      'Finish or cancel your active bookings before deleting your account.';

  @override
  String get acceptTermsTitle => 'Before you continue';

  @override
  String get acceptTermsBody =>
      'To use RepairMe, please read and accept our Terms & Conditions and Privacy Policy.';

  @override
  String get acceptPrefix => 'I have read and accept the ';

  @override
  String get acceptMiddle => ' and ';

  @override
  String get acceptSuffix => '.';

  @override
  String get acceptContinue => 'Accept & Continue';

  @override
  String get acceptError =>
      'We couldn\'t save your acceptance. Please try again.';
}
