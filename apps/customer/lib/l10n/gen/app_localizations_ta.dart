// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்துவிட்டது.';

  @override
  String get tryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String stepOf(String step, String label) {
    return 'படி $step / 4 · $label';
  }

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get save => 'சேமி';

  @override
  String get send => 'அனுப்பு';

  @override
  String get edit => 'திருத்து';

  @override
  String get currencyPrefix => 'ரூ.';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String get tomorrow => 'நாளை';

  @override
  String get visitFee => 'வருகைக் கட்டணம்';

  @override
  String get labour => 'உழைப்புக் கட்டணம்';

  @override
  String get parts => 'உதிரிபாகங்கள்';

  @override
  String get total => 'மொத்தம்';

  @override
  String get statusFinding => 'தேடுகிறது';

  @override
  String get statusAssigning => 'ஒதுக்குகிறது';

  @override
  String get statusAssigned => 'ஒதுக்கப்பட்டது';

  @override
  String get statusScheduled => 'திட்டமிடப்பட்டது';

  @override
  String get statusOnTheWay => 'வந்துகொண்டிருக்கிறார்';

  @override
  String get statusWorking => 'பணி நடக்கிறது';

  @override
  String get statusPaymentDue => 'பணம் செலுத்த வேண்டும்';

  @override
  String get statusCompleted => 'முடிந்தது';

  @override
  String get statusCancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navBookings => 'முன்பதிவுகள்';

  @override
  String get navMessages => 'செய்திகள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get chooseService => 'சேவையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get searchService => 'சேவையைத் தேடுங்கள்...';

  @override
  String get noMatchingService => 'பொருந்தும் சேவை இல்லை';

  @override
  String get tabActive => 'செயலில்';

  @override
  String get tabCompleted => 'முடிந்தவை';

  @override
  String get tabCancelled => 'ரத்தானவை';

  @override
  String get noActiveBookings => 'செயலில் உள்ள முன்பதிவுகள் இல்லை';

  @override
  String get noCompletedJobs => 'முடிந்த பணிகள் இன்னும் இல்லை';

  @override
  String get noCancelledBookings => 'ரத்து செய்த முன்பதிவுகள் இல்லை';

  @override
  String get needAnotherRepair => 'இன்னொரு பழுதுபார்ப்பு தேவையா?';

  @override
  String get bookTechnicianHint =>
      'சுமார் 2 நிமிடங்களில் சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளரை முன்பதிவு செய்யுங்கள்.';

  @override
  String get cancelledByYou => 'நீங்கள் ரத்து செய்தீர்கள்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get readAll => 'அனைத்தையும் படி';

  @override
  String get nothingHereYet => 'இங்கே இன்னும் எதுவும் இல்லை';

  @override
  String get groupToday => 'இன்று';

  @override
  String get groupEarlier => 'முன்னர்';

  @override
  String get support => 'உதவி';

  @override
  String get callRepairMe => 'RepairMe-ஐ அழைக்கவும்';

  @override
  String get open24Hours => '24 மணி நேரமும் திறந்திருக்கும்';

  @override
  String callNumber(String phone) {
    return '$phone ஐ அழைக்கவும்';
  }

  @override
  String get writeToUs => 'எங்களுக்கு எழுதுங்கள்';

  @override
  String get repliesInMinutes => 'நிமிடங்களில் பதில்';

  @override
  String get yourTickets => 'உங்கள் டிக்கெட்டுகள்';

  @override
  String get ticketResolved => 'தீர்க்கப்பட்டது';

  @override
  String get ticketOpen => 'திறந்தது';

  @override
  String get commonQuestions => 'பொதுவான கேள்விகள்';

  @override
  String get faqReportQ => 'முன்பதிவில் உள்ள சிக்கலைப் புகாரளிக்கவும்';

  @override
  String get faqReportA =>
      'முன்பதிவைத் திறந்து “சிக்கலைப் புகாரளி” என்பதைப் பயன்படுத்தவும், அல்லது கீழே ஒரு டிக்கெட்டை உருவாக்கவும். பகல் நேரத்தில் எங்கள் குழு சில நிமிடங்களில் பதிலளிக்கும்.';

  @override
  String get faqPriceQ => 'விலை எப்படி கணக்கிடப்படுகிறது?';

  @override
  String get faqPriceA =>
      'ஒவ்வொரு வருகைக்கும் ரூ. 500 வருகைக் கட்டணம் உண்டு. உழைப்பு மற்றும் உதிரிபாகங்களின் விலையை தொழில்நுட்பவியலாளர் இடத்திலேயே மதிப்பிடுவார்; செயலியில் நீங்கள் செலவை ஏற்கும் வரை எதுவும் வசூலிக்கப்படாது.';

  @override
  String get faqVerifiedQ =>
      'தொழில்நுட்பவியலாளர்கள் எவ்வாறு சரிபார்க்கப்படுகிறார்கள்?';

  @override
  String get faqVerifiedA =>
      'ஒவ்வொரு RepairMe தொழில்நுட்பவியலாளரின் அடையாள அட்டையும் சரிபார்க்கப்பட்டு, அவர்கள் பணிகளை ஏற்கும் முன் அவர்களின் தொழில் ஆவணங்களை எங்கள் குழு மதிப்பாய்வு செய்கிறது.';

  @override
  String get faqRefundsQ => 'பணத்தைத் திரும்பப் பெறுதல் மற்றும் ரத்து செய்தல்';

  @override
  String get faqRefundsA =>
      'தொழில்நுட்பவியலாளர் வருவதற்கு முன் ரத்து செய்வது இலவசம். முடிக்கப்பட்ட ஒவ்வொரு பணிக்கும் 7 நாள் வேலைத்திறன் உத்தரவாதம் உண்டு: அதே பழுது மீண்டும் வந்தால், உழைப்புக் கட்டணம் இல்லாமல் ஒருவரை அனுப்புவோம்.';

  @override
  String get writeToRepairMe => 'RepairMe-க்கு எழுதுங்கள்';

  @override
  String get subject => 'பொருள்';

  @override
  String get ticketMessageHint =>
      'என்ன நடந்தது என்று சொல்லுங்கள் (குறைந்தது 10 எழுத்துகள்)';

  @override
  String get ticketThanks =>
      'நன்றி — எங்கள் குழு விரைவில் உங்களைத் தொடர்புகொள்ளும்';

  @override
  String get addYourName => 'உங்கள் பெயரைச் சேர்க்கவும்';

  @override
  String get phoneVerified => 'தொலைபேசி சரிபார்க்கப்பட்டது';

  @override
  String get addresses => 'முகவரிகள்';

  @override
  String get savedAddresses => 'சேமித்த முகவரிகள்';

  @override
  String get paymentMethods => 'கட்டண முறைகள்';

  @override
  String get cash => 'பணம்';

  @override
  String get helpAndSupport => 'உதவி & ஆதரவு';

  @override
  String get language => 'மொழி';

  @override
  String get termsAndPrivacy => 'விதிமுறைகள் & தனியுரிமை';

  @override
  String get logOut => 'வெளியேறு';

  @override
  String get yourName => 'உங்கள் பெயர்';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get noSavedAddresses => 'சேமித்த முகவரிகள் இல்லை';

  @override
  String get noSavedAddressesHint =>
      'முன்பதிவுகளுக்கு நீங்கள் பயன்படுத்தும் முகவரிகள் இங்கே சேமிக்கப்படும்.';

  @override
  String addressDefault(String label) {
    return '$label · இயல்புநிலை';
  }

  @override
  String get appearance => 'தோற்றம்';

  @override
  String get appearanceLight => 'ஒளி';

  @override
  String get appearanceDark => 'இருள்';

  @override
  String get appearanceSystem => 'சாதனம்';

  @override
  String get greetMorning => 'காலை வணக்கம்';

  @override
  String get greetAfternoon => 'மதிய வணக்கம்';

  @override
  String get greetEvening => 'மாலை வணக்கம்';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get addYourAddress => 'உங்கள் முகவரியைச் சேர்க்கவும்';

  @override
  String get services => 'சேவைகள்';

  @override
  String get seeAll => 'அனைத்தையும் பார்';

  @override
  String get viewAll => 'அனைத்தையும் பார்';

  @override
  String get topRatedTechnicians =>
      'அதிக மதிப்பீடு பெற்ற தொழில்நுட்பவியலாளர்கள்';

  @override
  String notificationsUnread(String n) {
    return 'அறிவிப்புகள், படிக்காதவை $n';
  }

  @override
  String technicianRated(String name, String trade, String rating) {
    return '$name, $trade, மதிப்பீடு $rating';
  }

  @override
  String get bookNow => 'இப்போது முன்பதிவு செய்';

  @override
  String get getHelpNow => 'இப்போதே உதவி பெறுங்கள்';

  @override
  String useCode(String code) {
    return '$code குறியீட்டைப் பயன்படுத்தவும்';
  }

  @override
  String get offerNewTag => 'புதிய வாடிக்கையாளர் சலுகை';

  @override
  String get offerNewTitle => '20% தள்ளுபடி';

  @override
  String get offerNewSub => 'உங்கள் முதல் முன்பதிவு';

  @override
  String get offerHomeTag => 'வீட்டு பழுதுபார்ப்பு';

  @override
  String get offerHomeTitle => 'இலவச ஆய்வு';

  @override
  String get offerHomeSub => 'இந்த மாதம் எந்த வீட்டு பழுதுபார்ப்புக்கும்';

  @override
  String get bookTechnician => 'தொழில்நுட்பவியலாளரை முன்பதிவு செய்';

  @override
  String get offerRoadTag => 'சாலையோர உதவி';

  @override
  String get offerRoadTitle => 'ரூ. 500 தள்ளுபடி';

  @override
  String get offerRoadSub => 'பழுது & இழுவை, 24/7';

  @override
  String get teamLine1 => 'இலங்கையில் உருவாக்கப்பட்டது,';

  @override
  String get teamLine2 => 'ஒவ்வொரு இலங்கையருக்காகவும்';

  @override
  String get meetTheTeam => 'குழுவைச் சந்தியுங்கள்';

  @override
  String get emergencyTag => 'அவசரம்';

  @override
  String get needHelpNow => 'இப்போதே உதவி தேவையா?';

  @override
  String techniciansOnline(int n) {
    return '$n தொழில்நுட்பவியலாளர்கள் ஆன்லைனில் · சராசரி 18 நிமிடம்';
  }

  @override
  String get verifiedTechniciansAllDay =>
      'சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளர்கள், 24 மணி நேரமும்';

  @override
  String get brandTagline => 'சரிபார்க்கப்பட்ட நிபுணத்துவம். நம்பகமான நேர்மை.';

  @override
  String get chipVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get chipFast => 'விரைவு';

  @override
  String get chipTrusted => 'நம்பகமான';

  @override
  String get topTechInfo =>
      'நீங்கள் முன்பதிவு செய்யும்போது, அருகிலுள்ள கிடைக்கக்கூடிய சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளருடன் இணைப்போம்.';

  @override
  String get noRatingsYet => 'மதிப்பீடுகள் இன்னும் இல்லை';

  @override
  String tradeAndJobs(String trade, int n) {
    return '$trade · $n பணிகள்';
  }

  @override
  String get tradeElectrician => 'மின் பணியாளர்';

  @override
  String get tradePlumber => 'குழாய் பணியாளர்';

  @override
  String get tradeAc => 'ஏசி தொழில்நுட்பவியலாளர்';

  @override
  String get tradeAppliance => 'உபகரண பழுதுபார்ப்பு';

  @override
  String get tradeMechanic => 'மெக்கானிக்';

  @override
  String get tradeLocksmith => 'பூட்டு தொழிலாளர்';

  @override
  String get tradeCarpenter => 'தச்சர்';

  @override
  String get tradeHandyman => 'பொது பணியாளர்';

  @override
  String get tradeTechnician => 'தொழில்நுட்பவியலாளர்';

  @override
  String get categoryElectricalName => 'மின்சாரம்';

  @override
  String get categoryElectricalDescription =>
      'வயரிங், சாக்கெட்டுகள், பிரேக்கர்கள்';

  @override
  String get categoryPlumbingName => 'குழாய் வேலை';

  @override
  String get categoryPlumbingDescription => 'குழாய்கள், பைப்புகள், கசிவுகள்';

  @override
  String get categoryAcName => 'ஏசி';

  @override
  String get categoryAcDescription => 'சர்வீஸ், கேஸ், பழுதுபார்ப்பு';

  @override
  String get categoryRefrigeratorsName => 'குளிர்சாதனப் பெட்டிகள்';

  @override
  String get categoryRefrigeratorsDescription => 'குளிர்விக்கவில்லை, கசிவுகள்';

  @override
  String get categoryWashingMachinesName => 'துணி துவைக்கும் இயந்திரங்கள்';

  @override
  String get categoryWashingMachinesDescription =>
      'நீர் வெளியேறவில்லை, சத்தம், மின்சாரம் இல்லை';

  @override
  String get categoryMechanicName => 'மெக்கானிக்';

  @override
  String get categoryMechanicDescription => 'பைக்குகள் மற்றும் வாகனங்கள்';

  @override
  String get categoryFansLightsName => 'மின்விசிறிகள் மற்றும் விளக்குகள்';

  @override
  String get categoryFansLightsDescription =>
      'பொருத்துதல் மற்றும் பழுதுபார்ப்பு';

  @override
  String get categoryDoorsLocksName => 'கதவுகள் மற்றும் பூட்டுகள்';

  @override
  String get categoryDoorsLocksDescription => 'பூட்டுகள், கைப்பிடிகள், கீல்கள்';

  @override
  String get categoryGeneralName => 'பொது';

  @override
  String get categoryGeneralDescription => 'வீட்டைச் சுற்றிய சிறு வேலைகள்';

  @override
  String get problemBreakerKeepsTripping => 'பிரேக்கர் அடிக்கடி துண்டிக்கிறது';

  @override
  String get problemSocketNotWorking => 'சாக்கெட் வேலை செய்யவில்லை';

  @override
  String get problemLightOrFanFault => 'விளக்கு அல்லது மின்விசிறி பழுது';

  @override
  String get problemPowerOutage => 'மின்தடை';

  @override
  String get problemNewWiringOrPoints => 'புதிய வயரிங் அல்லது புள்ளிகள்';

  @override
  String get problemLeakingTap => 'கசியும் குழாய்';

  @override
  String get problemBurstOrLeakingPipe => 'வெடித்த அல்லது கசியும் குழாய்';

  @override
  String get problemBlockedDrain => 'அடைபட்ட வடிகால்';

  @override
  String get problemToiletOrCisternFault => 'கழிப்பறை அல்லது தொட்டி பழுது';

  @override
  String get problemWaterPumpProblem => 'தண்ணீர் பம்ப் பிரச்சினை';

  @override
  String get problemNotCooling => 'குளிர்விக்கவில்லை';

  @override
  String get problemWaterLeaking => 'தண்ணீர் கசிகிறது';

  @override
  String get problemStrangeNoise => 'விசித்திரமான சத்தம்';

  @override
  String get problemRegularService => 'வழக்கமான சர்வீஸ்';

  @override
  String get problemGasRefill => 'கேஸ் நிரப்புதல்';

  @override
  String get problemNotTurningOn => 'இயங்கவில்லை';

  @override
  String get problemNotDraining => 'நீர் வெளியேறவில்லை';

  @override
  String get problemNotSpinning => 'சுழலவில்லை';

  @override
  String get problemNoPower => 'மின்சாரம் இல்லை';

  @override
  String get problemWillNotStart => 'ஸ்டார்ட் ஆகவில்லை';

  @override
  String get problemBatteryProblem => 'பேட்டரி பிரச்சினை';

  @override
  String get problemFlatTyre => 'பஞ்சரான டயர்';

  @override
  String get problemBreakdownOnTheRoad => 'சாலையில் பழுது';

  @override
  String get problemInstallAFan => 'மின்விசிறி பொருத்துதல்';

  @override
  String get problemFanNotWorking => 'மின்விசிறி வேலை செய்யவில்லை';

  @override
  String get problemInstallLights => 'விளக்குகள் பொருத்துதல்';

  @override
  String get problemLightNotWorking => 'விளக்கு வேலை செய்யவில்லை';

  @override
  String get problemLockedOut => 'பூட்டிக்கொண்டு வெளியே நிற்கிறேன்';

  @override
  String get problemBrokenLock => 'உடைந்த பூட்டு';

  @override
  String get problemDoorNotClosing => 'கதவு மூடவில்லை';

  @override
  String get problemReplaceHandleOrHinge => 'கைப்பிடி அல்லது கீலை மாற்றுதல்';

  @override
  String get problemFurnitureAssembly => 'தளபாடங்கள் பொருத்துதல்';

  @override
  String get problemWallMounting => 'சுவரில் பொருத்துதல்';

  @override
  String get problemSmallRepairs => 'சிறு பழுதுபார்ப்புகள்';

  @override
  String get problemSomethingElse => 'வேறு ஏதாவது';

  @override
  String get symptomBurningSmell => 'எரிந்த வாசனை';

  @override
  String get symptomSparksSeen => 'தீப்பொறிகள் தெரிகின்றன';

  @override
  String get symptomOnlyOneRoom => 'ஒரு அறையில் மட்டும்';

  @override
  String get symptomHappenedBefore => 'முன்பே நடந்துள்ளது';

  @override
  String get symptomWaterLeakingNow => 'இப்போது தண்ணீர் கசிகிறது';

  @override
  String get symptomLowPressure => 'அழுத்தம் குறைவு';

  @override
  String get symptomBadSmell => 'துர்நாற்றம்';

  @override
  String get symptomWaterDripping => 'தண்ணீர் சொட்டுகிறது';

  @override
  String get symptomWaterOnFloor => 'தரையில் தண்ணீர்';

  @override
  String get symptomIceBuildUp => 'பனிக்கட்டி படிதல்';

  @override
  String get symptomNoisy => 'சத்தம் போடுகிறது';

  @override
  String get symptomErrorCodeShown => 'பிழைக் குறியீடு காட்டுகிறது';

  @override
  String get symptomVehicleAtHome => 'வாகனம் வீட்டில் உள்ளது';

  @override
  String get symptomVehicleOnTheRoad => 'வாகனம் சாலையில் உள்ளது';

  @override
  String get symptomWarningLightOn => 'எச்சரிக்கை விளக்கு எரிகிறது';

  @override
  String get symptomUrgent => 'அவசரம்';

  @override
  String get symptomNeedParts => 'உதிரிபாகங்கள் தேவை';

  @override
  String get onboard1Title => 'நாட்கள் அல்ல, நிமிடங்களில் உதவி';

  @override
  String get onboard1Body =>
      'குழாய் வெடித்ததா? மின்சாரம் போய்விட்டதா? அவசரம் பொத்தானை அழுத்துங்கள், அருகிலுள்ள சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளர் வந்துகொண்டிருக்கிறார்.';

  @override
  String get onboard2Title => 'உங்களுக்கு ஏற்ற நேரத்தை முன்பதிவு செய்யுங்கள்';

  @override
  String get onboard2Body =>
      'பழுதுபார்ப்பு, சர்வீஸ் அல்லது முதலில் ஆய்வு மற்றும் மதிப்பீட்டிற்காக ஒரு நாளையும் வருகை நேர இடைவெளியையும் தேர்ந்தெடுங்கள்.';

  @override
  String get onboard3Title => 'சரிபார்க்கப்பட்டவர். கட்டுப்பாடு உங்களிடமே';

  @override
  String get onboard3Body =>
      'ஒவ்வொரு தொழில்நுட்பவியலாளரின் அடையாளமும் சரிபார்க்கப்படுகிறது. எந்த வேலைக்கும் கட்டணம் வசூலிக்கும் முன் நீங்கள் செலவை ஏற்கிறீர்கள்.';

  @override
  String get skip => 'தவிர்';

  @override
  String get getStarted => 'தொடங்குங்கள்';

  @override
  String get next => 'அடுத்து';

  @override
  String get back => 'பின்செல்';

  @override
  String get welcomeToRepairMe => 'RepairMe-க்கு வரவேற்கிறோம்';

  @override
  String get homeRepairsSimple => 'வீட்டுப் பழுதுபார்ப்பு, எளிமையாக';

  @override
  String get enterMobile => 'உங்கள் மொபைல் எண்ணை உள்ளிடுங்கள்';

  @override
  String get oneTimeCodeNote =>
      'உங்களுக்கு ஒருமுறை பயன்படுத்தும் குறியீட்டை அனுப்புவோம்';

  @override
  String get sendCode => 'குறியீட்டை அனுப்பு';

  @override
  String get agreePrefix => 'தொடர்வதன் மூலம், எங்கள் ';

  @override
  String get termsPrivacy => 'விதிமுறைகள் & தனியுரிமை';

  @override
  String get agreeSuffix => '-ஐ ஏற்கிறீர்கள்';

  @override
  String get enterVerificationCode => 'சரிபார்ப்புக் குறியீட்டை உள்ளிடுங்கள்';

  @override
  String sentTo(String phone) {
    return '$phone க்கு அனுப்பப்பட்டது';
  }

  @override
  String get verify => 'சரிபார்';

  @override
  String resendIn(String time) {
    return 'குறியீட்டை மீண்டும் அனுப்ப $time';
  }

  @override
  String get resendCode => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String get newCodeSent => 'புதிய குறியீடு அனுப்பப்பட்டுள்ளது';

  @override
  String authIncorrectCodeDev(String code) {
    return 'குறியீடு தவறு. மேம்பாட்டில் $code ஐப் பயன்படுத்தவும்.';
  }

  @override
  String get authRequestNewCode => 'புதிய குறியீட்டைக் கோரவும்.';

  @override
  String get authIncorrectCode =>
      'குறியீடு தவறு. SMS ஐச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authInvalidPhone => 'அந்த மொபைல் எண் செல்லுபடியாகாது.';

  @override
  String get authTooMany =>
      'அதிக முயற்சிகள். காத்திருந்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authExpired => 'குறியீடு காலாவதியானது. புதியதைக் கோரவும்.';

  @override
  String get authFailed => 'உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get noMessagesYet => 'செய்திகள் இன்னும் இல்லை';

  @override
  String get noMessagesHint =>
      'தொழில்நுட்பவியலாளர் உங்கள் முன்பதிவை ஏற்றதும், இங்கே அவருடன் அரட்டையடிக்கலாம்.';

  @override
  String sayHelloTo(String name) {
    return '$nameக்கு வணக்கம் சொல்லுங்கள்';
  }

  @override
  String youPrefix(String message) {
    return 'நீங்கள்: $message';
  }

  @override
  String get splashTagline => 'சரிசெய்தல். விரைவு. சரிபார்க்கப்பட்டது.';

  @override
  String get splashProud => 'பெருமைமிக்க இலங்கை';

  @override
  String get bookingTypeEmergency => 'அவசரம்';

  @override
  String get bookingTypeSchedule => 'திட்டமிடு';

  @override
  String get bookingTypeInspection => 'ஆய்வு';

  @override
  String get addressHome => 'வீடு';

  @override
  String get addressOffice => 'பணியிடம்';

  @override
  String get addressOther => 'மற்றவை';

  @override
  String get continueLabel => 'தொடரவும்';

  @override
  String get requestDetails => 'கோரிக்கை விவரங்கள்';

  @override
  String get howSoon => 'எவ்வளவு விரைவில் உதவி தேவை?';

  @override
  String get typeEmergencyBody =>
      'அருகிலுள்ள கிடைக்கக்கூடிய தொழில்நுட்பவியலாளர் விரைவில் வருவார்.';

  @override
  String get typeEmergencyHint => 'சராசரி வருகை 18 நிமிடம்';

  @override
  String get typeScheduledBody =>
      'உங்களுக்கு ஏற்ற தேதியையும் நேர இடைவெளியையும் தேர்ந்தெடுங்கள்.';

  @override
  String get typeScheduledHint => 'நேரத்தைத் தேர்ந்தெடுங்கள்';

  @override
  String get typeInspectionBody =>
      'ஆய்வு செய்து, அளந்து, முதலில் மதிப்பீடு வழங்க ஒரு வருகை.';

  @override
  String get typeInspectionHint => 'வேலைக்கு முன் மதிப்பீடு';

  @override
  String get howPricingWorks => 'விலை நிர்ணயம் எப்படி செயல்படுகிறது';

  @override
  String pricingBody(String fee) {
    return 'வருகைக் கட்டணம் $fee + உழைப்பு + உதிரிபாகங்கள். தொழில்நுட்பவியலாளர் இறுதிச் செலவை அனுப்புவார்; எந்த வேலைக்கும் கட்டணம் வசூலிக்கும் முன் நீங்கள் அதை ஏற்கிறீர்கள்.';
  }

  @override
  String continueWith(String type) {
    return '$type உடன் தொடரவும்';
  }

  @override
  String get stepProblem => 'பிரச்சினை';

  @override
  String get whatIsProblem => 'பிரச்சினை என்ன?';

  @override
  String get tellUsMore => 'மேலும் சொல்லுங்கள்';

  @override
  String get detailsHint =>
      'என்ன நடந்தது, எப்போது தொடங்கியது, தொழில்நுட்பவியலாளர் தெரிந்துகொள்ள வேண்டியவை (குறைந்தது 10 எழுத்துகள்)';

  @override
  String get stepPhotos => 'புகைப்படங்கள்';

  @override
  String get addPhotos => 'புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get photosSubtitle =>
      'விருப்பமானது, ஆனால் தொழில்நுட்பவியலாளர் சரியான கருவிகளையும் உதிரிபாகங்களையும் கொண்டுவர உதவும்.';

  @override
  String get add => 'சேர்';

  @override
  String get takePhoto => 'புகைப்படம் எடு';

  @override
  String get fromGallery => 'கேலரியிலிருந்து';

  @override
  String get photoTips => 'நல்ல புகைப்படங்களுக்கான குறிப்புகள்';

  @override
  String get photoTipsBody =>
      '· முழு பகுதியையும் காட்டி, பின்னர் நெருக்கமாகப் படம் எடுங்கள்\n· மாடல் அல்லது லேபிள் தகட்டைச் சேர்க்கவும்\n· வெளியே தெரியும் வயர்களைத் தொடாதீர்கள்';

  @override
  String get skipForNow => 'இப்போதைக்குத் தவிர்';

  @override
  String get photoOpenError =>
      'புகைப்படங்களைத் திறக்க முடியவில்லை. அனுமதிகளைச் சரிபார்க்கவும்.';

  @override
  String get stepLocation => 'இடம்';

  @override
  String get whereShouldComeTitle => 'தொழில்நுட்பவியலாளர் எங்கே வர வேண்டும்?';

  @override
  String get yourArea => 'உங்கள் பகுதி';

  @override
  String get addNew => 'புதியதைச் சேர்';

  @override
  String get streetAddress => 'தெரு முகவரி';

  @override
  String get areaLabel => 'பகுதி';

  @override
  String get cityLabel => 'நகரம்';

  @override
  String get houseNumber => 'வீடு / அடுக்குமாடி எண்';

  @override
  String get landmarkLabel => 'அடையாளம் அல்லது வழிகாட்டுதல்';

  @override
  String get saveThisAddress => 'இந்த முகவரியைச் சேமி';

  @override
  String get confirmLocation => 'இடத்தை உறுதிசெய்';

  @override
  String get inspectionVisit => 'ஆய்வு வருகை';

  @override
  String get scheduleVisit => 'வருகையைத் திட்டமிடுங்கள்';

  @override
  String get whenShouldWeCome => 'நாங்கள் எப்போது வர வேண்டும்?';

  @override
  String get arrivalWindow => 'வருகை நேர இடைவெளி';

  @override
  String get visitConfirmNote =>
      'தொழில்நுட்பவியலாளர் முந்தைய நாள் வருகையை உறுதிசெய்வார். 2 மணி நேரத்திற்கு முன் வரை இலவசமாக மாற்றியமைக்கலாம்.';

  @override
  String selectedSlot(String when) {
    return 'தேர்ந்தெடுத்தது: $when';
  }

  @override
  String get reviewRequest => 'கோரிக்கையை மதிப்பாய்வு செய்';

  @override
  String get stepReview => 'மதிப்பாய்வு';

  @override
  String get checkYourRequest => 'உங்கள் கோரிக்கையைச் சரிபாருங்கள்';

  @override
  String photosAttached(int n) {
    return '$n புகைப்படங்கள் இணைக்கப்பட்டுள்ளன';
  }

  @override
  String get estimatedCost => 'மதிப்பிடப்பட்ட செலவு';

  @override
  String get labourAndParts => 'உழைப்பும் உதிரிபாகங்களும்';

  @override
  String get quotedOnSite => 'இடத்திலேயே மதிப்பிடப்படும்';

  @override
  String get approveFinalCost =>
      'எந்த வேலைக்கும் கட்டணம் வசூலிக்கும் முன் செயலியில் இறுதிச் செலவை ஏற்பீர்கள்.';

  @override
  String get payWithCash => 'பணமாகச் செலுத்துங்கள்';

  @override
  String get afterTheJob => 'வேலை முடிந்த பின்';

  @override
  String get requestTechnician => 'தொழில்நுட்பவியலாளரைக் கோருங்கள்';

  @override
  String photosFailed(int n) {
    return '$n புகைப்படங்களைப் பதிவேற்ற முடியவில்லை';
  }

  @override
  String get theTechnician => 'தொழில்நுட்பவியலாளர்';

  @override
  String get yourTechnician => 'உங்கள் தொழில்நுட்பவியலாளர்';

  @override
  String get otherLabel => 'மற்றவை';

  @override
  String get bkFinding => 'தொழில்நுட்பவியலாளரைத் தேடுகிறது';

  @override
  String get bkTeamAssigning => 'குழு ஒதுக்குகிறது';

  @override
  String get bkAssigned => 'தொழில்நுட்பவியலாளர் ஒதுக்கப்பட்டார்';

  @override
  String get bkCancelledRequest => 'ரத்து செய்யப்பட்ட கோரிக்கை';

  @override
  String get bkJobStatus => 'பணி நிலை';

  @override
  String get stepRequestReceived => 'கோரிக்கை பெறப்பட்டது';

  @override
  String get stepNoTechAccepted => 'எந்த தொழில்நுட்பவியலாளரும் ஏற்கவில்லை';

  @override
  String get stepTeamAssigning => 'RepairMe குழு ஒதுக்குகிறது';

  @override
  String get stepTechConfirms => 'தொழில்நுட்பவியலாளர் உறுதிசெய்கிறார்';

  @override
  String get stepMatchingNearby =>
      'அருகிலுள்ள தொழில்நுட்பவியலாளர்களைப் பொருத்துகிறது';

  @override
  String requestRef(String ref) {
    return 'கோரிக்கை #$ref';
  }

  @override
  String get operatorFindingTitle =>
      'எங்கள் குழு உங்களுக்காக ஒருவரைத் தேடுகிறது';

  @override
  String findingVerifiedTitle(String category) {
    return 'சரிபார்க்கப்பட்ட $category தொழில்நுட்பவியலாளரைத் தேடுகிறது';
  }

  @override
  String get operatorFindingBody =>
      'இதுவரை எந்த தொழில்நுட்பவியலாளரும் ஏற்கவில்லை, எனவே RepairMe ஆபரேட்டர் உங்களுக்கு ஒருவரை ஒதுக்குகிறார். வழக்கமாக 2 நிமிடங்களுக்குள்.';

  @override
  String matchingNear(String area) {
    return '$area அருகிலுள்ள தொழில்நுட்பவியலாளர்களுடன் உங்களைப் பொருத்துகிறது.';
  }

  @override
  String confirmingFor(String when) {
    return '$when க்கு தொழில்நுட்பவியலாளரை உறுதிசெய்கிறோம்.';
  }

  @override
  String get ifNobodyAccepts =>
      'யாரும் ஏற்கவில்லை என்றால், RepairMe குழு உங்களுக்கு ஒரு தொழில்நுட்பவியலாளரை ஒதுக்கும்.';

  @override
  String get cancelRequest => 'கோரிக்கையை ரத்து செய்';

  @override
  String get cancelThisRequest => 'இந்த கோரிக்கையை ரத்து செய்யவா?';

  @override
  String get noChargeNoTech =>
      'இன்னும் தொழில்நுட்பவியலாளர் ஒதுக்கப்படாததால் கட்டணம் இல்லை.';

  @override
  String noChargeNotArrived(String name) {
    return '$name இன்னும் வராததால் கட்டணம் இல்லை.';
  }

  @override
  String get reasonFoundSomeone => 'வேறொருவரைக் கண்டுபிடித்தேன்';

  @override
  String get reasonProblemFixed => 'பிரச்சினை சரிசெய்யப்பட்டது';

  @override
  String get reasonWaitingTooLong => 'மிக நீண்ட நேரம் காத்திருக்கிறேன்';

  @override
  String get tellUsMoreOptional => 'மேலும் சொல்லுங்கள் (விருப்பம்)';

  @override
  String get keepWaiting => 'தொடர்ந்து காத்திரு';

  @override
  String etaMin(String n) {
    return 'வருகை $n நிமி';
  }

  @override
  String techOnTheWayTitle(String name) {
    return '$name வந்துகொண்டிருக்கிறார்';
  }

  @override
  String techWillVisit(String name, String when) {
    return '$name $when வருவார்';
  }

  @override
  String techAccepted(String name) {
    return '$name உங்கள் கோரிக்கையை ஏற்றார்';
  }

  @override
  String arrivesInAbout(String n) {
    return 'சுமார் $n நிமிடத்தில் வருவார்';
  }

  @override
  String get viewJobStatus => 'பணி நிலையைப் பார்';

  @override
  String get cancelBooking => 'முன்பதிவை ரத்து செய்';

  @override
  String verifiedCategoryTech(String category) {
    return 'சரிபார்க்கப்பட்ட $category தொழில்நுட்பவியலாளர்';
  }

  @override
  String get newTech => 'புதிய';

  @override
  String ratingAndJobs(String rating, int n) {
    return '$rating · $n பணிகள்';
  }

  @override
  String jobCodeShare(String name) {
    return 'பணிக் குறியீடு · $name வரும்போது மட்டும் பகிருங்கள்';
  }

  @override
  String messageTech(String name) {
    return '$name க்கு செய்தி';
  }

  @override
  String jobNumber(String ref) {
    return 'பணி #$ref';
  }

  @override
  String get costReadyTitle => 'உங்கள் ஒப்புதலுக்கு செலவு தயார்';

  @override
  String costReadyBody(String name, String amount) {
    return '$name $amount அனுப்பியுள்ளார் · மதிப்பாய்வு செய்ய தட்டவும்';
  }

  @override
  String get repairCompleted => 'பழுதுபார்ப்பு முடிந்தது';

  @override
  String payTo(String amount, String name) {
    return '$name க்கு $amount செலுத்துங்கள்';
  }

  @override
  String get paymentReceived => 'பணம் பெறப்பட்டது';

  @override
  String viewReceiptRate(String name) {
    return 'ரசீதைப் பார்த்து $name ஐ மதிப்பிடுங்கள்';
  }

  @override
  String get viewReceipt => 'ரசீதைப் பார்';

  @override
  String get bookingWasCancelled => 'இந்த முன்பதிவு ரத்து செய்யப்பட்டது';

  @override
  String get cancelledByYouNoCharge =>
      'நீங்கள் ரத்து செய்தீர்கள் · கட்டணம் இல்லை';

  @override
  String get cancelledByRepairMe => 'RepairMe ரத்து செய்தது';

  @override
  String get tlRequestCreated => 'கோரிக்கை உருவாக்கப்பட்டது';

  @override
  String get tlAccepted => 'தொழில்நுட்பவியலாளர் ஏற்றார்';

  @override
  String get tlOnTheWay => 'வந்துகொண்டிருக்கிறார்';

  @override
  String get tlArrived => 'வந்துவிட்டார்';

  @override
  String tlJobCodeVerified(String time) {
    return 'பணிக் குறியீடு சரிபார்க்கப்பட்டது · $time';
  }

  @override
  String get tlWorking => 'பணி நடக்கிறது';

  @override
  String get tlCostApproved => 'செலவு ஏற்கப்பட்டது, பணி நடக்கிறது';

  @override
  String get tlInspectionDone => 'ஆய்வு முடிந்தது, செலவு அனுப்பப்பட்டது';

  @override
  String get tlCompleted => 'முடிந்தது';

  @override
  String get tlPayAndRate => 'செலுத்தி மதிப்பிடுங்கள்';

  @override
  String get yourPhotos => 'உங்கள் புகைப்படங்கள்';

  @override
  String beforePhotosBy(String name) {
    return '$name எடுத்த முந்தைய புகைப்படங்கள்';
  }

  @override
  String get afterPhotos => 'பிந்தைய புகைப்படங்கள்';

  @override
  String get requestHeading => 'கோரிக்கை';

  @override
  String get reportProblemWithJob => 'இந்த பணியில் உள்ள சிக்கலைப் புகாரளி';

  @override
  String problemWithRef(String ref) {
    return '$ref தொடர்பான சிக்கல்';
  }

  @override
  String get chat => 'அரட்டை';

  @override
  String onTheWayEta(String n) {
    return 'வந்துகொண்டிருக்கிறார் · $n நிமிடத்தில்';
  }

  @override
  String chatSafety(String name) {
    return 'உங்கள் பாதுகாப்பிற்காக செய்திகள் பதிவு செய்யப்படுகின்றன. $name வரும் வரை உங்கள் பணிக் குறியீட்டை ஒருபோதும் பகிராதீர்கள்.';
  }

  @override
  String timeSeen(String time) {
    return '$time · பார்க்கப்பட்டது';
  }

  @override
  String get quickAtHome => 'நான் வீட்டில் இருக்கிறேன்';

  @override
  String get quickCallMe => 'எனக்கு அழையுங்கள்';

  @override
  String get quickSideGate => 'பக்க வாயிலைப் பயன்படுத்துங்கள்';

  @override
  String get messageHint => 'செய்தி';

  @override
  String get chatClosed => 'இந்த முன்பதிவிற்கான அரட்டை மூடப்பட்டுள்ளது.';

  @override
  String get declineCostQ => 'இந்த செலவை நிராகரிக்கவா?';

  @override
  String get declineCostBody =>
      'தொழில்நுட்பவியலாளருக்குத் தெரிவிக்கப்படும். வேலை எதுவும் செய்யப்படாவிட்டால் வருகைக் கட்டணம் மட்டுமே பொருந்தும்.';

  @override
  String get decline => 'நிராகரி';

  @override
  String get costApprovedToast => 'செலவு ஏற்கப்பட்டது. பணி தொடர்கிறது.';

  @override
  String get costDeclinedToast => 'செலவு நிராகரிக்கப்பட்டது';

  @override
  String get approveCostTitle => 'செலவை ஏற்கவும்';

  @override
  String get nothingToApprove => 'இப்போது ஏற்க எதுவும் இல்லை';

  @override
  String get totalToApprove => 'ஏற்க வேண்டிய மொத்தம்';

  @override
  String noteFrom(String name) {
    return '$name இடமிருந்து குறிப்பு';
  }

  @override
  String get workStartsAfterApprove =>
      'நீங்கள் ஏற்ற பிறகே வேலை தொடங்கும். செலவு மாறினால், மீண்டும் கேட்கப்படும்.';

  @override
  String approveAmount(String amount) {
    return '$amount ஐ ஏற்கவும்';
  }

  @override
  String get askQuestion => 'கேள்வி கேள்';

  @override
  String get payment => 'கட்டணம்';

  @override
  String repairCompletedBy(String name) {
    return '$name பழுதுபார்ப்பை முடித்தார்';
  }

  @override
  String repairCompletedByAt(String name, String time) {
    return '$name பழுதுபார்ப்பை முடித்தார் · $time';
  }

  @override
  String get paymentMethodHeading => 'கட்டண முறை';

  @override
  String payTechDirectly(String name) {
    return '$name க்கு நேரடியாகச் செலுத்துங்கள்';
  }

  @override
  String get card => 'அட்டை';

  @override
  String get comingSoon => 'விரைவில்';

  @override
  String get mobileWallet => 'மொபைல் வாலட்';

  @override
  String handCashTo(String amount, String name) {
    return '$amount ஐ $name இடம் கொடுங்கள். அவர் உறுதிசெய்ததும் உங்கள் ரசீது தோன்றும்.';
  }

  @override
  String confirmPaymentAmount(String amount) {
    return 'கட்டணத்தை உறுதிசெய் · $amount';
  }

  @override
  String get receipt => 'ரசீது';

  @override
  String paidInCash(String amount) {
    return '$amount பணமாகச் செலுத்தப்பட்டது';
  }

  @override
  String paidIn(String amount, String method) {
    return '$amount $method ஆகச் செலுத்தப்பட்டது';
  }

  @override
  String receiptNumber(String ref) {
    return 'ரசீது #$ref';
  }

  @override
  String get totalPaid => 'செலுத்திய மொத்தம்';

  @override
  String get warrantyTitle => '7 நாள் வேலைத்திறன் உத்தரவாதம்';

  @override
  String get warrantyBody =>
      'அதே பழுது மீண்டும் வந்தால், உழைப்புக் கட்டணம் இல்லாமல் ஒருவரை அனுப்புவோம்.';

  @override
  String youRated(String name, String rating) {
    return 'நீங்கள் $name ஐ $rating★ என மதிப்பிட்டீர்கள் · முடிந்தது';
  }

  @override
  String rateName(String name) {
    return '$name ஐ மதிப்பிடுங்கள்';
  }

  @override
  String get rateExperience => 'உங்கள் அனுபவத்தை மதிப்பிடுங்கள்';

  @override
  String get tagOnTime => 'சரியான நேரத்தில்';

  @override
  String get tagProfessional => 'தொழில்முறை';

  @override
  String get tagCleanWork => 'சுத்தமான வேலை';

  @override
  String get tagFairPrice => 'நியாயமான விலை';

  @override
  String get tagExplainedClearly => 'தெளிவாக விளக்கினார்';

  @override
  String get ratePoor => 'மோசம்';

  @override
  String get rateCouldBeBetter => 'இன்னும் சிறப்பாக இருக்கலாம்';

  @override
  String get rateGood => 'நன்று';

  @override
  String get rateGreat => 'மிகவும் நன்று';

  @override
  String get rateExcellent => 'சிறப்பு';

  @override
  String howWasName(String name) {
    return '$name எப்படி?';
  }

  @override
  String get whatWentWell => 'எது நன்றாக இருந்தது?';

  @override
  String get addCommentOptional => 'கருத்தைச் சேர்க்கவும் (விருப்பம்)';

  @override
  String get commentHint => 'பணியைப் பற்றி மற்றவர்களுக்குச் சொல்லுங்கள்';

  @override
  String get submitRating => 'மதிப்பீட்டைச் சமர்ப்பி';

  @override
  String get thankYouRating => 'உங்கள் மதிப்பீட்டிற்கு நன்றி!';

  @override
  String get enterMobileToContinue => 'தொடர உங்கள் மொபைல் எண்ணை உள்ளிடுங்கள்';

  @override
  String get legalPrefix => 'தொடர்வதன் மூலம், RepairMe-ன் ';

  @override
  String get termsAndConditions => 'விதிமுறைகள் & நிபந்தனைகள்';

  @override
  String get legalMiddle => '-ஐ ஏற்று, ';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get privacyPolicyLink => 'தனியுரிமைக் கொள்கையை';

  @override
  String get legalSuffix => ' ஒப்புக்கொள்கிறீர்கள்.';

  @override
  String get verifyYourNumber => 'உங்கள் எண்ணைச் சரிபார்க்கவும்';

  @override
  String get sentCodeTo => 'நாங்கள் சரிபார்ப்புக் குறியீட்டை அனுப்பியுள்ளோம்:';

  @override
  String get changeNumber => 'எண்ணை மாற்று';

  @override
  String get didntReceive => 'குறியீடு கிடைக்கவில்லையா?';

  @override
  String get completeYourProfile => 'உங்கள் சுயவிவரத்தை நிறைவு செய்யுங்கள்';

  @override
  String get completeProfileSub =>
      'உங்கள் கணக்கை உருவாக்கி முடிக்க உங்களைப் பற்றி சிறிது சொல்லுங்கள்.';

  @override
  String get firstName => 'முதல் பெயர்';

  @override
  String get lastName => 'கடைசி பெயர்';

  @override
  String get emailOptional => 'மின்னஞ்சல் முகவரி (விருப்பம்)';

  @override
  String get emailLabel => 'மின்னஞ்சல் முகவரி';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get verifiedBadge => 'சரிபார்க்கப்பட்டது';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get firstNameRequired => 'உங்கள் முதல் பெயரை உள்ளிடுங்கள்';

  @override
  String get lastNameRequired => 'உங்கள் கடைசி பெயரை உள்ளிடுங்கள்';

  @override
  String get emailInvalid => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடுங்கள்';

  @override
  String get phoneInvalid => 'சரியான இலங்கை மொபைல் எண்ணை உள்ளிடுங்கள்';

  @override
  String get createAccountError =>
      'உங்கள் கணக்கை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get profileUpdateError =>
      'உங்கள் சுயவிவரத்தைப் புதுப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get offlineTitle => 'RepairMe-ஐ அடைய முடியவில்லை';

  @override
  String get offlineBody =>
      'உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get networkError =>
      'RepairMe-ஐ அடைய முடியவில்லை. உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get signInAgain => 'மீண்டும் உள்நுழையவும்.';

  @override
  String get authPhoneInUse =>
      'இந்த மொபைல் எண் ஏற்கனவே வேறொரு கணக்குடன் இணைக்கப்பட்டுள்ளது.';

  @override
  String get viewEditProfile => 'சுயவிவரத்தைக் காண் / திருத்து';

  @override
  String get sectionAccount => 'கணக்கு';

  @override
  String get sectionSupport => 'ஆதரவு';

  @override
  String get sectionAbout => 'பற்றி';

  @override
  String get membership => 'உறுப்பினர்';

  @override
  String get aboutRepairMe => 'RepairMe பற்றி';

  @override
  String get legalAndPrivacy => 'சட்டம் & தனியுரிமை';

  @override
  String get followUs => 'எங்களைப் பின்தொடருங்கள்';

  @override
  String get madeInSriLanka => 'இலங்கையில் உருவாக்கப்பட்டது';

  @override
  String appVersion(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get linkNotAvailable => 'இந்த இணைப்பு இன்னும் கிடைக்கவில்லை';

  @override
  String get logOutQ => 'வெளியேறவா?';

  @override
  String get logOutConfirm => 'RepairMe-இலிருந்து வெளியேற விரும்புகிறீர்களா?';

  @override
  String get logOutAction => 'வெளியேறு';

  @override
  String get personalInformation => 'தனிப்பட்ட தகவல்';

  @override
  String get changeProfilePhoto => 'சுயவிவரப் புகைப்படத்தை மாற்று';

  @override
  String get removePhoto => 'புகைப்படத்தை நீக்கு';

  @override
  String get personalDetails => 'தனிப்பட்ட விவரங்கள்';

  @override
  String get birthday => 'பிறந்தநாள்';

  @override
  String get birthdayHint => 'DD / MM / YYYY';

  @override
  String get gender => 'பாலினம்';

  @override
  String get genderMale => 'ஆண்';

  @override
  String get genderFemale => 'பெண்';

  @override
  String get genderPrefer => 'சொல்ல விரும்பவில்லை';

  @override
  String get selectGender => 'தேர்ந்தெடுக்கவும்';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get changesSaved => 'மாற்றங்கள் சேமிக்கப்பட்டன';

  @override
  String get chooseLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get emergencyContact => 'அவசரத் தொடர்பு';

  @override
  String get emergencyContactHint =>
      'அவசரத்தில் நாங்கள் தொடர்புகொள்ளக்கூடிய ஒருவர். அதற்காக மட்டுமே பயன்படுத்தப்படும்.';

  @override
  String get contactName => 'தொடர்பு பெயர்';

  @override
  String get relationship => 'உறவு';

  @override
  String get relationshipFamily => 'குடும்பம்';

  @override
  String get relationshipFriend => 'நண்பர்';

  @override
  String get relationshipNeighbour => 'அண்டை வீட்டார்';

  @override
  String get addEmergencyContact => 'அவசரத் தொடர்பைச் சேர்க்கவும்';

  @override
  String get remove => 'நீக்கு';

  @override
  String get removeContactQ => 'அவசரத் தொடர்பை நீக்கவா?';

  @override
  String get removeContactBody =>
      'இந்தத் தொடர்பு உங்கள் கணக்கிலிருந்து நீக்கப்படும்.';

  @override
  String get contactSaved => 'அவசரத் தொடர்பு சேமிக்கப்பட்டது';

  @override
  String get additionalSettings => 'கூடுதல் அமைப்புகள்';

  @override
  String get changeMobileNumber => 'மொபைல் எண்ணை மாற்று';

  @override
  String get notificationPreferences => 'அறிவிப்பு விருப்பங்கள்';

  @override
  String get dangerZone => 'ஆபத்து மண்டலம்';

  @override
  String get deleteAccount => 'கணக்கை நீக்கு';

  @override
  String get enterNewNumber => 'உங்கள் புதிய மொபைல் எண்ணை உள்ளிடுங்கள்';

  @override
  String get changeNumberNote =>
      'அதைச் சரிபார்க்க புதிய எண்ணுக்கு ஒரு குறியீட்டை அனுப்புவோம். உங்கள் கணக்கும் முன்பதிவுகளும் அப்படியே இருக்கும்.';

  @override
  String get sameNumber => 'அது ஏற்கனவே உங்கள் எண்தான்';

  @override
  String get numberChanged => 'மொபைல் எண் புதுப்பிக்கப்பட்டது';

  @override
  String get verifyNewNumber => 'புதிய எண்ணைச் சரிபார்க்கவும்';

  @override
  String get notifBooking => 'முன்பதிவு புதுப்பிப்புகள்';

  @override
  String get notifBookingSub =>
      'தொழில்நுட்பவியலாளர் ஏற்பு, வருகை மற்றும் முன்பதிவு நிலை புதுப்பிப்புகள்.';

  @override
  String get notifReminders => 'சேவை நினைவூட்டல்கள்';

  @override
  String get notifRemindersSub => 'வரவிருக்கும் திட்டமிட்ட சேவைகள்.';

  @override
  String get notifPayments => 'கட்டணப் புதுப்பிப்புகள்';

  @override
  String get notifPaymentsSub =>
      'ரசீதுகள், கட்டண நிலை மற்றும் பணத்தைத் திரும்பப் பெறுதல்.';

  @override
  String get notifOffers => 'சலுகைகள் & விளம்பரங்கள்';

  @override
  String get notifOffersSub =>
      'சந்தைப்படுத்தல் செய்திகள் மற்றும் விளம்பரங்கள்.';

  @override
  String get notifUpdates => 'RepairMe புதுப்பிப்புகள்';

  @override
  String get notifUpdatesSub =>
      'முக்கியமான தயாரிப்பு மற்றும் சேவை புதுப்பிப்புகள்.';

  @override
  String get notifEssentialNote =>
      'அத்தியாவசிய கணக்கு, பாதுகாப்பு மற்றும் முன்பதிவு பாதுகாப்புச் செய்திகள் எப்போதும் அனுப்பப்படும்.';

  @override
  String get deleteTitle => 'உங்கள் RepairMe கணக்கை நீக்கவா?';

  @override
  String get deleteIntro =>
      'நீங்கள் செல்வதற்கு வருந்துகிறோம். கணக்கை நீக்குவது, நாங்கள் வைத்திருக்க வேண்டிய அல்லது அனுமதிக்கப்பட்ட தகவல்களைத் தவிர, உங்கள் RepairMe சுயவிவரத்தையும் தொடர்புடைய தனிப்பட்ட தகவல்களையும் நிரந்தரமாக நீக்கக்கூடும்.';

  @override
  String get whyLeaving => 'ஏன் செல்கிறீர்கள்?';

  @override
  String get delReasonNoNeed => 'எனக்கு இனி RepairMe தேவையில்லை';

  @override
  String get delReasonPrivacy => 'எனக்கு தனியுரிமைக் கவலைகள் உள்ளன';

  @override
  String get delReasonBadExperience => 'எனக்கு மோசமான அனுபவம் ஏற்பட்டது';

  @override
  String get delReasonAnotherAccount => 'நான் இன்னொரு கணக்கை உருவாக்கினேன்';

  @override
  String get delReasonNotifications => 'எனக்கு அதிகமான அறிவிப்புகள் வருகின்றன';

  @override
  String get delReasonServices =>
      'எனக்குத் தேவையான சேவைகளைக் கண்டுபிடிக்க முடியவில்லை';

  @override
  String get tellUsMoreLabel => 'மேலும் சொல்லுங்கள்';

  @override
  String get continueToDelete => 'நீக்குவதைத் தொடரவும்';

  @override
  String get permanentWarningTitle => 'இந்தச் செயல் நிரந்தரமாக இருக்கலாம்';

  @override
  String get deleteWillRemove =>
      'இவை நீக்கப்படலாம் அல்லது அடையாளம் நீக்கப்படலாம்:';

  @override
  String get delRemoveProfile => 'உங்கள் சுயவிவரமும் தொடர்பு விவரங்களும்';

  @override
  String get delRemoveAddresses => 'சேமித்த முகவரிகளும் அவசரத் தொடர்பும்';

  @override
  String get delRemovePrefs => 'விருப்பங்களும் அறிவிப்புகளும்';

  @override
  String get delKeepNote =>
      'கட்டணங்கள் மற்றும் ஆதரவு வரலாறு போன்ற சில பதிவுகள், கணக்கியல், பாதுகாப்பு அல்லது சட்டக் காரணங்களுக்குத் தேவைப்படும்போது வைத்திருக்கப்படலாம்.';

  @override
  String get delConfirmCheck =>
      'நான் புரிந்துகொண்டேன்; என் கணக்கை நீக்க விரும்புகிறேன்';

  @override
  String get verifyAndDelete => 'சரிபார்த்து கணக்கை நீக்கு';

  @override
  String get deleteOtpTitle => 'குறியீட்டுடன் உறுதிசெய்யுங்கள்';

  @override
  String deleteOtpBody(String phone) {
    return 'உங்கள் பாதுகாப்பிற்காக, $phone க்கு நாங்கள் அனுப்பிய குறியீட்டை உள்ளிடுங்கள்.';
  }

  @override
  String get deleteAccountAction => 'என் கணக்கை நீக்கு';

  @override
  String get deleteError =>
      'உங்கள் கணக்கை நீக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get accountDeleted => 'உங்கள் கணக்கு நீக்கப்பட்டது';

  @override
  String get membershipTitle => 'RepairMe உறுப்பினர்';

  @override
  String get currentPlan => 'தற்போதைய திட்டம்';

  @override
  String get standardMember => 'நிலையான உறுப்பினர்';

  @override
  String get memberSince => 'உறுப்பினரான தேதி';

  @override
  String get yourBenefits => 'உங்கள் நன்மைகள்';

  @override
  String get benefit1 => 'சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளர்களுக்கான அணுகல்';

  @override
  String get benefit2 => 'அவசர சேவைக் கோரிக்கைகள்';

  @override
  String get benefit3 => 'திட்டமிட்ட முன்பதிவுகள்';

  @override
  String get benefit4 => 'அளவீட்டுக் கோரிக்கைகள்';

  @override
  String get benefit5 => 'முன்பதிவு வரலாறு';

  @override
  String get benefit6 => 'சேமித்த முகவரிகள்';

  @override
  String get membershipSoon => 'மேலும் உறுப்பினர் நன்மைகள் விரைவில் வருகின்றன.';

  @override
  String get addNewAddress => '+ புதிய முகவரியைச் சேர்';

  @override
  String get addAddress => 'முகவரியைச் சேர்';

  @override
  String get editAddress => 'முகவரியைத் திருத்து';

  @override
  String get saveAddress => 'முகவரியைச் சேமி';

  @override
  String get setAsDefault => 'இயல்புநிலையாக அமை';

  @override
  String get defaultBadge => 'இயல்புநிலை';

  @override
  String get deleteAddressQ => 'இந்த முகவரியை நீக்கவா?';

  @override
  String get deleteAddressBody => 'உங்கள் முந்தைய முன்பதிவுகள் பாதிக்கப்படாது.';

  @override
  String get delete => 'நீக்கு';

  @override
  String get noSavedAddressesYet => 'சேமித்த முகவரிகள் இன்னும் இல்லை';

  @override
  String get saveAddressHint =>
      'எதிர்கால முன்பதிவுகளை விரைவுபடுத்த உங்கள் வீடு அல்லது பணியிட முகவரியைச் சேமியுங்கள்.';

  @override
  String get addressLabelField => 'லேபிள்';

  @override
  String get recipientName => 'தொடர்பு பெயர் (விருப்பம்)';

  @override
  String get contactPhoneField => 'தொடர்பு மொபைல் எண் (விருப்பம்)';

  @override
  String get districtField => 'மாவட்டம்';

  @override
  String get instructionsField => 'கூடுதல் வழிமுறைகள் (விருப்பம்)';

  @override
  String get addressSaveError =>
      'இந்த முகவரியைச் சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get addressSaved => 'முகவரி சேமிக்கப்பட்டது';

  @override
  String get fieldRequired => 'இந்தப் புலம் தேவை';

  @override
  String get cashDesc =>
      'வேலை முடிந்ததும் உங்கள் தொழில்நுட்பவியலாளருக்கு நேரடியாகச் செலுத்துங்கள்.';

  @override
  String get cardOnline => 'அட்டை / ஆன்லைன் கட்டணம்';

  @override
  String get cardOnlineDesc =>
      'விரைவில். கட்டணங்கள் கட்டண வழங்குநரால் பாதுகாப்பாகக் கையாளப்படும்.';

  @override
  String get addPaymentMethod => '+ கட்டண முறையைச் சேர்';

  @override
  String get paymentSoonTitle => 'ஆன்லைன் கட்டணங்கள் விரைவில் வருகின்றன';

  @override
  String get paymentSoonBody =>
      'இப்போதைக்கு வேலை முடிந்ததும் பணமாகச் செலுத்தலாம். அட்டை மற்றும் பிற ஆன்லைன் கட்டணங்கள் கிடைக்கும்போது தெரிவிப்போம்.';

  @override
  String get okLabel => 'சரி';

  @override
  String get helpCenterFaqs => 'உதவி மையம் / FAQகள்';

  @override
  String get mySupportRequests => 'என் ஆதரவுக் கோரிக்கைகள்';

  @override
  String get contactSupport => 'ஆதரவைத் தொடர்புகொள்ளுங்கள்';

  @override
  String get reportProblem => 'சிக்கலைப் புகாரளி';

  @override
  String get paymentIssue => 'கட்டணச் சிக்கல்';

  @override
  String get bookingIssue => 'முன்பதிவுச் சிக்கல்';

  @override
  String get emergencyHelp => 'அவசர உதவி';

  @override
  String get emergencyHelpBody =>
      'அவசரத்தில், உடனே தொழில்நுட்பவியலாளரைக் கோருங்கள்.';

  @override
  String get requestEmergencyTechnician =>
      'அவசரத் தொழில்நுட்பவியலாளரைக் கோருங்கள்';

  @override
  String get issueHint =>
      'என்ன நடந்தது என்பதையும், அது முன்பதிவு அல்லது கட்டணம் பற்றியது என்றால் முன்பதிவு எண்ணையும் சொல்லுங்கள்.';

  @override
  String get noSupportRequests => 'ஆதரவுக் கோரிக்கைகள் இன்னும் இல்லை';

  @override
  String get noSupportHint =>
      'நீங்கள் ஆதரவைத் தொடர்புகொள்ளும்போது, உங்கள் கோரிக்கைகள் இங்கே தோன்றும்.';

  @override
  String get callUs => 'எங்களை அழையுங்கள்';

  @override
  String get emailUs => 'எங்களுக்கு மின்னஞ்சல் அனுப்புங்கள்';

  @override
  String get chatWithUs => 'எங்களுடன் அரட்டையடியுங்கள்';

  @override
  String get supportNotConfigured =>
      'ஆதரவுத் தொடர்பு விவரங்கள் விரைவில் கிடைக்கும். என் ஆதரவுக் கோரிக்கைகளிலிருந்து எங்களுக்கு எழுதலாம்.';

  @override
  String get couldNotOpen => 'அதைத் திறக்க முடியவில்லை';

  @override
  String get faqSearchHint => 'உதவியைத் தேடு';

  @override
  String get faqNoResults => 'பதில்கள் எதுவும் இல்லை';

  @override
  String get faqCatAccount => 'கணக்கு';

  @override
  String get faqCatBooking => 'முன்பதிவு';

  @override
  String get faqCatPayments => 'கட்டணங்கள்';

  @override
  String get faqCatTechnicians => 'தொழில்நுட்பவியலாளர்கள்';

  @override
  String get faqPhoneQ => 'என் மொபைல் எண்ணை எப்படி மாற்றுவது?';

  @override
  String get faqPhoneA =>
      'சுயவிவரம் → தனிப்பட்ட தகவல் → மொபைல் எண்ணை மாற்று என்பதற்குச் செல்லுங்கள். சரிபார்க்க புதிய எண்ணுக்கு ஒரு குறியீட்டை அனுப்புவோம்.';

  @override
  String get faqProfileQ => 'என் சுயவிவரத்தை எப்படிப் புதுப்பிப்பது?';

  @override
  String get faqProfileA =>
      'சுயவிவரத்தைத் திறந்து மேலே உங்கள் பெயரைத் தட்டி, விவரங்களை மாற்றி மாற்றங்களைச் சேமி என்பதைத் தட்டுங்கள்.';

  @override
  String get faqDeleteQ => 'என் கணக்கை எப்படி நீக்குவது?';

  @override
  String get faqDeleteA =>
      'சுயவிவரம் → தனிப்பட்ட தகவல் → கணக்கை நீக்கு என்பதற்குச் சென்று படிகளைப் பின்பற்றுங்கள். உங்கள் மொபைல் எண்ணுக்கு அனுப்பப்படும் குறியீட்டுடன் உறுதிசெய்வீர்கள்.';

  @override
  String get faqBookQ => 'தொழில்நுட்பவியலாளரை எப்படி முன்பதிவு செய்வது?';

  @override
  String get faqBookA =>
      'முகப்புத் திரையில் ஒரு சேவையைத் தேர்ந்தெடுத்து, பிரச்சினையை விவரித்து, இடத்தைத் தேர்ந்தெடுத்து உறுதிசெய்யுங்கள். சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளருடன் உங்களைப் பொருத்துவோம்.';

  @override
  String get faqEmergencyQ => 'அவசர முன்பதிவுகள் எப்படிச் செயல்படுகின்றன?';

  @override
  String get faqEmergencyA =>
      'அவசரக் கோரிக்கைகள் உடனே அருகிலுள்ள கிடைக்கக்கூடிய தொழில்நுட்பவியலாளருக்குச் செல்லும். முன்பதிவு செய்யும்போது அவசரம் என்பதைத் தேர்ந்தெடுங்கள்.';

  @override
  String get faqScheduledQ =>
      'திட்டமிட்ட முன்பதிவுகள் எப்படிச் செயல்படுகின்றன?';

  @override
  String get faqScheduledA =>
      'ஒரு நாளையும் வருகை நேர இடைவெளியையும் தேர்ந்தெடுங்கள். தொழில்நுட்பவியலாளர் முந்தைய நாள் வருகையை உறுதிசெய்வார்; 2 மணி நேரத்திற்கு முன் வரை இலவசமாக மாற்றியமைக்கலாம்.';

  @override
  String get faqMeasureQ => 'அளவீட்டுக் கோரிக்கை என்றால் என்ன?';

  @override
  String get faqMeasureA =>
      'வேலை தொடங்கும் முன் தொழில்நுட்பவியலாளர் ஆய்வு செய்து, அளந்து, மதிப்பீடு தரும் ஒரு வருகை.';

  @override
  String get faqMethodsQ => 'எந்த கட்டண முறைகள் ஆதரிக்கப்படுகின்றன?';

  @override
  String get faqMethodsA =>
      'வேலை முடிந்ததும் பணமாகச் செலுத்தலாம். அட்டை மற்றும் ஆன்லைன் கட்டணங்கள் விரைவில் வருகின்றன.';

  @override
  String get faqRefundQ => 'பணத்தைத் திரும்பப் பெறுதல் எப்படிச் செயல்படுகிறது?';

  @override
  String get faqRefundA =>
      'தவறுதலாகக் கட்டணம் வசூலிக்கப்பட்டால், உதவி & ஆதரவு → கட்டணச் சிக்கல் என்பதைத் திறந்து முன்பதிவைச் சொல்லுங்கள். ஒவ்வொரு கோரிக்கையையும் மதிப்பாய்வு செய்கிறோம்.';

  @override
  String get faqReceiptQ => 'என் ரசீதை எங்கே காணலாம்?';

  @override
  String get faqReceiptA =>
      'முன்பதிவுகள் → முடிந்தவை என்பதைத் திறந்து, பணியைத் தேர்ந்தெடுத்து ரசீதைப் பார் என்பதைத் தட்டுங்கள்.';

  @override
  String get faqRateQ => 'தொழில்நுட்பவியலாளரை எப்படி மதிப்பிடுவது?';

  @override
  String get faqRateA =>
      'ஒரு பணிக்குக் கட்டணம் செலுத்திய பிறகு, ரசீதைத் திறந்து மதிப்பிடு என்பதைத் தட்டுங்கள். உங்கள் கருத்து மற்ற வாடிக்கையாளர்களுக்கு உதவும்.';

  @override
  String get aboutTagline => 'தேவைப்படும்போது உதவி.';

  @override
  String get aboutDescription =>
      'RepairMe என்பது வசதியான பழுதுபார்ப்பு மற்றும் பராமரிப்புச் சேவைகளுக்காக வாடிக்கையாளர்களை நம்பகமான, சரிபார்க்கப்பட்ட தொழில்நுட்பவியலாளர்களுடன் இணைக்க வடிவமைக்கப்பட்ட தேவைக்கேற்ப பழுதுபார்ப்புச் சேவை தளம்.';

  @override
  String get aboutSvc1 => 'மின்சாரம்';

  @override
  String get aboutSvc2 => 'குழாய் வேலை';

  @override
  String get aboutSvc3 => 'ஏசி & குளிர்பதனம்';

  @override
  String get aboutSvc4 => 'உபகரணப் பழுதுபார்ப்பு';

  @override
  String get aboutSvc5 => 'இயந்திரச் சேவைகள்';

  @override
  String get aboutSvc6 => 'மோட்டார் சைக்கிள் / சாலையோரப் பழுதுபார்ப்பு';

  @override
  String get aboutSvc7 => 'வீட்டுப் பராமரிப்பு';

  @override
  String get aboutSvc8 => 'ஆதரிக்கப்படும் பிற பழுதுபார்ப்புச் சேவைகள்';

  @override
  String get contactUs => 'எங்களைத் தொடர்புகொள்ள';

  @override
  String get officialEmail => 'அதிகாரப்பூர்வ மின்னஞ்சல்';

  @override
  String get phoneLabel => 'தொலைபேசி';

  @override
  String get websiteLabel => 'இணையதளம்';

  @override
  String get officeAddress => 'அலுவலக முகவரி';

  @override
  String get contactSoon => 'தொடர்பு விவரங்கள் விரைவில் சேர்க்கப்படும்.';

  @override
  String get cancellationPolicy => 'ரத்து செய்யும் கொள்கை';

  @override
  String get refundPolicy => 'பணத்தைத் திரும்பப் பெறும் கொள்கை';

  @override
  String get paymentPolicy => 'கட்டணக் கொள்கை';

  @override
  String get dataDeletionPolicy => 'கணக்கு & தரவு நீக்கம்';

  @override
  String lastUpdatedOn(String date) {
    return 'கடைசியாகப் புதுப்பிக்கப்பட்டது: $date';
  }

  @override
  String get legalDraftNote =>
      'முன்மாதிரிக்கான மாதிரி உரை. அறிமுகத்திற்கு முன் இறுதிக் கொள்கைகள் மதிப்பாய்வு செய்யப்பட வேண்டும்.';

  @override
  String get legalEnglishNote =>
      'சட்ட ஆவணங்கள் தற்போது ஆங்கிலத்தில் மட்டுமே கிடைக்கும்.';

  @override
  String get deleteActiveBookings =>
      'உங்கள் கணக்கை நீக்கும் முன் செயலில் உள்ள முன்பதிவுகளை முடிக்கவும் அல்லது ரத்து செய்யவும்.';

  @override
  String get acceptTermsTitle => 'தொடர்வதற்கு முன்';

  @override
  String get acceptTermsBody =>
      'RepairMe-ஐப் பயன்படுத்த, எங்கள் விதிமுறைகள் & நிபந்தனைகள் மற்றும் தனியுரிமைக் கொள்கையைப் படித்து ஏற்கவும்.';

  @override
  String get acceptPrefix => 'நான் ';

  @override
  String get acceptMiddle => ' மற்றும் ';

  @override
  String get acceptSuffix => ' படித்து ஏற்கிறேன்.';

  @override
  String get acceptContinue => 'ஏற்று தொடரவும்';

  @override
  String get acceptError =>
      'உங்கள் ஏற்பைச் சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';
}
