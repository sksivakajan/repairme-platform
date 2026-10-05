// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get somethingWentWrong => 'යම් දෙයක් වැරදී ඇත.';

  @override
  String get tryAgain => 'නැවත උත්සාහ කරන්න';

  @override
  String stepOf(String step, String label) {
    return 'පියවර $step / 4 · $label';
  }

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get save => 'සුරකින්න';

  @override
  String get send => 'යවන්න';

  @override
  String get edit => 'සංස්කරණය';

  @override
  String get currencyPrefix => 'රු.';

  @override
  String get today => 'අද';

  @override
  String get yesterday => 'ඊයේ';

  @override
  String get tomorrow => 'හෙට';

  @override
  String get visitFee => 'පැමිණීමේ ගාස්තුව';

  @override
  String get labour => 'ශ්‍රම ගාස්තුව';

  @override
  String get parts => 'කොටස්';

  @override
  String get total => 'මුළු මුදල';

  @override
  String get statusFinding => 'සොයමින්';

  @override
  String get statusAssigning => 'පවරමින්';

  @override
  String get statusAssigned => 'පවරා ඇත';

  @override
  String get statusScheduled => 'කාලසටහන්ගතයි';

  @override
  String get statusOnTheWay => 'පැමිණෙමින්';

  @override
  String get statusWorking => 'වැඩ කරමින්';

  @override
  String get statusPaymentDue => 'ගෙවීම අවශ්‍යයි';

  @override
  String get statusCompleted => 'සම්පූර්ණයි';

  @override
  String get statusCancelled => 'අවලංගුයි';

  @override
  String get navHome => 'මුල් පිටුව';

  @override
  String get navBookings => 'වෙන්කිරීම්';

  @override
  String get navMessages => 'පණිවිඩ';

  @override
  String get navProfile => 'පැතිකඩ';

  @override
  String get chooseService => 'සේවාවක් තෝරන්න';

  @override
  String get searchService => 'සේවාවක් සොයන්න...';

  @override
  String get noMatchingService => 'ගැළපෙන සේවාවක් නැත';

  @override
  String get tabActive => 'සක්‍රීය';

  @override
  String get tabCompleted => 'සම්පූර්ණ';

  @override
  String get tabCancelled => 'අවලංගු';

  @override
  String get noActiveBookings => 'සක්‍රීය වෙන්කිරීම් නැත';

  @override
  String get noCompletedJobs => 'සම්පූර්ණ කළ වැඩ තවම නැත';

  @override
  String get noCancelledBookings => 'අවලංගු කළ වෙන්කිරීම් නැත';

  @override
  String get needAnotherRepair => 'තවත් අලුත්වැඩියාවක් අවශ්‍යද?';

  @override
  String get bookTechnicianHint =>
      'විනාඩි 2ක් පමණ ඇතුළත සත්‍යාපිත කාර්මිකයෙකු වෙන්කරගන්න.';

  @override
  String get cancelledByYou => 'ඔබ විසින් අවලංගු කරන ලදී';

  @override
  String get notifications => 'දැනුම්දීම්';

  @override
  String get readAll => 'සියල්ල කියවන්න';

  @override
  String get nothingHereYet => 'තවම කිසිවක් නැත';

  @override
  String get groupToday => 'අද';

  @override
  String get groupEarlier => 'කලින්';

  @override
  String get support => 'සහාය';

  @override
  String get callRepairMe => 'RepairMe අමතන්න';

  @override
  String get open24Hours => 'පැය 24ම විවෘතයි';

  @override
  String callNumber(String phone) {
    return '$phone අමතන්න';
  }

  @override
  String get writeToUs => 'අපට ලියන්න';

  @override
  String get repliesInMinutes => 'මිනිත්තු කිහිපයකින් පිළිතුරු';

  @override
  String get yourTickets => 'ඔබේ ටිකට්පත්';

  @override
  String get ticketResolved => 'විසඳා ඇත';

  @override
  String get ticketOpen => 'විවෘතයි';

  @override
  String get commonQuestions => 'නිතර අසන ප්‍රශ්න';

  @override
  String get faqReportQ => 'වෙන්කිරීමක ගැටලුවක් වාර්තා කරන්න';

  @override
  String get faqReportA =>
      'වෙන්කිරීම විවෘත කර “ගැටලුවක් වාර්තා කරන්න” භාවිතා කරන්න, නැතහොත් පහත ටිකට්පතක් සාදන්න. දිවා කාලයේදී අපගේ කණ්ඩායම මිනිත්තු කිහිපයක් ඇතුළත පිළිතුරු දෙයි.';

  @override
  String get faqPriceQ => 'මිල ගණනය කරන්නේ කෙසේද?';

  @override
  String get faqPriceA =>
      'සෑම පැමිණීමකටම රු. 500ක පැමිණීමේ ගාස්තුවක් ඇත. ශ්‍රමය සහ කොටස්වල මිල කාර්මිකයා ස්ථානයේදී ඉදිරිපත් කරන අතර, ඔබ යෙදුමේ එම මුදල අනුමත කරන තෙක් කිසිවක් අය නොකෙරේ.';

  @override
  String get faqVerifiedQ => 'කාර්මිකයන් සත්‍යාපනය කරන්නේ කෙසේද?';

  @override
  String get faqVerifiedA =>
      'සෑම RepairMe කාර්මිකයෙකුගේම හැඳුනුම්පත පරීක්ෂා කර, වැඩ භාරගැනීමට පෙර ඔවුන්ගේ වෘත්තීය ලේඛන අපගේ කණ්ඩායම විසින් සමාලෝචනය කරයි.';

  @override
  String get faqRefundsQ => 'ආපසු ගෙවීම් සහ අවලංගු කිරීම්';

  @override
  String get faqRefundsA =>
      'කාර්මිකයා පැමිණීමට පෙර අවලංගු කිරීම නොමිලේ. සම්පූර්ණ කළ සෑම වැඩයකටම දින 7ක ශිල්පීය වගකීමක් ඇත: එම දෝෂයම නැවත ඇති වුවහොත්, ශ්‍රම ගාස්තුවකින් තොරව අපි කෙනෙකු යවමු.';

  @override
  String get writeToRepairMe => 'RepairMe වෙත ලියන්න';

  @override
  String get subject => 'විෂය';

  @override
  String get ticketMessageHint => 'සිදු වූ දේ අපට කියන්න (අවම අක්ෂර 10ක්)';

  @override
  String get ticketThanks =>
      'ස්තූතියි — අපගේ කණ්ඩායම ඉක්මනින් ඔබ වෙත පිළිතුරු දෙනු ඇත';

  @override
  String get addYourName => 'ඔබේ නම එක් කරන්න';

  @override
  String get phoneVerified => 'දුරකථනය සත්‍යාපිතයි';

  @override
  String get addresses => 'ලිපිනයන්';

  @override
  String get savedAddresses => 'සුරකින ලද ලිපින';

  @override
  String get paymentMethods => 'ගෙවීම් ක්‍රම';

  @override
  String get cash => 'මුදල්';

  @override
  String get helpAndSupport => 'උදව් සහ සහාය';

  @override
  String get language => 'භාෂාව';

  @override
  String get termsAndPrivacy => 'නියම සහ රහස්‍යතාව';

  @override
  String get logOut => 'ඉවත් වන්න';

  @override
  String get yourName => 'ඔබේ නම';

  @override
  String get fullName => 'සම්පූර්ණ නම';

  @override
  String get noSavedAddresses => 'සුරකින ලද ලිපින නැත';

  @override
  String get noSavedAddressesHint =>
      'වෙන්කිරීම් සඳහා ඔබ භාවිතා කරන ලිපින මෙහි සුරැකේ.';

  @override
  String addressDefault(String label) {
    return '$label · පෙරනිමි';
  }

  @override
  String get appearance => 'පෙනුම';

  @override
  String get appearanceLight => 'ආලෝක';

  @override
  String get appearanceDark => 'අඳුරු';

  @override
  String get appearanceSystem => 'පද්ධතිය';

  @override
  String get greetMorning => 'සුභ උදෑසනක්';

  @override
  String get greetAfternoon => 'සුභ දහවලක්';

  @override
  String get greetEvening => 'සුභ සැන්දෑවක්';

  @override
  String get welcome => 'සාදරයෙන් පිළිගනිමු';

  @override
  String get addYourAddress => 'ඔබේ ලිපිනය එක් කරන්න';

  @override
  String get services => 'සේවා';

  @override
  String get seeAll => 'සියල්ල බලන්න';

  @override
  String get viewAll => 'සියල්ල බලන්න';

  @override
  String get topRatedTechnicians => 'ඉහළම ශ්‍රේණිගත කාර්මිකයන්';

  @override
  String notificationsUnread(String n) {
    return 'දැනුම්දීම්, නොකියවූ $nක්';
  }

  @override
  String technicianRated(String name, String trade, String rating) {
    return '$name, $trade, ශ්‍රේණිගත $rating';
  }

  @override
  String get bookNow => 'දැන් වෙන්කරන්න';

  @override
  String get getHelpNow => 'දැන් උදව් ගන්න';

  @override
  String useCode(String code) {
    return '$code කේතය භාවිතා කරන්න';
  }

  @override
  String get offerNewTag => 'නව ගනුදෙනුකරු දීමනාව';

  @override
  String get offerNewTitle => '20% වට්ටම්';

  @override
  String get offerNewSub => 'ඔබේ පළමු වෙන්කිරීම';

  @override
  String get offerHomeTag => 'ගෘහ අලුත්වැඩියා';

  @override
  String get offerHomeTitle => 'නොමිලේ පරීක්ෂාව';

  @override
  String get offerHomeSub => 'මෙම මාසයේ ඕනෑම ගෘහ අලුත්වැඩියාවකට';

  @override
  String get bookTechnician => 'කාර්මිකයෙකු වෙන්කරන්න';

  @override
  String get offerRoadTag => 'මාර්ග ආධාර';

  @override
  String get offerRoadTitle => 'රු. 500 වට්ටම්';

  @override
  String get offerRoadSub => 'බිඳවැටීම් සහ ඇදගෙන යාම, 24/7';

  @override
  String get teamLine1 => 'ශ්‍රී ලංකාවේ නිපදවූ,';

  @override
  String get teamLine2 => 'සෑම ශ්‍රී ලාංකිකයෙකු සඳහාම';

  @override
  String get meetTheTeam => 'කණ්ඩායම හඳුනාගන්න';

  @override
  String get emergencyTag => 'හදිසි';

  @override
  String get needHelpNow => 'දැන්ම උදව් අවශ්‍යද?';

  @override
  String techniciansOnline(int n) {
    return 'කාර්මිකයන් $n දෙනෙකු සබැඳියි · සාමාන්‍යය විනාඩි 18';
  }

  @override
  String get verifiedTechniciansAllDay => 'සත්‍යාපිත කාර්මිකයන්, පැය 24ම';

  @override
  String get brandTagline => 'සත්‍යාපිත විශේෂඥතාව. විශ්වාසනීය අඛණ්ඩතාව.';

  @override
  String get chipVerified => 'සත්‍යාපිත';

  @override
  String get chipFast => 'වේගවත්';

  @override
  String get chipTrusted => 'විශ්වාසනීය';

  @override
  String get topTechInfo =>
      'ඔබ වෙන්කරන විට, අපි ඔබට ආසන්නතම සත්‍යාපිත කාර්මිකයා සම්බන්ධ කරමු.';

  @override
  String get noRatingsYet => 'තවම ශ්‍රේණිගත කිරීම් නැත';

  @override
  String tradeAndJobs(String trade, int n) {
    return '$trade · රැකියා $nක්';
  }

  @override
  String get tradeElectrician => 'විදුලි කාර්මික';

  @override
  String get tradePlumber => 'ජල නළ කාර්මික';

  @override
  String get tradeAc => 'වායු සමීකරණ කාර්මික';

  @override
  String get tradeAppliance => 'උපකරණ අලුත්වැඩියා';

  @override
  String get tradeMechanic => 'මෙකැනික්';

  @override
  String get tradeLocksmith => 'අගුළු කාර්මික';

  @override
  String get tradeCarpenter => 'වඩු කාර්මික';

  @override
  String get tradeHandyman => 'සාමාන්‍ය කාර්මික';

  @override
  String get tradeTechnician => 'කාර්මික';

  @override
  String get categoryElectricalName => 'විදුලි';

  @override
  String get categoryElectricalDescription => 'රැහැන්, සොකට්, බ්‍රේකර්';

  @override
  String get categoryPlumbingName => 'ජල නළ';

  @override
  String get categoryPlumbingDescription => 'ටැප්, නළ, කාන්දු';

  @override
  String get categoryAcName => 'වායු සමීකරණ';

  @override
  String get categoryAcDescription => 'සේවා, ගෑස්, අලුත්වැඩියා';

  @override
  String get categoryRefrigeratorsName => 'ශීතකරණ';

  @override
  String get categoryRefrigeratorsDescription => 'සිසිල් නොවීම, කාන්දු';

  @override
  String get categoryWashingMachinesName => 'රෙදි සෝදන යන්ත්‍ර';

  @override
  String get categoryWashingMachinesDescription =>
      'ජලය බැස නොයෑම, ශබ්දය, බලය නැත';

  @override
  String get categoryMechanicName => 'මෙකැනික්';

  @override
  String get categoryMechanicDescription => 'යතුරුපැදි සහ වාහන';

  @override
  String get categoryFansLightsName => 'විදුලි පංකා සහ බල්බ';

  @override
  String get categoryFansLightsDescription => 'සවි කිරීම සහ අලුත්වැඩියා';

  @override
  String get categoryDoorsLocksName => 'දොරවල් සහ අගුළු';

  @override
  String get categoryDoorsLocksDescription => 'අගුළු, හැඬල්, අසුරු';

  @override
  String get categoryGeneralName => 'සාමාන්‍ය';

  @override
  String get categoryGeneralDescription => 'නිවස වටා කුඩා වැඩ';

  @override
  String get problemBreakerKeepsTripping => 'බ්‍රේකරය නිතර ට්‍රිප් වේ';

  @override
  String get problemSocketNotWorking => 'සොකට්ටුව ක්‍රියා නොකරයි';

  @override
  String get problemLightOrFanFault => 'බල්බ් හෝ පංකා දෝෂයක්';

  @override
  String get problemPowerOutage => 'විදුලිය විසන්ධි වීම';

  @override
  String get problemNewWiringOrPoints => 'නව රැහැන් හෝ පොයින්ට්';

  @override
  String get problemLeakingTap => 'කාන්දු වන ටැප් එක';

  @override
  String get problemBurstOrLeakingPipe => 'පුපුරා ගිය හෝ කාන්දු වන නළය';

  @override
  String get problemBlockedDrain => 'අවහිර වූ කාණුව';

  @override
  String get problemToiletOrCisternFault => 'වැසිකිළි හෝ ජල ටැංකි දෝෂයක්';

  @override
  String get problemWaterPumpProblem => 'ජල පොම්ප ගැටලුවක්';

  @override
  String get problemNotCooling => 'සිසිල් නොවේ';

  @override
  String get problemWaterLeaking => 'ජලය කාන්දු වේ';

  @override
  String get problemStrangeNoise => 'අමුතු ශබ්දයක්';

  @override
  String get problemRegularService => 'සාමාන්‍ය සේවාව';

  @override
  String get problemGasRefill => 'ගෑස් පිරවීම';

  @override
  String get problemNotTurningOn => 'ක්‍රියාත්මක නොවේ';

  @override
  String get problemNotDraining => 'ජලය බැස නොයයි';

  @override
  String get problemNotSpinning => 'කැරකෙන්නේ නැත';

  @override
  String get problemNoPower => 'බලය නැත';

  @override
  String get problemWillNotStart => 'පණ ගන්වන්නේ නැත';

  @override
  String get problemBatteryProblem => 'බැටරි ගැටලුවක්';

  @override
  String get problemFlatTyre => 'පන්චර් වූ ටයරය';

  @override
  String get problemBreakdownOnTheRoad => 'මාර්ගයේ බිඳවැටීමක්';

  @override
  String get problemInstallAFan => 'පංකාවක් සවි කිරීම';

  @override
  String get problemFanNotWorking => 'පංකාව ක්‍රියා නොකරයි';

  @override
  String get problemInstallLights => 'බල්බ සවි කිරීම';

  @override
  String get problemLightNotWorking => 'බල්බය ක්‍රියා නොකරයි';

  @override
  String get problemLockedOut => 'ඇතුළට යා නොහැකි ලෙස අගුළු වැටී ඇත';

  @override
  String get problemBrokenLock => 'කැඩුණු අගුල';

  @override
  String get problemDoorNotClosing => 'දොර වැසෙන්නේ නැත';

  @override
  String get problemReplaceHandleOrHinge => 'හැඬලය හෝ අසුර මාරු කිරීම';

  @override
  String get problemFurnitureAssembly => 'ගෘහ භාණ්ඩ එකලස් කිරීම';

  @override
  String get problemWallMounting => 'බිත්තියේ සවි කිරීම';

  @override
  String get problemSmallRepairs => 'කුඩා අලුත්වැඩියා';

  @override
  String get problemSomethingElse => 'වෙනත් දෙයක්';

  @override
  String get symptomBurningSmell => 'පිළිස්සුණු ගඳක්';

  @override
  String get symptomSparksSeen => 'ගිනි පුපුරු දක්නට ලැබේ';

  @override
  String get symptomOnlyOneRoom => 'කාමරයක් පමණි';

  @override
  String get symptomHappenedBefore => 'කලින් සිදු වී ඇත';

  @override
  String get symptomWaterLeakingNow => 'දැන් ජලය කාන්දු වේ';

  @override
  String get symptomLowPressure => 'පීඩනය අඩුයි';

  @override
  String get symptomBadSmell => 'නරක ගඳක්';

  @override
  String get symptomWaterDripping => 'ජලය බිංදු වැටේ';

  @override
  String get symptomWaterOnFloor => 'බිම ජලය';

  @override
  String get symptomIceBuildUp => 'අයිස් තැන්පත් වීම';

  @override
  String get symptomNoisy => 'ශබ්ද වේ';

  @override
  String get symptomErrorCodeShown => 'දෝෂ කේතයක් පෙන්වයි';

  @override
  String get symptomVehicleAtHome => 'වාහනය නිවසේ ඇත';

  @override
  String get symptomVehicleOnTheRoad => 'වාහනය මාර්ගයේ ඇත';

  @override
  String get symptomWarningLightOn => 'අනතුරු ඇඟවීමේ ආලෝකය දැල්වේ';

  @override
  String get symptomUrgent => 'හදිසියි';

  @override
  String get symptomNeedParts => 'කොටස් අවශ්‍යයි';

  @override
  String get onboard1Title => 'දින ගණන් නොව, විනාඩි කිහිපයකින් උදව්';

  @override
  String get onboard1Body =>
      'නළයක් පුපුරා ගියාද? විදුලිය නැතිද? හදිසි බොත්තම ඔබන්න, ආසන්නතම සත්‍යාපිත කාර්මිකයා පැමිණෙමින් සිටී.';

  @override
  String get onboard2Title => 'ඔබට ගැලපෙන වේලාවක් වෙන්කරගන්න';

  @override
  String get onboard2Body =>
      'අලුත්වැඩියා, සේවා හෝ පරීක්ෂාවක් සහ මිල ගණන් සඳහා දිනයක් සහ පැමිණීමේ කාල පරාසයක් තෝරන්න.';

  @override
  String get onboard3Title => 'සත්‍යාපිතයි. ඔබටම පාලනය';

  @override
  String get onboard3Body =>
      'සෑම කාර්මිකයෙකුගේම හැඳුනුම්පත පරීක්ෂා කෙරේ. වැඩ සඳහා මුදල් අය කිරීමට පෙර ඔබ පිරිවැය අනුමත කරයි.';

  @override
  String get skip => 'මඟ හරින්න';

  @override
  String get getStarted => 'ආරම්භ කරන්න';

  @override
  String get next => 'ඊළඟ';

  @override
  String get back => 'ආපසු';

  @override
  String get welcomeToRepairMe => 'RepairMe වෙත සාදරයෙන් පිළිගනිමු';

  @override
  String get homeRepairsSimple => 'ගෘහ අලුත්වැඩියා, පහසුවෙන්';

  @override
  String get enterMobile => 'ඔබේ ජංගම දුරකථන අංකය ඇතුළත් කරන්න';

  @override
  String get oneTimeCodeNote =>
      'අපි ඔබට එක් වරක් භාවිතා කළ හැකි කේතයක් එවන්නෙමු';

  @override
  String get sendCode => 'කේතය යවන්න';

  @override
  String get agreePrefix => 'ඉදිරියට යාමෙන් ඔබ අපගේ ';

  @override
  String get termsPrivacy => 'නියම සහ රහස්‍යතාව';

  @override
  String get agreeSuffix => ' වලට එකඟ වේ';

  @override
  String get enterVerificationCode => 'සත්‍යාපන කේතය ඇතුළත් කරන්න';

  @override
  String sentTo(String phone) {
    return '$phone වෙත යවන ලදී';
  }

  @override
  String get verify => 'සත්‍යාපනය කරන්න';

  @override
  String resendIn(String time) {
    return 'කේතය නැවත යැවීමට $time';
  }

  @override
  String get resendCode => 'කේතය නැවත යවන්න';

  @override
  String get newCodeSent => 'නව කේතයක් එවා ඇත';

  @override
  String authIncorrectCodeDev(String code) {
    return 'කේතය වැරදියි. සංවර්ධන අවස්ථාවේ $code භාවිතා කරන්න.';
  }

  @override
  String get authRequestNewCode => 'කරුණාකර නව කේතයක් ඉල්ලන්න.';

  @override
  String get authIncorrectCode =>
      'කේතය වැරදියි. කරුණාකර SMS පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get authInvalidPhone => 'එම ජංගම දුරකථන අංකය වලංගු නොවේ.';

  @override
  String get authTooMany =>
      'උත්සාහ කිරීම් වැඩියි. කරුණාකර රැඳී සිට නැවත උත්සාහ කරන්න.';

  @override
  String get authExpired => 'කේතය කල් ඉකුත් වී ඇත. කරුණාකර නව එකක් ඉල්ලන්න.';

  @override
  String get authFailed => 'පිවිසීම අසාර්ථකයි. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get noMessagesYet => 'තවම පණිවිඩ නැත';

  @override
  String get noMessagesHint =>
      'කාර්මිකයෙකු ඔබේ වෙන්කිරීම පිළිගත් විට, ඔවුන් සමඟ මෙහි කතාබහ කළ හැක.';

  @override
  String sayHelloTo(String name) {
    return '$name හට ආයුබෝවන් කියන්න';
  }

  @override
  String youPrefix(String message) {
    return 'ඔබ: $message';
  }

  @override
  String get splashTagline => 'අලුත්වැඩියා. වේගවත්. සත්‍යාපිත.';

  @override
  String get splashProud => 'ආඩම්බර ශ්‍රී ලාංකික';

  @override
  String get bookingTypeEmergency => 'හදිසි';

  @override
  String get bookingTypeSchedule => 'කාලසටහන්ගත';

  @override
  String get bookingTypeInspection => 'පරීක්ෂාව';

  @override
  String get addressHome => 'නිවස';

  @override
  String get addressOffice => 'රැකියා ස්ථානය';

  @override
  String get addressOther => 'වෙනත්';

  @override
  String get continueLabel => 'ඉදිරියට';

  @override
  String get requestDetails => 'ඉල්ලීමේ විස්තර';

  @override
  String get howSoon => 'ඔබට කොපමණ ඉක්මනින් උදව් අවශ්‍යද?';

  @override
  String get typeEmergencyBody =>
      'ආසන්නතම ලබා ගත හැකි කාර්මිකයා හැකි ඉක්මනින් පැමිණේ.';

  @override
  String get typeEmergencyHint => 'සාමාන්‍ය පැමිණීම විනාඩි 18';

  @override
  String get typeScheduledBody => 'ඔබට ගැලපෙන දිනයක් සහ කාල පරාසයක් තෝරන්න.';

  @override
  String get typeScheduledHint => 'වේලාවක් තෝරන්න';

  @override
  String get typeInspectionBody =>
      'පරීක්ෂා කර, මැන, මුලින්ම මිල ගණනක් ලබා දීමට පැමිණීමක්.';

  @override
  String get typeInspectionHint => 'වැඩට පෙර මිල ගණන';

  @override
  String get howPricingWorks => 'මිල ගණන් ක්‍රියා කරන ආකාරය';

  @override
  String pricingBody(String fee) {
    return 'පැමිණීමේ ගාස්තුව $fee + ශ්‍රමය + කොටස්. කාර්මිකයා අවසාන පිරිවැය එවන අතර, වැඩ සඳහා මුදල් අය කිරීමට පෙර ඔබ එය අනුමත කරයි.';
  }

  @override
  String continueWith(String type) {
    return '$type සමඟ ඉදිරියට';
  }

  @override
  String get stepProblem => 'ගැටලුව';

  @override
  String get whatIsProblem => 'ගැටලුව කුමක්ද?';

  @override
  String get tellUsMore => 'වැඩිදුර කියන්න';

  @override
  String get detailsHint =>
      'සිදු වූයේ කුමක්ද, ආරම්භ වූයේ කවදාද, කාර්මිකයා දැනගත යුතු ඕනෑම දෙයක් (අවම අක්ෂර 10ක්)';

  @override
  String get stepPhotos => 'ඡායාරූප';

  @override
  String get addPhotos => 'ඡායාරූප එක් කරන්න';

  @override
  String get photosSubtitle =>
      'අත්‍යවශ්‍ය නොවේ, නමුත් කාර්මිකයාට නිවැරදි මෙවලම් සහ කොටස් රැගෙන ඒමට උපකාරී වේ.';

  @override
  String get add => 'එක් කරන්න';

  @override
  String get takePhoto => 'ඡායාරූපයක් ගන්න';

  @override
  String get fromGallery => 'ගැලරියෙන්';

  @override
  String get photoTips => 'හොඳ ඡායාරූප සඳහා ඉඟි';

  @override
  String get photoTipsBody =>
      '· මුළු ප්‍රදේශයම පෙන්වා, පසුව සමීප රූපයක් ගන්න\n· මාදිලිය හෝ ලේබල් තහඩුව ඇතුළත් කරන්න\n· නිරාවරණය වූ රැහැන් අල්ලන්න එපා';

  @override
  String get skipForNow => 'දැනට මඟ හරින්න';

  @override
  String get photoOpenError =>
      'ඡායාරූප විවෘත කළ නොහැකි විය. කරුණාකර අවසරයන් පරීක්ෂා කරන්න.';

  @override
  String get stepLocation => 'ස්ථානය';

  @override
  String get whereShouldComeTitle => 'කාර්මිකයා පැමිණිය යුත්තේ කොහාටද?';

  @override
  String get yourArea => 'ඔබේ ප්‍රදේශය';

  @override
  String get addNew => 'අලුතින් එක් කරන්න';

  @override
  String get streetAddress => 'වීදි ලිපිනය';

  @override
  String get areaLabel => 'ප්‍රදේශය';

  @override
  String get cityLabel => 'නගරය';

  @override
  String get houseNumber => 'නිවස / මහල් නිවාස අංකය';

  @override
  String get landmarkLabel => 'සලකුණක් හෝ මාර්ග උපදෙස්';

  @override
  String get saveThisAddress => 'මෙම ලිපිනය සුරකින්න';

  @override
  String get confirmLocation => 'ස්ථානය තහවුරු කරන්න';

  @override
  String get inspectionVisit => 'පරීක්ෂණ චාරිකාව';

  @override
  String get scheduleVisit => 'චාරිකාවක් කාලසටහන්ගත කරන්න';

  @override
  String get whenShouldWeCome => 'අපි පැමිණිය යුත්තේ කවදාද?';

  @override
  String get arrivalWindow => 'පැමිණීමේ කාල පරාසය';

  @override
  String get visitConfirmNote =>
      'කාර්මිකයා පෙර දින චාරිකාව තහවුරු කරයි. පැය 2කට පෙර දක්වා ඔබට නොමිලේ නැවත කාලසටහන්ගත කළ හැක.';

  @override
  String selectedSlot(String when) {
    return 'තෝරාගත්: $when';
  }

  @override
  String get reviewRequest => 'ඉල්ලීම සමාලෝචනය';

  @override
  String get stepReview => 'සමාලෝචනය';

  @override
  String get checkYourRequest => 'ඔබේ ඉල්ලීම පරීක්ෂා කරන්න';

  @override
  String photosAttached(int n) {
    return 'ඡායාරූප $nක් අමුණා ඇත';
  }

  @override
  String get estimatedCost => 'ඇස්තමේන්තුගත පිරිවැය';

  @override
  String get labourAndParts => 'ශ්‍රමය සහ කොටස්';

  @override
  String get quotedOnSite => 'ස්ථානයේදී මිල ගණන් කෙරේ';

  @override
  String get approveFinalCost =>
      'වැඩ සඳහා මුදල් අය කිරීමට පෙර ඔබ යෙදුමේ අවසාන පිරිවැය අනුමත කරයි.';

  @override
  String get payWithCash => 'මුදලින් ගෙවන්න';

  @override
  String get afterTheJob => 'වැඩේ අවසන් වූ පසු';

  @override
  String get requestTechnician => 'කාර්මිකයෙකු ඉල්ලන්න';

  @override
  String photosFailed(int n) {
    return 'ඡායාරූප $nක් උඩුගත කළ නොහැකි විය';
  }

  @override
  String get theTechnician => 'කාර්මිකයා';

  @override
  String get yourTechnician => 'ඔබේ කාර්මිකයා';

  @override
  String get otherLabel => 'වෙනත්';

  @override
  String get bkFinding => 'කාර්මිකයෙකු සොයමින්';

  @override
  String get bkTeamAssigning => 'කණ්ඩායම පවරමින්';

  @override
  String get bkAssigned => 'කාර්මිකයා පවරා ඇත';

  @override
  String get bkCancelledRequest => 'අවලංගු කළ ඉල්ලීම';

  @override
  String get bkJobStatus => 'වැඩ තත්ත්වය';

  @override
  String get stepRequestReceived => 'ඉල්ලීම ලැබුණි';

  @override
  String get stepNoTechAccepted => 'කිසිදු කාර්මිකයෙකු පිළිගත්තේ නැත';

  @override
  String get stepTeamAssigning => 'RepairMe කණ්ඩායම පවරමින්';

  @override
  String get stepTechConfirms => 'කාර්මිකයා තහවුරු කරයි';

  @override
  String get stepMatchingNearby => 'ආසන්න කාර්මිකයන් ගලපමින්';

  @override
  String requestRef(String ref) {
    return 'ඉල්ලීම #$ref';
  }

  @override
  String get operatorFindingTitle =>
      'අපගේ කණ්ඩායම ඔබ වෙනුවෙන් කෙනෙකු සොයමින් සිටී';

  @override
  String findingVerifiedTitle(String category) {
    return 'සත්‍යාපිත $category කාර්මිකයෙකු සොයමින්';
  }

  @override
  String get operatorFindingBody =>
      'තවම කිසිදු කාර්මිකයෙකු පිළිගෙන නැත, එබැවින් RepairMe ක්‍රියාකරුවෙකු ඔබ වෙනුවෙන් කෙනෙකු පවරමින් සිටී. සාමාන්‍යයෙන් විනාඩි 2කට අඩුයි.';

  @override
  String matchingNear(String area) {
    return '$area අවට කාර්මිකයන් සමඟ ඔබව ගලපමින්.';
  }

  @override
  String confirmingFor(String when) {
    return '$when සඳහා කාර්මිකයෙකු තහවුරු කරමින් සිටිමු.';
  }

  @override
  String get ifNobodyAccepts =>
      'කිසිවෙකු පිළිගන්නේ නැතිනම්, RepairMe කණ්ඩායම ඔබ වෙනුවෙන් කාර්මිකයෙකු පවරයි.';

  @override
  String get cancelRequest => 'ඉල්ලීම අවලංගු කරන්න';

  @override
  String get cancelThisRequest => 'මෙම ඉල්ලීම අවලංගු කරන්නද?';

  @override
  String get noChargeNoTech => 'තවම කාර්මිකයෙකු පවරා නැති නිසා ගාස්තුවක් නැත.';

  @override
  String noChargeNotArrived(String name) {
    return '$name තවම පැමිණ නැති නිසා ගාස්තුවක් නැත.';
  }

  @override
  String get reasonFoundSomeone => 'වෙනත් කෙනෙකු සොයා ගත්තා';

  @override
  String get reasonProblemFixed => 'ගැටලුව විසඳී ඇත';

  @override
  String get reasonWaitingTooLong => 'ඕනෑවට වඩා කාලයක් බලා සිටීම';

  @override
  String get tellUsMoreOptional => 'වැඩිදුර කියන්න (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get keepWaiting => 'දිගටම බලා සිටින්න';

  @override
  String etaMin(String n) {
    return 'පැමිණීමට විනාඩි $n';
  }

  @override
  String techOnTheWayTitle(String name) {
    return '$name පැමිණෙමින් සිටී';
  }

  @override
  String techWillVisit(String name, String when) {
    return '$name $when පැමිණෙනු ඇත';
  }

  @override
  String techAccepted(String name) {
    return '$name ඔබේ ඉල්ලීම පිළිගත්තා';
  }

  @override
  String arrivesInAbout(String n) {
    return 'විනාඩි $nක් පමණ ඇතුළත පැමිණේ';
  }

  @override
  String get viewJobStatus => 'වැඩ තත්ත්වය බලන්න';

  @override
  String get cancelBooking => 'වෙන්කිරීම අවලංගු කරන්න';

  @override
  String verifiedCategoryTech(String category) {
    return 'සත්‍යාපිත $category කාර්මික';
  }

  @override
  String get newTech => 'නව';

  @override
  String ratingAndJobs(String rating, int n) {
    return '$rating · රැකියා $nක්';
  }

  @override
  String jobCodeShare(String name) {
    return 'වැඩ කේතය · $name පැමිණි විට පමණක් බෙදා ගන්න';
  }

  @override
  String messageTech(String name) {
    return '$name හට පණිවිඩයක්';
  }

  @override
  String jobNumber(String ref) {
    return 'වැඩ #$ref';
  }

  @override
  String get costReadyTitle => 'ඔබේ අනුමැතිය සඳහා පිරිවැය සූදානම්';

  @override
  String costReadyBody(String name, String amount) {
    return '$name $amount එවා ඇත · සමාලෝචනයට ඔබන්න';
  }

  @override
  String get repairCompleted => 'අලුත්වැඩියාව සම්පූර්ණයි';

  @override
  String payTo(String amount, String name) {
    return '$name වෙත $amount ගෙවන්න';
  }

  @override
  String get paymentReceived => 'ගෙවීම ලැබුණි';

  @override
  String viewReceiptRate(String name) {
    return 'රිසිට්පත බලා $name ශ්‍රේණිගත කරන්න';
  }

  @override
  String get viewReceipt => 'රිසිට්පත බලන්න';

  @override
  String get bookingWasCancelled => 'මෙම වෙන්කිරීම අවලංගු කරන ලදී';

  @override
  String get cancelledByYouNoCharge =>
      'ඔබ විසින් අවලංගු කරන ලදී · ගාස්තුවක් නැත';

  @override
  String get cancelledByRepairMe => 'RepairMe විසින් අවලංගු කරන ලදී';

  @override
  String get tlRequestCreated => 'ඉල්ලීම සාදන ලදී';

  @override
  String get tlAccepted => 'කාර්මිකයා පිළිගත්තා';

  @override
  String get tlOnTheWay => 'පැමිණෙමින්';

  @override
  String get tlArrived => 'පැමිණියා';

  @override
  String tlJobCodeVerified(String time) {
    return 'වැඩ කේතය සත්‍යාපනය කරන ලදී · $time';
  }

  @override
  String get tlWorking => 'වැඩ කරමින්';

  @override
  String get tlCostApproved => 'පිරිවැය අනුමත කළා, වැඩ සිදු වෙමින්';

  @override
  String get tlInspectionDone => 'පරීක්ෂාව අවසන්, පිරිවැය එවා ඇත';

  @override
  String get tlCompleted => 'සම්පූර්ණයි';

  @override
  String get tlPayAndRate => 'ගෙවා ශ්‍රේණිගත කරන්න';

  @override
  String get yourPhotos => 'ඔබේ ඡායාරූප';

  @override
  String beforePhotosBy(String name) {
    return '$name ගත් පෙර ඡායාරූප';
  }

  @override
  String get afterPhotos => 'පසු ඡායාරූප';

  @override
  String get requestHeading => 'ඉල්ලීම';

  @override
  String get reportProblemWithJob => 'මෙම වැඩේ ගැටලුවක් වාර්තා කරන්න';

  @override
  String problemWithRef(String ref) {
    return '$ref සම්බන්ධ ගැටලුවක්';
  }

  @override
  String get chat => 'කතාබහ';

  @override
  String onTheWayEta(String n) {
    return 'පැමිණෙමින් · විනාඩි $nකින්';
  }

  @override
  String chatSafety(String name) {
    return 'ඔබේ ආරක්ෂාව සඳහා පණිවිඩ සටහන් කෙරේ. $name පැමිණෙන තෙක් ඔබේ වැඩ කේතය කිසිවිටෙකත් බෙදා නොගන්න.';
  }

  @override
  String timeSeen(String time) {
    return '$time · දැක ඇත';
  }

  @override
  String get quickAtHome => 'මම නිවසේ සිටිමි';

  @override
  String get quickCallMe => 'මට අමතන්න';

  @override
  String get quickSideGate => 'පැත්තේ ගේට්ටුව භාවිතා කරන්න';

  @override
  String get messageHint => 'පණිවිඩය';

  @override
  String get chatClosed => 'මෙම වෙන්කිරීම සඳහා කතාබහ වසා ඇත.';

  @override
  String get declineCostQ => 'මෙම පිරිවැය ප්‍රතික්ෂේප කරන්නද?';

  @override
  String get declineCostBody =>
      'කාර්මිකයාට දැනුම් දෙනු ලැබේ. වැඩක් සිදු නොකළහොත් පැමිණීමේ ගාස්තුව පමණක් අදාළ වේ.';

  @override
  String get decline => 'ප්‍රතික්ෂේප කරන්න';

  @override
  String get costApprovedToast => 'පිරිවැය අනුමත කළා. වැඩ ඉදිරියට පවතී.';

  @override
  String get costDeclinedToast => 'පිරිවැය ප්‍රතික්ෂේප කළා';

  @override
  String get approveCostTitle => 'පිරිවැය අනුමත කරන්න';

  @override
  String get nothingToApprove => 'දැන් අනුමත කිරීමට කිසිවක් නැත';

  @override
  String get totalToApprove => 'අනුමත කළ යුතු මුළු මුදල';

  @override
  String noteFrom(String name) {
    return '$name ගෙන් සටහනක්';
  }

  @override
  String get workStartsAfterApprove =>
      'ඔබ අනුමත කළ පසුව පමණක් වැඩ ආරම්භ වේ. පිරිවැය වෙනස් වුවහොත්, නැවත ඔබෙන් අසනු ලැබේ.';

  @override
  String approveAmount(String amount) {
    return '$amount අනුමත කරන්න';
  }

  @override
  String get askQuestion => 'ප්‍රශ්නයක් අසන්න';

  @override
  String get payment => 'ගෙවීම';

  @override
  String repairCompletedBy(String name) {
    return '$name විසින් අලුත්වැඩියාව සම්පූර්ණ කරන ලදී';
  }

  @override
  String repairCompletedByAt(String name, String time) {
    return '$name විසින් අලුත්වැඩියාව සම්පූර්ණ කරන ලදී · $time';
  }

  @override
  String get paymentMethodHeading => 'ගෙවීම් ක්‍රමය';

  @override
  String payTechDirectly(String name) {
    return '$name වෙත සෘජුවම ගෙවන්න';
  }

  @override
  String get card => 'කාඩ්පත';

  @override
  String get comingSoon => 'ඉක්මනින් එනවා';

  @override
  String get mobileWallet => 'ජංගම පසුම්බිය';

  @override
  String handCashTo(String amount, String name) {
    return '$amount ක් $name අතට දෙන්න. ඔවුන් තහවුරු කළ වහාම ඔබේ රිසිට්පත දිස්වේ.';
  }

  @override
  String confirmPaymentAmount(String amount) {
    return 'ගෙවීම තහවුරු කරන්න · $amount';
  }

  @override
  String get receipt => 'රිසිට්පත';

  @override
  String paidInCash(String amount) {
    return '$amount ක් මුදලින් ගෙවන ලදී';
  }

  @override
  String paidIn(String amount, String method) {
    return '$amount ක් $method ලෙස ගෙවන ලදී';
  }

  @override
  String receiptNumber(String ref) {
    return 'රිසිට්පත #$ref';
  }

  @override
  String get totalPaid => 'ගෙවූ මුළු මුදල';

  @override
  String get warrantyTitle => 'දින 7ක ශිල්පීය වගකීම';

  @override
  String get warrantyBody =>
      'එම දෝෂයම නැවත ඇති වුවහොත්, ශ්‍රම ගාස්තුවකින් තොරව අපි කෙනෙකු යවමු.';

  @override
  String youRated(String name, String rating) {
    return 'ඔබ $name $rating★ ලෙස ශ්‍රේණිගත කළා · අවසන්';
  }

  @override
  String rateName(String name) {
    return '$name ශ්‍රේණිගත කරන්න';
  }

  @override
  String get rateExperience => 'ඔබේ අත්දැකීම ශ්‍රේණිගත කරන්න';

  @override
  String get tagOnTime => 'නියමිත වේලාවට';

  @override
  String get tagProfessional => 'වෘත්තීයමය';

  @override
  String get tagCleanWork => 'පිරිසිදු වැඩ';

  @override
  String get tagFairPrice => 'සාධාරණ මිල';

  @override
  String get tagExplainedClearly => 'පැහැදිලිව පැහැදිලි කළා';

  @override
  String get ratePoor => 'දුර්වලයි';

  @override
  String get rateCouldBeBetter => 'වඩා හොඳ විය හැකිය';

  @override
  String get rateGood => 'හොඳයි';

  @override
  String get rateGreat => 'විශිෂ්ටයි';

  @override
  String get rateExcellent => 'අති විශිෂ්ටයි';

  @override
  String howWasName(String name) {
    return '$name කෙසේද?';
  }

  @override
  String get whatWentWell => 'හොඳින් සිදු වූයේ කුමක්ද?';

  @override
  String get addCommentOptional => 'අදහසක් එක් කරන්න (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get commentHint => 'වැඩේ ගැන අන් අයට කියන්න';

  @override
  String get submitRating => 'ශ්‍රේණිගත කිරීම යවන්න';

  @override
  String get thankYouRating => 'ඔබේ ශ්‍රේණිගත කිරීමට ස්තූතියි!';

  @override
  String get enterMobileToContinue =>
      'ඉදිරියට යාමට ඔබේ ජංගම දුරකථන අංකය ඇතුළත් කරන්න';

  @override
  String get legalPrefix => 'ඉදිරියට යාමෙන්, ඔබ RepairMe හි ';

  @override
  String get termsAndConditions => 'නියම සහ කොන්දේසි';

  @override
  String get legalMiddle => ' වලට එකඟ වන අතර ';

  @override
  String get privacyPolicy => 'රහස්‍යතා ප්‍රතිපත්තිය';

  @override
  String get privacyPolicyLink => 'රහස්‍යතා ප්‍රතිපත්තිය';

  @override
  String get legalSuffix => ' පිළිගන්නා බව සලකනු ලැබේ.';

  @override
  String get verifyYourNumber => 'ඔබේ අංකය සත්‍යාපනය කරන්න';

  @override
  String get sentCodeTo => 'අපි සත්‍යාපන කේතයක් යවා ඇත:';

  @override
  String get changeNumber => 'අංකය වෙනස් කරන්න';

  @override
  String get didntReceive => 'කේතය ලැබුණේ නැද්ද?';

  @override
  String get completeYourProfile => 'ඔබේ පැතිකඩ සම්පූර්ණ කරන්න';

  @override
  String get completeProfileSub =>
      'ඔබේ ගිණුම සෑදීම අවසන් කිරීමට ඔබ ගැන ටිකක් කියන්න.';

  @override
  String get firstName => 'මුල් නම';

  @override
  String get lastName => 'අවසන් නම';

  @override
  String get emailOptional => 'ඊමේල් ලිපිනය (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get emailLabel => 'ඊමේල් ලිපිනය';

  @override
  String get mobileNumber => 'ජංගම දුරකථන අංකය';

  @override
  String get verifiedBadge => 'සත්‍යාපිතයි';

  @override
  String get createAccount => 'ගිණුම සාදන්න';

  @override
  String get firstNameRequired => 'ඔබේ මුල් නම ඇතුළත් කරන්න';

  @override
  String get lastNameRequired => 'ඔබේ අවසන් නම ඇතුළත් කරන්න';

  @override
  String get emailInvalid => 'වලංගු ඊමේල් ලිපිනයක් ඇතුළත් කරන්න';

  @override
  String get phoneInvalid => 'වලංගු ශ්‍රී ලංකා ජංගම අංකයක් ඇතුළත් කරන්න';

  @override
  String get createAccountError =>
      'ඔබේ ගිණුම සෑදීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get profileUpdateError =>
      'ඔබේ පැතිකඩ යාවත්කාලීන කිරීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get offlineTitle => 'RepairMe වෙත සම්බන්ධ විය නොහැක';

  @override
  String get offlineBody =>
      'ඔබේ අන්තර්ජාල සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get networkError =>
      'RepairMe වෙත සම්බන්ධ විය නොහැක. ඔබේ සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get signInAgain => 'කරුණාකර නැවත පිවිසෙන්න.';

  @override
  String get authPhoneInUse =>
      'මෙම ජංගම අංකය දැනටමත් වෙනත් ගිණුමක් සමඟ සම්බන්ධ කර ඇත.';

  @override
  String get viewEditProfile => 'පැතිකඩ බලන්න / සංස්කරණය';

  @override
  String get sectionAccount => 'ගිණුම';

  @override
  String get sectionSupport => 'සහාය';

  @override
  String get sectionAbout => 'පිළිබඳව';

  @override
  String get membership => 'සාමාජිකත්වය';

  @override
  String get aboutRepairMe => 'RepairMe ගැන';

  @override
  String get legalAndPrivacy => 'නීතිමය සහ රහස්‍යතාව';

  @override
  String get followUs => 'අපව අනුගමනය කරන්න';

  @override
  String get madeInSriLanka => 'ශ්‍රී ලංකාවේ නිපදවන ලදී';

  @override
  String appVersion(String version) {
    return 'අනුවාදය $version';
  }

  @override
  String get linkNotAvailable => 'මෙම සබැඳිය තවම ලබා ගත නොහැක';

  @override
  String get logOutQ => 'ඉවත් වන්නද?';

  @override
  String get logOutConfirm =>
      'ඔබට RepairMe වෙතින් ඉවත් වීමට අවශ්‍ය බව ඉඳුරාම විශ්වාසද?';

  @override
  String get logOutAction => 'ඉවත් වන්න';

  @override
  String get personalInformation => 'පුද්ගලික තොරතුරු';

  @override
  String get changeProfilePhoto => 'පැතිකඩ ඡායාරූපය වෙනස් කරන්න';

  @override
  String get removePhoto => 'ඡායාරූපය ඉවත් කරන්න';

  @override
  String get personalDetails => 'පුද්ගලික විස්තර';

  @override
  String get birthday => 'උපන්දිනය';

  @override
  String get birthdayHint => 'DD / MM / YYYY';

  @override
  String get gender => 'ස්ත්‍රී පුරුෂ භාවය';

  @override
  String get genderMale => 'පිරිමි';

  @override
  String get genderFemale => 'ගැහැණු';

  @override
  String get genderPrefer => 'කියන්නට කැමති නැත';

  @override
  String get selectGender => 'තෝරන්න';

  @override
  String get saveChanges => 'වෙනස්කම් සුරකින්න';

  @override
  String get changesSaved => 'වෙනස්කම් සුරැකිණි';

  @override
  String get chooseLanguage => 'භාෂාව තෝරන්න';

  @override
  String get emergencyContact => 'හදිසි සම්බන්ධතා';

  @override
  String get emergencyContactHint =>
      'හදිසි අවස්ථාවකදී අපට සම්බන්ධ කරගත හැකි කෙනෙක්. එම අරමුණට පමණක් භාවිතා වේ.';

  @override
  String get contactName => 'සම්බන්ධතා නම';

  @override
  String get relationship => 'සම්බන්ධතාව';

  @override
  String get relationshipFamily => 'පවුලේ';

  @override
  String get relationshipFriend => 'මිතුරා';

  @override
  String get relationshipNeighbour => 'අසල්වැසියා';

  @override
  String get addEmergencyContact => 'හදිසි සම්බන්ධතාවක් එක් කරන්න';

  @override
  String get remove => 'ඉවත් කරන්න';

  @override
  String get removeContactQ => 'හදිසි සම්බන්ධතාව ඉවත් කරන්නද?';

  @override
  String get removeContactBody => 'මෙම සම්බන්ධතාව ඔබේ ගිණුමෙන් මකා දමනු ලැබේ.';

  @override
  String get contactSaved => 'හදිසි සම්බන්ධතාව සුරැකිණි';

  @override
  String get additionalSettings => 'අමතර සැකසුම්';

  @override
  String get changeMobileNumber => 'ජංගම අංකය වෙනස් කරන්න';

  @override
  String get notificationPreferences => 'දැනුම්දීම් මනාප';

  @override
  String get dangerZone => 'අනතුරු කලාපය';

  @override
  String get deleteAccount => 'ගිණුම මකන්න';

  @override
  String get enterNewNumber => 'ඔබේ නව ජංගම අංකය ඇතුළත් කරන්න';

  @override
  String get changeNumberNote =>
      'එය සත්‍යාපනය කිරීමට අපි නව අංකයට කේතයක් යවන්නෙමු. ඔබේ ගිණුම සහ වෙන්කිරීම් නොවෙනස්ව පවතී.';

  @override
  String get sameNumber => 'එය දැනටමත් ඔබේ අංකයයි';

  @override
  String get numberChanged => 'ජංගම අංකය යාවත්කාලීන කරන ලදී';

  @override
  String get verifyNewNumber => 'නව අංකය සත්‍යාපනය කරන්න';

  @override
  String get notifBooking => 'වෙන්කිරීම් යාවත්කාලීන';

  @override
  String get notifBookingSub =>
      'කාර්මිකයා පිළිගැනීම, පැමිණීම සහ වෙන්කිරීම් තත්ත්ව යාවත්කාලීන.';

  @override
  String get notifReminders => 'සේවා මතක් කිරීම්';

  @override
  String get notifRemindersSub => 'ඉදිරියට එන කාලසටහන්ගත සේවා.';

  @override
  String get notifPayments => 'ගෙවීම් යාවත්කාලීන';

  @override
  String get notifPaymentsSub => 'රිසිට්පත්, ගෙවීම් තත්ත්වය සහ ආපසු ගෙවීම්.';

  @override
  String get notifOffers => 'දීමනා සහ ප්‍රවර්ධන';

  @override
  String get notifOffersSub => 'අලෙවිකරණ පණිවිඩ සහ ප්‍රවර්ධන.';

  @override
  String get notifUpdates => 'RepairMe යාවත්කාලීන';

  @override
  String get notifUpdatesSub => 'වැදගත් නිෂ්පාදන සහ සේවා යාවත්කාලීන.';

  @override
  String get notifEssentialNote =>
      'අත්‍යවශ්‍ය ගිණුම්, ආරක්ෂණ සහ වෙන්කිරීම් ආරක්ෂණ පණිවිඩ සැමවිටම යවනු ලැබේ.';

  @override
  String get deleteTitle => 'ඔබේ RepairMe ගිණුම මකන්නද?';

  @override
  String get deleteIntro =>
      'ඔබ යාම ගැන අපි කණගාටු වෙමු. ගිණුම මැකීමෙන් ඔබේ RepairMe පැතිකඩ සහ ආශ්‍රිත පුද්ගලික තොරතුරු, අපට රඳවා ගැනීමට අවශ්‍ය හෝ අවසර ඇති තොරතුරු හැර, ස්ථිරවම ඉවත් විය හැක.';

  @override
  String get whyLeaving => 'ඔබ යන්නේ ඇයි?';

  @override
  String get delReasonNoNeed => 'මට තවදුරටත් RepairMe අවශ්‍ය නැත';

  @override
  String get delReasonPrivacy => 'මට රහස්‍යතා ගැටලු ඇත';

  @override
  String get delReasonBadExperience => 'මට නරක අත්දැකීමක් ලැබුණා';

  @override
  String get delReasonAnotherAccount => 'මම තවත් ගිණුමක් සාදා ගත්තා';

  @override
  String get delReasonNotifications => 'මට දැනුම්දීම් ඕනෑවට වඩා ලැබේ';

  @override
  String get delReasonServices => 'මට අවශ්‍ය සේවා සොයා ගැනීමට නොහැකි විය';

  @override
  String get tellUsMoreLabel => 'වැඩිදුර කියන්න';

  @override
  String get continueToDelete => 'මැකීම වෙත ඉදිරියට';

  @override
  String get permanentWarningTitle => 'මෙම ක්‍රියාව ස්ථිර විය හැක';

  @override
  String get deleteWillRemove => 'මේවා ඉවත් කිරීමට හෝ නිර්නාමික කිරීමට ඉඩ ඇත:';

  @override
  String get delRemoveProfile => 'ඔබේ පැතිකඩ සහ සම්බන්ධතා විස්තර';

  @override
  String get delRemoveAddresses => 'සුරකින ලද ලිපින සහ හදිසි සම්බන්ධතාව';

  @override
  String get delRemovePrefs => 'මනාප සහ දැනුම්දීම්';

  @override
  String get delKeepNote =>
      'ගෙවීම් සහ සහාය ඉතිහාසය වැනි සමහර වාර්තා, ගිණුම්කරණ, ආරක්ෂණ හෝ නීතිමය හේතු නිසා අවශ්‍ය වන විට රඳවා ගත හැක.';

  @override
  String get delConfirmCheck =>
      'මම තේරුම් ගෙන ඇති අතර මගේ ගිණුම මැකීමට කැමතියි';

  @override
  String get verifyAndDelete => 'සත්‍යාපනය කර ගිණුම මකන්න';

  @override
  String get deleteOtpTitle => 'කේතයකින් තහවුරු කරන්න';

  @override
  String deleteOtpBody(String phone) {
    return 'ඔබේ ආරක්ෂාව සඳහා, අපි $phone වෙත යැවූ කේතය ඇතුළත් කරන්න.';
  }

  @override
  String get deleteAccountAction => 'මගේ ගිණුම මකන්න';

  @override
  String get deleteError =>
      'ඔබේ ගිණුම මැකීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get accountDeleted => 'ඔබේ ගිණුම මකා දමන ලදී';

  @override
  String get membershipTitle => 'RepairMe සාමාජිකත්වය';

  @override
  String get currentPlan => 'වත්මන් සැලසුම';

  @override
  String get standardMember => 'සම්මත සාමාජික';

  @override
  String get memberSince => 'සාමාජිකත්වය ලැබූ දිනය';

  @override
  String get yourBenefits => 'ඔබේ ප්‍රතිලාභ';

  @override
  String get benefit1 => 'සත්‍යාපිත කාර්මිකයන් වෙත ප්‍රවේශය';

  @override
  String get benefit2 => 'හදිසි සේවා ඉල්ලීම්';

  @override
  String get benefit3 => 'කාලසටහන්ගත වෙන්කිරීම්';

  @override
  String get benefit4 => 'මිනුම් ඉල්ලීම්';

  @override
  String get benefit5 => 'වෙන්කිරීම් ඉතිහාසය';

  @override
  String get benefit6 => 'සුරකින ලද ලිපින';

  @override
  String get membershipSoon => 'තවත් සාමාජික ප්‍රතිලාභ ඉක්මනින් පැමිණේ.';

  @override
  String get addNewAddress => '+ නව ලිපිනයක් එක් කරන්න';

  @override
  String get addAddress => 'ලිපිනය එක් කරන්න';

  @override
  String get editAddress => 'ලිපිනය සංස්කරණය';

  @override
  String get saveAddress => 'ලිපිනය සුරකින්න';

  @override
  String get setAsDefault => 'පෙරනිමි ලෙස සකසන්න';

  @override
  String get defaultBadge => 'පෙරනිමි';

  @override
  String get deleteAddressQ => 'මෙම ලිපිනය මකන්නද?';

  @override
  String get deleteAddressBody => 'ඔබේ පෙර වෙන්කිරීම්වලට බලපෑමක් නැත.';

  @override
  String get delete => 'මකන්න';

  @override
  String get noSavedAddressesYet => 'සුරකින ලද ලිපින තවම නැත';

  @override
  String get saveAddressHint =>
      'අනාගත වෙන්කිරීම් වේගවත් කිරීමට ඔබේ නිවසේ හෝ රැකියා ස්ථානයේ ලිපිනය සුරකින්න.';

  @override
  String get addressLabelField => 'ලේබලය';

  @override
  String get recipientName => 'සම්බන්ධතා නම (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get contactPhoneField => 'සම්බන්ධතා ජංගම අංකය (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get districtField => 'දිස්ත්‍රික්කය';

  @override
  String get instructionsField => 'අමතර උපදෙස් (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get addressSaveError =>
      'මෙම ලිපිනය සුරැකීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get addressSaved => 'ලිපිනය සුරැකිණි';

  @override
  String get fieldRequired => 'මෙම ක්ෂේත්‍රය අවශ්‍යයි';

  @override
  String get cashDesc => 'වැඩේ අවසන් වූ පසු ඔබේ කාර්මිකයාට සෘජුවම ගෙවන්න.';

  @override
  String get cardOnline => 'කාඩ්පත / මාර්ගගත ගෙවීම';

  @override
  String get cardOnlineDesc =>
      'ඉක්මනින් එනවා. ගෙවීම් ගෙවීම් සපයන්නෙකු විසින් ආරක්ෂිතව සිදු කෙරේ.';

  @override
  String get addPaymentMethod => '+ ගෙවීම් ක්‍රමයක් එක් කරන්න';

  @override
  String get paymentSoonTitle => 'මාර්ගගත ගෙවීම් ඉක්මනින් පැමිණේ';

  @override
  String get paymentSoonBody =>
      'දැනට වැඩේ අවසන් වූ පසු මුදලින් ගෙවිය හැක. කාඩ්පත් සහ අනෙකුත් මාර්ගගත ගෙවීම් ලබා ගත හැකි වූ විට අපි ඔබට දන්වන්නෙමු.';

  @override
  String get okLabel => 'හරි';

  @override
  String get helpCenterFaqs => 'උදව් මධ්‍යස්ථානය / නිතර අසන ප්‍රශ්න';

  @override
  String get mySupportRequests => 'මගේ සහාය ඉල්ලීම්';

  @override
  String get contactSupport => 'සහාය අමතන්න';

  @override
  String get reportProblem => 'ගැටලුවක් වාර්තා කරන්න';

  @override
  String get paymentIssue => 'ගෙවීම් ගැටලුව';

  @override
  String get bookingIssue => 'වෙන්කිරීම් ගැටලුව';

  @override
  String get emergencyHelp => 'හදිසි උදව්';

  @override
  String get emergencyHelpBody => 'හදිසි අවස්ථාවක, වහාම කාර්මිකයෙකු ඉල්ලන්න.';

  @override
  String get requestEmergencyTechnician => 'හදිසි කාර්මිකයෙකු ඉල්ලන්න';

  @override
  String get issueHint =>
      'සිදු වූ දේ, සහ එය වෙන්කිරීමක් හෝ ගෙවීමක් ගැන නම්, වෙන්කිරීම් අංකය අපට කියන්න.';

  @override
  String get noSupportRequests => 'සහාය ඉල්ලීම් තවම නැත';

  @override
  String get noSupportHint => 'ඔබ සහාය අමතන විට, ඔබේ ඉල්ලීම් මෙහි දිස්වේ.';

  @override
  String get callUs => 'අපට අමතන්න';

  @override
  String get emailUs => 'අපට ඊමේල් කරන්න';

  @override
  String get chatWithUs => 'අප සමඟ කතා කරන්න';

  @override
  String get supportNotConfigured =>
      'සහාය සම්බන්ධතා විස්තර ඉක්මනින් ලබා ගත හැකි වේ. ඔබට තවමත් මගේ සහාය ඉල්ලීම් වෙතින් අපට ලිවිය හැක.';

  @override
  String get couldNotOpen => 'එය විවෘත කළ නොහැකි විය';

  @override
  String get faqSearchHint => 'උදව් සොයන්න';

  @override
  String get faqNoResults => 'පිළිතුරු හමු නොවීය';

  @override
  String get faqCatAccount => 'ගිණුම';

  @override
  String get faqCatBooking => 'වෙන්කිරීම';

  @override
  String get faqCatPayments => 'ගෙවීම්';

  @override
  String get faqCatTechnicians => 'කාර්මිකයන්';

  @override
  String get faqPhoneQ => 'මගේ ජංගම අංකය වෙනස් කරන්නේ කෙසේද?';

  @override
  String get faqPhoneA =>
      'පැතිකඩ → පුද්ගලික තොරතුරු → ජංගම අංකය වෙනස් කරන්න වෙත යන්න. එය සත්‍යාපනය කිරීමට අපි නව අංකයට කේතයක් යවමු.';

  @override
  String get faqProfileQ => 'මගේ පැතිකඩ යාවත්කාලීන කරන්නේ කෙසේද?';

  @override
  String get faqProfileA =>
      'පැතිකඩ විවෘත කර ඉහළින් ඇති ඔබේ නම ඔබා, ඔබේ විස්තර වෙනස් කර වෙනස්කම් සුරකින්න ඔබන්න.';

  @override
  String get faqDeleteQ => 'මගේ ගිණුම මකන්නේ කෙසේද?';

  @override
  String get faqDeleteA =>
      'පැතිකඩ → පුද්ගලික තොරතුරු → ගිණුම මකන්න වෙත ගොස් පියවර අනුගමනය කරන්න. ඔබේ ජංගම අංකයට එවන කේතයකින් තහවුරු කරනු ඇත.';

  @override
  String get faqBookQ => 'කාර්මිකයෙකු වෙන්කරන්නේ කෙසේද?';

  @override
  String get faqBookA =>
      'මුල් පිටුවේ සේවාවක් තෝරා, ගැටලුව විස්තර කර, ස්ථානයක් තෝරා තහවුරු කරන්න. අපි ඔබව සත්‍යාපිත කාර්මිකයෙකු සමඟ ගළපමු.';

  @override
  String get faqEmergencyQ => 'හදිසි වෙන්කිරීම් ක්‍රියා කරන්නේ කෙසේද?';

  @override
  String get faqEmergencyA =>
      'හදිසි ඉල්ලීම් වහාම ආසන්නතම ලබා ගත හැකි කාර්මිකයා වෙත යයි. වෙන්කරන විට හදිසි තෝරන්න.';

  @override
  String get faqScheduledQ => 'කාලසටහන්ගත වෙන්කිරීම් ක්‍රියා කරන්නේ කෙසේද?';

  @override
  String get faqScheduledA =>
      'දිනයක් සහ පැමිණීමේ කාල පරාසයක් තෝරන්න. කාර්මිකයා පෙර දින චාරිකාව තහවුරු කරයි, පැය 2කට පෙර දක්වා නොමිලේ නැවත කාලසටහන්ගත කළ හැක.';

  @override
  String get faqMeasureQ => 'මිනුම් ඉල්ලීමක් යනු කුමක්ද?';

  @override
  String get faqMeasureA =>
      'වැඩ ආරම්භ කිරීමට පෙර කාර්මිකයා පරීක්ෂා කර, මැන, මිල ගණනක් ලබා දෙන චාරිකාවකි.';

  @override
  String get faqMethodsQ => 'සහාය දක්වන ගෙවීම් ක්‍රම මොනවාද?';

  @override
  String get faqMethodsA =>
      'වැඩේ අවසන් වූ පසු මුදලින් ගෙවිය හැක. කාඩ්පත් සහ මාර්ගගත ගෙවීම් ඉක්මනින් එනවා.';

  @override
  String get faqRefundQ => 'ආපසු ගෙවීම් ක්‍රියා කරන්නේ කෙසේද?';

  @override
  String get faqRefundA =>
      'ඔබට වැරදීමකින් අය කර ඇත්නම්, උදව් සහ සහාය → ගෙවීම් ගැටලුව විවෘත කර වෙන්කිරීම අපට කියන්න. අපි සෑම ඉල්ලීමක්ම සමාලෝචනය කරමු.';

  @override
  String get faqReceiptQ => 'මගේ රිසිට්පත සොයා ගන්නේ කොහෙන්ද?';

  @override
  String get faqReceiptA =>
      'වෙන්කිරීම් → සම්පූර්ණ වෙත ගොස්, වැඩය තෝරා රිසිට්පත බලන්න ඔබන්න.';

  @override
  String get faqRateQ => 'කාර්මිකයෙකු ශ්‍රේණිගත කරන්නේ කෙසේද?';

  @override
  String get faqRateA =>
      'වැඩයක් ගෙවූ පසු, රිසිට්පත විවෘත කර ශ්‍රේණිගත කරන්න ඔබන්න. ඔබේ ප්‍රතිචාර අනෙක් ගනුදෙනුකරුවන්ට උපකාරී වේ.';

  @override
  String get aboutTagline => 'ඔබට අවශ්‍ය විට උදව්.';

  @override
  String get aboutDescription =>
      'RepairMe යනු පහසු අලුත්වැඩියා සහ නඩත්තු සේවා සඳහා ගනුදෙනුකරුවන් විශ්වාසදායක සහ සත්‍යාපිත කාර්මිකයන් සමඟ සම්බන්ධ කිරීමට නිර්මාණය කළ ඉල්ලුම මත අලුත්වැඩියා සේවා වේදිකාවකි.';

  @override
  String get aboutSvc1 => 'විදුලි';

  @override
  String get aboutSvc2 => 'ජල නළ';

  @override
  String get aboutSvc3 => 'වායු සමීකරණ සහ ශීතකරණ';

  @override
  String get aboutSvc4 => 'උපකරණ අලුත්වැඩියා';

  @override
  String get aboutSvc5 => 'යාන්ත්‍රික සේවා';

  @override
  String get aboutSvc6 => 'යතුරුපැදි / මාර්ග අයිනේ අලුත්වැඩියා';

  @override
  String get aboutSvc7 => 'නිවාස නඩත්තුව';

  @override
  String get aboutSvc8 => 'සහාය දක්වන අනෙකුත් අලුත්වැඩියා සේවා';

  @override
  String get contactUs => 'අපව සම්බන්ධ කරගන්න';

  @override
  String get officialEmail => 'නිල ඊමේල්';

  @override
  String get phoneLabel => 'දුරකථන';

  @override
  String get websiteLabel => 'වෙබ් අඩවිය';

  @override
  String get officeAddress => 'කාර්යාල ලිපිනය';

  @override
  String get contactSoon => 'සම්බන්ධතා විස්තර ඉක්මනින් එක් කරනු ලැබේ.';

  @override
  String get cancellationPolicy => 'අවලංගු කිරීමේ ප්‍රතිපත්තිය';

  @override
  String get refundPolicy => 'ආපසු ගෙවීමේ ප්‍රතිපත්තිය';

  @override
  String get paymentPolicy => 'ගෙවීම් ප්‍රතිපත්තිය';

  @override
  String get dataDeletionPolicy => 'ගිණුම සහ දත්ත මැකීම';

  @override
  String lastUpdatedOn(String date) {
    return 'අවසන් යාවත්කාලීනය: $date';
  }

  @override
  String get legalDraftNote =>
      'මූලාකෘතිය සඳහා නියැදි පෙළකි. දියත් කිරීමට පෙර අවසාන ප්‍රතිපත්ති සමාලෝචනය කළ යුතුය.';

  @override
  String get legalEnglishNote =>
      'නීතිමය ලේඛන දැනට ඉංග්‍රීසියෙන් පමණක් ලබා ගත හැක.';

  @override
  String get deleteActiveBookings =>
      'ඔබේ ගිණුම මැකීමට පෙර ඔබේ සක්‍රීය වෙන්කිරීම් අවසන් කරන්න හෝ අවලංගු කරන්න.';

  @override
  String get acceptTermsTitle => 'ඉදිරියට යාමට පෙර';

  @override
  String get acceptTermsBody =>
      'RepairMe භාවිතා කිරීමට, කරුණාකර අපගේ නියම සහ කොන්දේසි සහ රහස්‍යතා ප්‍රතිපත්තිය කියවා පිළිගන්න.';

  @override
  String get acceptPrefix => 'මම ';

  @override
  String get acceptMiddle => ' සහ ';

  @override
  String get acceptSuffix => ' කියවා පිළිගන්නෙමි.';

  @override
  String get acceptContinue => 'පිළිගෙන ඉදිරියට';

  @override
  String get acceptError =>
      'ඔබේ පිළිගැනීම සුරැකීමට නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';
}
