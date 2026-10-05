import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4 · {label}'**
  String stepOf(String step, String label);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @currencyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get currencyPrefix;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @visitFee.
  ///
  /// In en, this message translates to:
  /// **'Visit fee'**
  String get visitFee;

  /// No description provided for @labour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get labour;

  /// No description provided for @parts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get parts;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @statusFinding.
  ///
  /// In en, this message translates to:
  /// **'FINDING'**
  String get statusFinding;

  /// No description provided for @statusAssigning.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNING'**
  String get statusAssigning;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNED'**
  String get statusAssigned;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED'**
  String get statusScheduled;

  /// No description provided for @statusOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'ON THE WAY'**
  String get statusOnTheWay;

  /// No description provided for @statusWorking.
  ///
  /// In en, this message translates to:
  /// **'WORKING'**
  String get statusWorking;

  /// No description provided for @statusPaymentDue.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT DUE'**
  String get statusPaymentDue;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get statusCancelled;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @chooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get chooseService;

  /// No description provided for @searchService.
  ///
  /// In en, this message translates to:
  /// **'Search for a service...'**
  String get searchService;

  /// No description provided for @noMatchingService.
  ///
  /// In en, this message translates to:
  /// **'No matching service'**
  String get noMatchingService;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @tabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tabCompleted;

  /// No description provided for @tabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tabCancelled;

  /// No description provided for @noActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'No active bookings'**
  String get noActiveBookings;

  /// No description provided for @noCompletedJobs.
  ///
  /// In en, this message translates to:
  /// **'No completed jobs yet'**
  String get noCompletedJobs;

  /// No description provided for @noCancelledBookings.
  ///
  /// In en, this message translates to:
  /// **'No cancelled bookings'**
  String get noCancelledBookings;

  /// No description provided for @needAnotherRepair.
  ///
  /// In en, this message translates to:
  /// **'Need another repair?'**
  String get needAnotherRepair;

  /// No description provided for @bookTechnicianHint.
  ///
  /// In en, this message translates to:
  /// **'Book a verified technician in about 2 minutes.'**
  String get bookTechnicianHint;

  /// No description provided for @cancelledByYou.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by you'**
  String get cancelledByYou;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get readAll;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @groupToday.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get groupToday;

  /// No description provided for @groupEarlier.
  ///
  /// In en, this message translates to:
  /// **'EARLIER'**
  String get groupEarlier;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @callRepairMe.
  ///
  /// In en, this message translates to:
  /// **'Call RepairMe'**
  String get callRepairMe;

  /// No description provided for @open24Hours.
  ///
  /// In en, this message translates to:
  /// **'Open 24 hours'**
  String get open24Hours;

  /// No description provided for @callNumber.
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String callNumber(String phone);

  /// No description provided for @writeToUs.
  ///
  /// In en, this message translates to:
  /// **'Write to us'**
  String get writeToUs;

  /// No description provided for @repliesInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Replies in minutes'**
  String get repliesInMinutes;

  /// No description provided for @yourTickets.
  ///
  /// In en, this message translates to:
  /// **'Your tickets'**
  String get yourTickets;

  /// No description provided for @ticketResolved.
  ///
  /// In en, this message translates to:
  /// **'RESOLVED'**
  String get ticketResolved;

  /// No description provided for @ticketOpen.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get ticketOpen;

  /// No description provided for @commonQuestions.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get commonQuestions;

  /// No description provided for @faqReportQ.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with a booking'**
  String get faqReportQ;

  /// No description provided for @faqReportA.
  ///
  /// In en, this message translates to:
  /// **'Open the booking and use \"Report a problem\", or create a ticket below. Our team replies within minutes during the day.'**
  String get faqReportA;

  /// No description provided for @faqPriceQ.
  ///
  /// In en, this message translates to:
  /// **'How is the price calculated?'**
  String get faqPriceQ;

  /// No description provided for @faqPriceA.
  ///
  /// In en, this message translates to:
  /// **'Every visit has a Rs. 500 visit fee. Labour and parts are quoted by the technician on site, and nothing is charged until you approve the cost in the app.'**
  String get faqPriceA;

  /// No description provided for @faqVerifiedQ.
  ///
  /// In en, this message translates to:
  /// **'How are technicians verified?'**
  String get faqVerifiedQ;

  /// No description provided for @faqVerifiedA.
  ///
  /// In en, this message translates to:
  /// **'Every RepairMe technician is ID-checked and their trade documents are reviewed by our team before they can accept jobs.'**
  String get faqVerifiedA;

  /// No description provided for @faqRefundsQ.
  ///
  /// In en, this message translates to:
  /// **'Refunds and cancellations'**
  String get faqRefundsQ;

  /// No description provided for @faqRefundsA.
  ///
  /// In en, this message translates to:
  /// **'Cancelling before a technician arrives is free. Every completed job has a 7-day workmanship cover: if the same fault returns, we send someone back at no labour cost.'**
  String get faqRefundsA;

  /// No description provided for @writeToRepairMe.
  ///
  /// In en, this message translates to:
  /// **'Write to RepairMe'**
  String get writeToRepairMe;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @ticketMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened (at least 10 characters)'**
  String get ticketMessageHint;

  /// No description provided for @ticketThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks — our team will get back to you shortly'**
  String get ticketThanks;

  /// No description provided for @addYourName.
  ///
  /// In en, this message translates to:
  /// **'Add your name'**
  String get addYourName;

  /// No description provided for @phoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone verified'**
  String get phoneVerified;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get savedAddresses;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpAndSupport;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms and privacy'**
  String get termsAndPrivacy;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @noSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get noSavedAddresses;

  /// No description provided for @noSavedAddressesHint.
  ///
  /// In en, this message translates to:
  /// **'Addresses you use for bookings are saved here.'**
  String get noSavedAddressesHint;

  /// No description provided for @addressDefault.
  ///
  /// In en, this message translates to:
  /// **'{label} · Default'**
  String addressDefault(String label);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @greetMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetMorning;

  /// No description provided for @greetAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetAfternoon;

  /// No description provided for @greetEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetEvening;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @addYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Add your address'**
  String get addYourAddress;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @topRatedTechnicians.
  ///
  /// In en, this message translates to:
  /// **'Top rated technicians'**
  String get topRatedTechnicians;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Notifications, {n} unread'**
  String notificationsUnread(String n);

  /// No description provided for @technicianRated.
  ///
  /// In en, this message translates to:
  /// **'{name}, {trade}, rated {rating}'**
  String technicianRated(String name, String trade, String rating);

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @getHelpNow.
  ///
  /// In en, this message translates to:
  /// **'Get help now'**
  String get getHelpNow;

  /// No description provided for @useCode.
  ///
  /// In en, this message translates to:
  /// **'Use code {code}'**
  String useCode(String code);

  /// No description provided for @offerNewTag.
  ///
  /// In en, this message translates to:
  /// **'NEW CUSTOMER OFFER'**
  String get offerNewTag;

  /// No description provided for @offerNewTitle.
  ///
  /// In en, this message translates to:
  /// **'20% OFF'**
  String get offerNewTitle;

  /// No description provided for @offerNewSub.
  ///
  /// In en, this message translates to:
  /// **'Your first booking'**
  String get offerNewSub;

  /// No description provided for @offerHomeTag.
  ///
  /// In en, this message translates to:
  /// **'HOME REPAIRS'**
  String get offerHomeTag;

  /// No description provided for @offerHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free inspection'**
  String get offerHomeTitle;

  /// No description provided for @offerHomeSub.
  ///
  /// In en, this message translates to:
  /// **'On any home repair this month'**
  String get offerHomeSub;

  /// No description provided for @bookTechnician.
  ///
  /// In en, this message translates to:
  /// **'Book a technician'**
  String get bookTechnician;

  /// No description provided for @offerRoadTag.
  ///
  /// In en, this message translates to:
  /// **'ROADSIDE ASSIST'**
  String get offerRoadTag;

  /// No description provided for @offerRoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Rs. 500 OFF'**
  String get offerRoadTitle;

  /// No description provided for @offerRoadSub.
  ///
  /// In en, this message translates to:
  /// **'Breakdown & towing, 24/7'**
  String get offerRoadSub;

  /// No description provided for @teamLine1.
  ///
  /// In en, this message translates to:
  /// **'Built in Sri Lanka,'**
  String get teamLine1;

  /// No description provided for @teamLine2.
  ///
  /// In en, this message translates to:
  /// **'for every Sri Lankan'**
  String get teamLine2;

  /// No description provided for @meetTheTeam.
  ///
  /// In en, this message translates to:
  /// **'Meet the team'**
  String get meetTheTeam;

  /// No description provided for @emergencyTag.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get emergencyTag;

  /// No description provided for @needHelpNow.
  ///
  /// In en, this message translates to:
  /// **'Need help right now?'**
  String get needHelpNow;

  /// No description provided for @techniciansOnline.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 technician online} other{{n} technicians online}} · avg. 18 min'**
  String techniciansOnline(int n);

  /// No description provided for @verifiedTechniciansAllDay.
  ///
  /// In en, this message translates to:
  /// **'Verified technicians, 24 hours a day'**
  String get verifiedTechniciansAllDay;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Verified expertise. Trusted integrity.'**
  String get brandTagline;

  /// No description provided for @chipVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get chipVerified;

  /// No description provided for @chipFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get chipFast;

  /// No description provided for @chipTrusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get chipTrusted;

  /// No description provided for @topTechInfo.
  ///
  /// In en, this message translates to:
  /// **'When you book, we match you with the nearest available verified technician.'**
  String get topTechInfo;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @tradeAndJobs.
  ///
  /// In en, this message translates to:
  /// **'{trade} · {n, plural, =1{1 job} other{{n} jobs}}'**
  String tradeAndJobs(String trade, int n);

  /// No description provided for @tradeElectrician.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get tradeElectrician;

  /// No description provided for @tradePlumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get tradePlumber;

  /// No description provided for @tradeAc.
  ///
  /// In en, this message translates to:
  /// **'AC technician'**
  String get tradeAc;

  /// No description provided for @tradeAppliance.
  ///
  /// In en, this message translates to:
  /// **'Appliance repair'**
  String get tradeAppliance;

  /// No description provided for @tradeMechanic.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get tradeMechanic;

  /// No description provided for @tradeLocksmith.
  ///
  /// In en, this message translates to:
  /// **'Locksmith'**
  String get tradeLocksmith;

  /// No description provided for @tradeCarpenter.
  ///
  /// In en, this message translates to:
  /// **'Carpenter'**
  String get tradeCarpenter;

  /// No description provided for @tradeHandyman.
  ///
  /// In en, this message translates to:
  /// **'Handyman'**
  String get tradeHandyman;

  /// No description provided for @tradeTechnician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get tradeTechnician;

  /// No description provided for @categoryElectricalName.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get categoryElectricalName;

  /// No description provided for @categoryElectricalDescription.
  ///
  /// In en, this message translates to:
  /// **'Wiring, sockets, breakers'**
  String get categoryElectricalDescription;

  /// No description provided for @categoryPlumbingName.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get categoryPlumbingName;

  /// No description provided for @categoryPlumbingDescription.
  ///
  /// In en, this message translates to:
  /// **'Taps, pipes, leaks'**
  String get categoryPlumbingDescription;

  /// No description provided for @categoryAcName.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get categoryAcName;

  /// No description provided for @categoryAcDescription.
  ///
  /// In en, this message translates to:
  /// **'Service, gas, repairs'**
  String get categoryAcDescription;

  /// No description provided for @categoryRefrigeratorsName.
  ///
  /// In en, this message translates to:
  /// **'Refrigerators'**
  String get categoryRefrigeratorsName;

  /// No description provided for @categoryRefrigeratorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Not cooling, leaks'**
  String get categoryRefrigeratorsDescription;

  /// No description provided for @categoryWashingMachinesName.
  ///
  /// In en, this message translates to:
  /// **'Washing machines'**
  String get categoryWashingMachinesName;

  /// No description provided for @categoryWashingMachinesDescription.
  ///
  /// In en, this message translates to:
  /// **'Drain, noise, no power'**
  String get categoryWashingMachinesDescription;

  /// No description provided for @categoryMechanicName.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get categoryMechanicName;

  /// No description provided for @categoryMechanicDescription.
  ///
  /// In en, this message translates to:
  /// **'Bikes and vehicles'**
  String get categoryMechanicDescription;

  /// No description provided for @categoryFansLightsName.
  ///
  /// In en, this message translates to:
  /// **'Fans and lights'**
  String get categoryFansLightsName;

  /// No description provided for @categoryFansLightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Install and repair'**
  String get categoryFansLightsDescription;

  /// No description provided for @categoryDoorsLocksName.
  ///
  /// In en, this message translates to:
  /// **'Doors and locks'**
  String get categoryDoorsLocksName;

  /// No description provided for @categoryDoorsLocksDescription.
  ///
  /// In en, this message translates to:
  /// **'Locks, handles, hinges'**
  String get categoryDoorsLocksDescription;

  /// No description provided for @categoryGeneralName.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneralName;

  /// No description provided for @categoryGeneralDescription.
  ///
  /// In en, this message translates to:
  /// **'Small jobs around the home'**
  String get categoryGeneralDescription;

  /// No description provided for @problemBreakerKeepsTripping.
  ///
  /// In en, this message translates to:
  /// **'Breaker keeps tripping'**
  String get problemBreakerKeepsTripping;

  /// No description provided for @problemSocketNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Socket not working'**
  String get problemSocketNotWorking;

  /// No description provided for @problemLightOrFanFault.
  ///
  /// In en, this message translates to:
  /// **'Light or fan fault'**
  String get problemLightOrFanFault;

  /// No description provided for @problemPowerOutage.
  ///
  /// In en, this message translates to:
  /// **'Power outage'**
  String get problemPowerOutage;

  /// No description provided for @problemNewWiringOrPoints.
  ///
  /// In en, this message translates to:
  /// **'New wiring or points'**
  String get problemNewWiringOrPoints;

  /// No description provided for @problemLeakingTap.
  ///
  /// In en, this message translates to:
  /// **'Leaking tap'**
  String get problemLeakingTap;

  /// No description provided for @problemBurstOrLeakingPipe.
  ///
  /// In en, this message translates to:
  /// **'Burst or leaking pipe'**
  String get problemBurstOrLeakingPipe;

  /// No description provided for @problemBlockedDrain.
  ///
  /// In en, this message translates to:
  /// **'Blocked drain'**
  String get problemBlockedDrain;

  /// No description provided for @problemToiletOrCisternFault.
  ///
  /// In en, this message translates to:
  /// **'Toilet or cistern fault'**
  String get problemToiletOrCisternFault;

  /// No description provided for @problemWaterPumpProblem.
  ///
  /// In en, this message translates to:
  /// **'Water pump problem'**
  String get problemWaterPumpProblem;

  /// No description provided for @problemNotCooling.
  ///
  /// In en, this message translates to:
  /// **'Not cooling'**
  String get problemNotCooling;

  /// No description provided for @problemWaterLeaking.
  ///
  /// In en, this message translates to:
  /// **'Water leaking'**
  String get problemWaterLeaking;

  /// No description provided for @problemStrangeNoise.
  ///
  /// In en, this message translates to:
  /// **'Strange noise'**
  String get problemStrangeNoise;

  /// No description provided for @problemRegularService.
  ///
  /// In en, this message translates to:
  /// **'Regular service'**
  String get problemRegularService;

  /// No description provided for @problemGasRefill.
  ///
  /// In en, this message translates to:
  /// **'Gas refill'**
  String get problemGasRefill;

  /// No description provided for @problemNotTurningOn.
  ///
  /// In en, this message translates to:
  /// **'Not turning on'**
  String get problemNotTurningOn;

  /// No description provided for @problemNotDraining.
  ///
  /// In en, this message translates to:
  /// **'Not draining'**
  String get problemNotDraining;

  /// No description provided for @problemNotSpinning.
  ///
  /// In en, this message translates to:
  /// **'Not spinning'**
  String get problemNotSpinning;

  /// No description provided for @problemNoPower.
  ///
  /// In en, this message translates to:
  /// **'No power'**
  String get problemNoPower;

  /// No description provided for @problemWillNotStart.
  ///
  /// In en, this message translates to:
  /// **'Will not start'**
  String get problemWillNotStart;

  /// No description provided for @problemBatteryProblem.
  ///
  /// In en, this message translates to:
  /// **'Battery problem'**
  String get problemBatteryProblem;

  /// No description provided for @problemFlatTyre.
  ///
  /// In en, this message translates to:
  /// **'Flat tyre'**
  String get problemFlatTyre;

  /// No description provided for @problemBreakdownOnTheRoad.
  ///
  /// In en, this message translates to:
  /// **'Breakdown on the road'**
  String get problemBreakdownOnTheRoad;

  /// No description provided for @problemInstallAFan.
  ///
  /// In en, this message translates to:
  /// **'Install a fan'**
  String get problemInstallAFan;

  /// No description provided for @problemFanNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Fan not working'**
  String get problemFanNotWorking;

  /// No description provided for @problemInstallLights.
  ///
  /// In en, this message translates to:
  /// **'Install lights'**
  String get problemInstallLights;

  /// No description provided for @problemLightNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Light not working'**
  String get problemLightNotWorking;

  /// No description provided for @problemLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Locked out'**
  String get problemLockedOut;

  /// No description provided for @problemBrokenLock.
  ///
  /// In en, this message translates to:
  /// **'Broken lock'**
  String get problemBrokenLock;

  /// No description provided for @problemDoorNotClosing.
  ///
  /// In en, this message translates to:
  /// **'Door not closing'**
  String get problemDoorNotClosing;

  /// No description provided for @problemReplaceHandleOrHinge.
  ///
  /// In en, this message translates to:
  /// **'Replace handle or hinge'**
  String get problemReplaceHandleOrHinge;

  /// No description provided for @problemFurnitureAssembly.
  ///
  /// In en, this message translates to:
  /// **'Furniture assembly'**
  String get problemFurnitureAssembly;

  /// No description provided for @problemWallMounting.
  ///
  /// In en, this message translates to:
  /// **'Wall mounting'**
  String get problemWallMounting;

  /// No description provided for @problemSmallRepairs.
  ///
  /// In en, this message translates to:
  /// **'Small repairs'**
  String get problemSmallRepairs;

  /// No description provided for @problemSomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get problemSomethingElse;

  /// No description provided for @symptomBurningSmell.
  ///
  /// In en, this message translates to:
  /// **'Burning smell'**
  String get symptomBurningSmell;

  /// No description provided for @symptomSparksSeen.
  ///
  /// In en, this message translates to:
  /// **'Sparks seen'**
  String get symptomSparksSeen;

  /// No description provided for @symptomOnlyOneRoom.
  ///
  /// In en, this message translates to:
  /// **'Only one room'**
  String get symptomOnlyOneRoom;

  /// No description provided for @symptomHappenedBefore.
  ///
  /// In en, this message translates to:
  /// **'Happened before'**
  String get symptomHappenedBefore;

  /// No description provided for @symptomWaterLeakingNow.
  ///
  /// In en, this message translates to:
  /// **'Water leaking now'**
  String get symptomWaterLeakingNow;

  /// No description provided for @symptomLowPressure.
  ///
  /// In en, this message translates to:
  /// **'Low pressure'**
  String get symptomLowPressure;

  /// No description provided for @symptomBadSmell.
  ///
  /// In en, this message translates to:
  /// **'Bad smell'**
  String get symptomBadSmell;

  /// No description provided for @symptomWaterDripping.
  ///
  /// In en, this message translates to:
  /// **'Water dripping'**
  String get symptomWaterDripping;

  /// No description provided for @symptomWaterOnFloor.
  ///
  /// In en, this message translates to:
  /// **'Water on floor'**
  String get symptomWaterOnFloor;

  /// No description provided for @symptomIceBuildUp.
  ///
  /// In en, this message translates to:
  /// **'Ice build-up'**
  String get symptomIceBuildUp;

  /// No description provided for @symptomNoisy.
  ///
  /// In en, this message translates to:
  /// **'Noisy'**
  String get symptomNoisy;

  /// No description provided for @symptomErrorCodeShown.
  ///
  /// In en, this message translates to:
  /// **'Error code shown'**
  String get symptomErrorCodeShown;

  /// No description provided for @symptomVehicleAtHome.
  ///
  /// In en, this message translates to:
  /// **'Vehicle at home'**
  String get symptomVehicleAtHome;

  /// No description provided for @symptomVehicleOnTheRoad.
  ///
  /// In en, this message translates to:
  /// **'Vehicle on the road'**
  String get symptomVehicleOnTheRoad;

  /// No description provided for @symptomWarningLightOn.
  ///
  /// In en, this message translates to:
  /// **'Warning light on'**
  String get symptomWarningLightOn;

  /// No description provided for @symptomUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get symptomUrgent;

  /// No description provided for @symptomNeedParts.
  ///
  /// In en, this message translates to:
  /// **'Need parts'**
  String get symptomNeedParts;

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'Help in minutes, not days'**
  String get onboard1Title;

  /// No description provided for @onboard1Body.
  ///
  /// In en, this message translates to:
  /// **'Pipe burst or power gone? Press Emergency and the nearest verified technician is on the way.'**
  String get onboard1Body;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Book a time that suits you'**
  String get onboard2Title;

  /// No description provided for @onboard2Body.
  ///
  /// In en, this message translates to:
  /// **'Choose a day and an arrival window for repairs, servicing, or an inspection and quote first.'**
  String get onboard2Body;

  /// No description provided for @onboard3Title.
  ///
  /// In en, this message translates to:
  /// **'Verified. And you stay in control'**
  String get onboard3Title;

  /// No description provided for @onboard3Body.
  ///
  /// In en, this message translates to:
  /// **'Every technician is ID-checked. You approve the cost before any work is charged.'**
  String get onboard3Body;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @welcomeToRepairMe.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RepairMe'**
  String get welcomeToRepairMe;

  /// No description provided for @homeRepairsSimple.
  ///
  /// In en, this message translates to:
  /// **'Home repairs, made simple'**
  String get homeRepairsSimple;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterMobile;

  /// No description provided for @oneTimeCodeNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a one-time code'**
  String get oneTimeCodeNote;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @agreePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our '**
  String get agreePrefix;

  /// No description provided for @termsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsPrivacy;

  /// No description provided for @agreeSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get agreeSuffix;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// No description provided for @sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {phone}'**
  String sentTo(String phone);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resendIn(String time);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @newCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way'**
  String get newCodeSent;

  /// No description provided for @authIncorrectCodeDev.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. In development use {code}.'**
  String authIncorrectCodeDev(String code);

  /// No description provided for @authRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Please request a new code.'**
  String get authRequestNewCode;

  /// No description provided for @authIncorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Please check the SMS and try again.'**
  String get authIncorrectCode;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'That mobile number is not valid.'**
  String get authInvalidPhone;

  /// No description provided for @authTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get authTooMany;

  /// No description provided for @authExpired.
  ///
  /// In en, this message translates to:
  /// **'The code expired. Please request a new one.'**
  String get authExpired;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get authFailed;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @noMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'When a technician accepts your booking, you can chat with them here.'**
  String get noMessagesHint;

  /// No description provided for @sayHelloTo.
  ///
  /// In en, this message translates to:
  /// **'Say hello to {name}'**
  String sayHelloTo(String name);

  /// No description provided for @youPrefix.
  ///
  /// In en, this message translates to:
  /// **'You: {message}'**
  String youPrefix(String message);

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'FIXED. FAST. VERIFIED.'**
  String get splashTagline;

  /// No description provided for @splashProud.
  ///
  /// In en, this message translates to:
  /// **'Proudly Sri Lankan'**
  String get splashProud;

  /// No description provided for @bookingTypeEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get bookingTypeEmergency;

  /// No description provided for @bookingTypeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get bookingTypeSchedule;

  /// No description provided for @bookingTypeInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get bookingTypeInspection;

  /// No description provided for @addressHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addressHome;

  /// No description provided for @addressOffice.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addressOffice;

  /// No description provided for @addressOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addressOther;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request details'**
  String get requestDetails;

  /// No description provided for @howSoon.
  ///
  /// In en, this message translates to:
  /// **'How soon do you need help?'**
  String get howSoon;

  /// No description provided for @typeEmergencyBody.
  ///
  /// In en, this message translates to:
  /// **'The nearest available technician comes as soon as possible.'**
  String get typeEmergencyBody;

  /// No description provided for @typeEmergencyHint.
  ///
  /// In en, this message translates to:
  /// **'Avg. arrival 18 min'**
  String get typeEmergencyHint;

  /// No description provided for @typeScheduledBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a date and a time window that suits you.'**
  String get typeScheduledBody;

  /// No description provided for @typeScheduledHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a slot'**
  String get typeScheduledHint;

  /// No description provided for @typeInspectionBody.
  ///
  /// In en, this message translates to:
  /// **'A visit to inspect, measure and give you a quote first.'**
  String get typeInspectionBody;

  /// No description provided for @typeInspectionHint.
  ///
  /// In en, this message translates to:
  /// **'Quote before work'**
  String get typeInspectionHint;

  /// No description provided for @howPricingWorks.
  ///
  /// In en, this message translates to:
  /// **'How pricing works'**
  String get howPricingWorks;

  /// No description provided for @pricingBody.
  ///
  /// In en, this message translates to:
  /// **'Visit fee {fee} + labour + parts. The technician sends the final cost and you approve it before any work is charged.'**
  String pricingBody(String fee);

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {type}'**
  String continueWith(String type);

  /// No description provided for @stepProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get stepProblem;

  /// No description provided for @whatIsProblem.
  ///
  /// In en, this message translates to:
  /// **'What is the problem?'**
  String get whatIsProblem;

  /// No description provided for @tellUsMore.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get tellUsMore;

  /// No description provided for @detailsHint.
  ///
  /// In en, this message translates to:
  /// **'What happened, when it started, anything the technician should know (at least 10 characters)'**
  String get detailsHint;

  /// No description provided for @stepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get stepPhotos;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @photosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional, but it helps the technician bring the right tools and parts.'**
  String get photosSubtitle;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get fromGallery;

  /// No description provided for @photoTips.
  ///
  /// In en, this message translates to:
  /// **'Tips for good photos'**
  String get photoTips;

  /// No description provided for @photoTipsBody.
  ///
  /// In en, this message translates to:
  /// **'· Show the whole area, then a close-up\n· Include any model or label plate\n· Do not touch exposed wires'**
  String get photoTipsBody;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @photoOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open photos. Please check permissions.'**
  String get photoOpenError;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @whereShouldComeTitle.
  ///
  /// In en, this message translates to:
  /// **'Where should the technician come?'**
  String get whereShouldComeTitle;

  /// No description provided for @yourArea.
  ///
  /// In en, this message translates to:
  /// **'Your area'**
  String get yourArea;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get streetAddress;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @houseNumber.
  ///
  /// In en, this message translates to:
  /// **'House / apartment number'**
  String get houseNumber;

  /// No description provided for @landmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark or directions'**
  String get landmarkLabel;

  /// No description provided for @saveThisAddress.
  ///
  /// In en, this message translates to:
  /// **'Save this address'**
  String get saveThisAddress;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirmLocation;

  /// No description provided for @inspectionVisit.
  ///
  /// In en, this message translates to:
  /// **'Inspection visit'**
  String get inspectionVisit;

  /// No description provided for @scheduleVisit.
  ///
  /// In en, this message translates to:
  /// **'Schedule a visit'**
  String get scheduleVisit;

  /// No description provided for @whenShouldWeCome.
  ///
  /// In en, this message translates to:
  /// **'When should we come?'**
  String get whenShouldWeCome;

  /// No description provided for @arrivalWindow.
  ///
  /// In en, this message translates to:
  /// **'Arrival window'**
  String get arrivalWindow;

  /// No description provided for @visitConfirmNote.
  ///
  /// In en, this message translates to:
  /// **'The technician will confirm the visit the day before. You can reschedule free until 2 hours before.'**
  String get visitConfirmNote;

  /// No description provided for @selectedSlot.
  ///
  /// In en, this message translates to:
  /// **'Selected: {when}'**
  String selectedSlot(String when);

  /// No description provided for @reviewRequest.
  ///
  /// In en, this message translates to:
  /// **'Review request'**
  String get reviewRequest;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// No description provided for @checkYourRequest.
  ///
  /// In en, this message translates to:
  /// **'Check your request'**
  String get checkYourRequest;

  /// No description provided for @photosAttached.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 photo attached} other{{n} photos attached}}'**
  String photosAttached(int n);

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost'**
  String get estimatedCost;

  /// No description provided for @labourAndParts.
  ///
  /// In en, this message translates to:
  /// **'Labour and parts'**
  String get labourAndParts;

  /// No description provided for @quotedOnSite.
  ///
  /// In en, this message translates to:
  /// **'Quoted on site'**
  String get quotedOnSite;

  /// No description provided for @approveFinalCost.
  ///
  /// In en, this message translates to:
  /// **'You will approve the final cost in the app before any work is charged.'**
  String get approveFinalCost;

  /// No description provided for @payWithCash.
  ///
  /// In en, this message translates to:
  /// **'Pay with Cash'**
  String get payWithCash;

  /// No description provided for @afterTheJob.
  ///
  /// In en, this message translates to:
  /// **'After the job'**
  String get afterTheJob;

  /// No description provided for @requestTechnician.
  ///
  /// In en, this message translates to:
  /// **'Request technician'**
  String get requestTechnician;

  /// No description provided for @photosFailed.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 photo could not be uploaded} other{{n} photos could not be uploaded}}'**
  String photosFailed(int n);

  /// No description provided for @theTechnician.
  ///
  /// In en, this message translates to:
  /// **'the technician'**
  String get theTechnician;

  /// No description provided for @yourTechnician.
  ///
  /// In en, this message translates to:
  /// **'your technician'**
  String get yourTechnician;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @bkFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding a technician'**
  String get bkFinding;

  /// No description provided for @bkTeamAssigning.
  ///
  /// In en, this message translates to:
  /// **'Team is assigning'**
  String get bkTeamAssigning;

  /// No description provided for @bkAssigned.
  ///
  /// In en, this message translates to:
  /// **'Technician assigned'**
  String get bkAssigned;

  /// No description provided for @bkCancelledRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancelled request'**
  String get bkCancelledRequest;

  /// No description provided for @bkJobStatus.
  ///
  /// In en, this message translates to:
  /// **'Job status'**
  String get bkJobStatus;

  /// No description provided for @stepRequestReceived.
  ///
  /// In en, this message translates to:
  /// **'Request received'**
  String get stepRequestReceived;

  /// No description provided for @stepNoTechAccepted.
  ///
  /// In en, this message translates to:
  /// **'No technician accepted'**
  String get stepNoTechAccepted;

  /// No description provided for @stepTeamAssigning.
  ///
  /// In en, this message translates to:
  /// **'RepairMe team assigning'**
  String get stepTeamAssigning;

  /// No description provided for @stepTechConfirms.
  ///
  /// In en, this message translates to:
  /// **'Technician confirms'**
  String get stepTechConfirms;

  /// No description provided for @stepMatchingNearby.
  ///
  /// In en, this message translates to:
  /// **'Matching technicians nearby'**
  String get stepMatchingNearby;

  /// No description provided for @requestRef.
  ///
  /// In en, this message translates to:
  /// **'Request #{ref}'**
  String requestRef(String ref);

  /// No description provided for @operatorFindingTitle.
  ///
  /// In en, this message translates to:
  /// **'Our team is finding someone for you'**
  String get operatorFindingTitle;

  /// No description provided for @findingVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Finding a verified {category} technician'**
  String findingVerifiedTitle(String category);

  /// No description provided for @operatorFindingBody.
  ///
  /// In en, this message translates to:
  /// **'No technician accepted yet, so a RepairMe operator is assigning one for you. Usually under 2 minutes.'**
  String get operatorFindingBody;

  /// No description provided for @matchingNear.
  ///
  /// In en, this message translates to:
  /// **'Matching you with technicians near {area}.'**
  String matchingNear(String area);

  /// No description provided for @confirmingFor.
  ///
  /// In en, this message translates to:
  /// **'We are confirming a technician for {when}.'**
  String confirmingFor(String when);

  /// No description provided for @ifNobodyAccepts.
  ///
  /// In en, this message translates to:
  /// **'If nobody accepts, the RepairMe team assigns a technician for you.'**
  String get ifNobodyAccepts;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelRequest;

  /// No description provided for @cancelThisRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel this request?'**
  String get cancelThisRequest;

  /// No description provided for @noChargeNoTech.
  ///
  /// In en, this message translates to:
  /// **'No charge, since no technician has been assigned yet.'**
  String get noChargeNoTech;

  /// No description provided for @noChargeNotArrived.
  ///
  /// In en, this message translates to:
  /// **'No charge, since {name} has not arrived yet.'**
  String noChargeNotArrived(String name);

  /// No description provided for @reasonFoundSomeone.
  ///
  /// In en, this message translates to:
  /// **'Found someone else'**
  String get reasonFoundSomeone;

  /// No description provided for @reasonProblemFixed.
  ///
  /// In en, this message translates to:
  /// **'Problem is fixed'**
  String get reasonProblemFixed;

  /// No description provided for @reasonWaitingTooLong.
  ///
  /// In en, this message translates to:
  /// **'Waiting too long'**
  String get reasonWaitingTooLong;

  /// No description provided for @tellUsMoreOptional.
  ///
  /// In en, this message translates to:
  /// **'Tell us more (optional)'**
  String get tellUsMoreOptional;

  /// No description provided for @keepWaiting.
  ///
  /// In en, this message translates to:
  /// **'Keep waiting'**
  String get keepWaiting;

  /// No description provided for @etaMin.
  ///
  /// In en, this message translates to:
  /// **'ETA {n} MIN'**
  String etaMin(String n);

  /// No description provided for @techOnTheWayTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is on the way'**
  String techOnTheWayTitle(String name);

  /// No description provided for @techWillVisit.
  ///
  /// In en, this message translates to:
  /// **'{name} will visit {when}'**
  String techWillVisit(String name, String when);

  /// No description provided for @techAccepted.
  ///
  /// In en, this message translates to:
  /// **'{name} accepted your request'**
  String techAccepted(String name);

  /// No description provided for @arrivesInAbout.
  ///
  /// In en, this message translates to:
  /// **'Arrives in about {n} min'**
  String arrivesInAbout(String n);

  /// No description provided for @viewJobStatus.
  ///
  /// In en, this message translates to:
  /// **'View job status'**
  String get viewJobStatus;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @verifiedCategoryTech.
  ///
  /// In en, this message translates to:
  /// **'Verified {category} technician'**
  String verifiedCategoryTech(String category);

  /// No description provided for @newTech.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newTech;

  /// No description provided for @ratingAndJobs.
  ///
  /// In en, this message translates to:
  /// **'{rating} · {n, plural, =1{1 job} other{{n} jobs}}'**
  String ratingAndJobs(String rating, int n);

  /// No description provided for @jobCodeShare.
  ///
  /// In en, this message translates to:
  /// **'Job code · share only when {name} arrives'**
  String jobCodeShare(String name);

  /// No description provided for @messageTech.
  ///
  /// In en, this message translates to:
  /// **'Message {name}'**
  String messageTech(String name);

  /// No description provided for @jobNumber.
  ///
  /// In en, this message translates to:
  /// **'Job #{ref}'**
  String jobNumber(String ref);

  /// No description provided for @costReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cost ready for your approval'**
  String get costReadyTitle;

  /// No description provided for @costReadyBody.
  ///
  /// In en, this message translates to:
  /// **'{name} sent {amount} · Tap to review'**
  String costReadyBody(String name, String amount);

  /// No description provided for @repairCompleted.
  ///
  /// In en, this message translates to:
  /// **'Repair completed'**
  String get repairCompleted;

  /// No description provided for @payTo.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} to {name}'**
  String payTo(String amount, String name);

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get paymentReceived;

  /// No description provided for @viewReceiptRate.
  ///
  /// In en, this message translates to:
  /// **'View receipt and rate {name}'**
  String viewReceiptRate(String name);

  /// No description provided for @viewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get viewReceipt;

  /// No description provided for @bookingWasCancelled.
  ///
  /// In en, this message translates to:
  /// **'This booking was cancelled'**
  String get bookingWasCancelled;

  /// No description provided for @cancelledByYouNoCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by you · no charge'**
  String get cancelledByYouNoCharge;

  /// No description provided for @cancelledByRepairMe.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by RepairMe'**
  String get cancelledByRepairMe;

  /// No description provided for @tlRequestCreated.
  ///
  /// In en, this message translates to:
  /// **'Request created'**
  String get tlRequestCreated;

  /// No description provided for @tlAccepted.
  ///
  /// In en, this message translates to:
  /// **'Technician accepted'**
  String get tlAccepted;

  /// No description provided for @tlOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get tlOnTheWay;

  /// No description provided for @tlArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get tlArrived;

  /// No description provided for @tlJobCodeVerified.
  ///
  /// In en, this message translates to:
  /// **'Job code verified · {time}'**
  String tlJobCodeVerified(String time);

  /// No description provided for @tlWorking.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get tlWorking;

  /// No description provided for @tlCostApproved.
  ///
  /// In en, this message translates to:
  /// **'Cost approved, work under way'**
  String get tlCostApproved;

  /// No description provided for @tlInspectionDone.
  ///
  /// In en, this message translates to:
  /// **'Inspection done, cost sent'**
  String get tlInspectionDone;

  /// No description provided for @tlCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tlCompleted;

  /// No description provided for @tlPayAndRate.
  ///
  /// In en, this message translates to:
  /// **'Pay and rate'**
  String get tlPayAndRate;

  /// No description provided for @yourPhotos.
  ///
  /// In en, this message translates to:
  /// **'Your photos'**
  String get yourPhotos;

  /// No description provided for @beforePhotosBy.
  ///
  /// In en, this message translates to:
  /// **'Before photos by {name}'**
  String beforePhotosBy(String name);

  /// No description provided for @afterPhotos.
  ///
  /// In en, this message translates to:
  /// **'After photos'**
  String get afterPhotos;

  /// No description provided for @requestHeading.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestHeading;

  /// No description provided for @reportProblemWithJob.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with this job'**
  String get reportProblemWithJob;

  /// No description provided for @problemWithRef.
  ///
  /// In en, this message translates to:
  /// **'Problem with {ref}'**
  String problemWithRef(String ref);

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @onTheWayEta.
  ///
  /// In en, this message translates to:
  /// **'On the way · ETA {n} min'**
  String onTheWayEta(String n);

  /// No description provided for @chatSafety.
  ///
  /// In en, this message translates to:
  /// **'Messages are recorded for your safety. Never share your job code until {name} arrives.'**
  String chatSafety(String name);

  /// No description provided for @timeSeen.
  ///
  /// In en, this message translates to:
  /// **'{time} · Seen'**
  String timeSeen(String time);

  /// No description provided for @quickAtHome.
  ///
  /// In en, this message translates to:
  /// **'I am at home'**
  String get quickAtHome;

  /// No description provided for @quickCallMe.
  ///
  /// In en, this message translates to:
  /// **'Call me'**
  String get quickCallMe;

  /// No description provided for @quickSideGate.
  ///
  /// In en, this message translates to:
  /// **'Use the side gate'**
  String get quickSideGate;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @chatClosed.
  ///
  /// In en, this message translates to:
  /// **'Chat is closed for this booking.'**
  String get chatClosed;

  /// No description provided for @declineCostQ.
  ///
  /// In en, this message translates to:
  /// **'Decline this cost?'**
  String get declineCostQ;

  /// No description provided for @declineCostBody.
  ///
  /// In en, this message translates to:
  /// **'The technician will be told. Only the visit fee applies if no work is done.'**
  String get declineCostBody;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @costApprovedToast.
  ///
  /// In en, this message translates to:
  /// **'Cost approved. Work continues.'**
  String get costApprovedToast;

  /// No description provided for @costDeclinedToast.
  ///
  /// In en, this message translates to:
  /// **'Cost declined'**
  String get costDeclinedToast;

  /// No description provided for @approveCostTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve cost'**
  String get approveCostTitle;

  /// No description provided for @nothingToApprove.
  ///
  /// In en, this message translates to:
  /// **'Nothing to approve right now'**
  String get nothingToApprove;

  /// No description provided for @totalToApprove.
  ///
  /// In en, this message translates to:
  /// **'Total to approve'**
  String get totalToApprove;

  /// No description provided for @noteFrom.
  ///
  /// In en, this message translates to:
  /// **'Note from {name}'**
  String noteFrom(String name);

  /// No description provided for @workStartsAfterApprove.
  ///
  /// In en, this message translates to:
  /// **'Work starts only after you approve. If the cost changes, you will be asked again.'**
  String get workStartsAfterApprove;

  /// No description provided for @approveAmount.
  ///
  /// In en, this message translates to:
  /// **'Approve {amount}'**
  String approveAmount(String amount);

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askQuestion;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @repairCompletedBy.
  ///
  /// In en, this message translates to:
  /// **'Repair completed by {name}'**
  String repairCompletedBy(String name);

  /// No description provided for @repairCompletedByAt.
  ///
  /// In en, this message translates to:
  /// **'Repair completed by {name} · {time}'**
  String repairCompletedByAt(String name, String time);

  /// No description provided for @paymentMethodHeading.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodHeading;

  /// No description provided for @payTechDirectly.
  ///
  /// In en, this message translates to:
  /// **'Pay {name} directly'**
  String payTechDirectly(String name);

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @mobileWallet.
  ///
  /// In en, this message translates to:
  /// **'Mobile wallet'**
  String get mobileWallet;

  /// No description provided for @handCashTo.
  ///
  /// In en, this message translates to:
  /// **'Hand {amount} to {name}. Your receipt appears as soon as they confirm.'**
  String handCashTo(String amount, String name);

  /// No description provided for @confirmPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment · {amount}'**
  String confirmPaymentAmount(String amount);

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @paidInCash.
  ///
  /// In en, this message translates to:
  /// **'{amount} paid in cash'**
  String paidInCash(String amount);

  /// No description provided for @paidIn.
  ///
  /// In en, this message translates to:
  /// **'{amount} paid in {method}'**
  String paidIn(String amount, String method);

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #{ref}'**
  String receiptNumber(String ref);

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @warrantyTitle.
  ///
  /// In en, this message translates to:
  /// **'7-day workmanship cover'**
  String get warrantyTitle;

  /// No description provided for @warrantyBody.
  ///
  /// In en, this message translates to:
  /// **'If the same fault returns, we send someone back at no labour cost.'**
  String get warrantyBody;

  /// No description provided for @youRated.
  ///
  /// In en, this message translates to:
  /// **'You rated {name} {rating}★ · Done'**
  String youRated(String name, String rating);

  /// No description provided for @rateName.
  ///
  /// In en, this message translates to:
  /// **'Rate {name}'**
  String rateName(String name);

  /// No description provided for @rateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateExperience;

  /// No description provided for @tagOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get tagOnTime;

  /// No description provided for @tagProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get tagProfessional;

  /// No description provided for @tagCleanWork.
  ///
  /// In en, this message translates to:
  /// **'Clean work'**
  String get tagCleanWork;

  /// No description provided for @tagFairPrice.
  ///
  /// In en, this message translates to:
  /// **'Fair price'**
  String get tagFairPrice;

  /// No description provided for @tagExplainedClearly.
  ///
  /// In en, this message translates to:
  /// **'Explained clearly'**
  String get tagExplainedClearly;

  /// No description provided for @ratePoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get ratePoor;

  /// No description provided for @rateCouldBeBetter.
  ///
  /// In en, this message translates to:
  /// **'Could be better'**
  String get rateCouldBeBetter;

  /// No description provided for @rateGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get rateGood;

  /// No description provided for @rateGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get rateGreat;

  /// No description provided for @rateExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get rateExcellent;

  /// No description provided for @howWasName.
  ///
  /// In en, this message translates to:
  /// **'How was {name}?'**
  String howWasName(String name);

  /// No description provided for @whatWentWell.
  ///
  /// In en, this message translates to:
  /// **'What went well?'**
  String get whatWentWell;

  /// No description provided for @addCommentOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a comment (optional)'**
  String get addCommentOptional;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Tell others about the job'**
  String get commentHint;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get submitRating;

  /// No description provided for @thankYouRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouRating;

  /// No description provided for @enterMobileToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to continue'**
  String get enterMobileToContinue;

  /// No description provided for @legalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to RepairMe\'s '**
  String get legalPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @legalMiddle.
  ///
  /// In en, this message translates to:
  /// **' and acknowledge the '**
  String get legalMiddle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLink;

  /// No description provided for @legalSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get legalSuffix;

  /// No description provided for @verifyYourNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Number'**
  String get verifyYourNumber;

  /// No description provided for @sentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to'**
  String get sentCodeTo;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @didntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceive;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @completeProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about yourself to finish creating your account.'**
  String get completeProfileSub;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (optional)'**
  String get emailOptional;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @verifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedBadge;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Sri Lankan mobile number'**
  String get phoneInvalid;

  /// No description provided for @createAccountError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t create your account. Please try again.'**
  String get createAccountError;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t update your profile. Please try again.'**
  String get profileUpdateError;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach RepairMe'**
  String get offlineTitle;

  /// No description provided for @offlineBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get offlineBody;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach RepairMe. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @signInAgain.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again.'**
  String get signInAgain;

  /// No description provided for @authPhoneInUse.
  ///
  /// In en, this message translates to:
  /// **'This mobile number is already associated with another account.'**
  String get authPhoneInUse;

  /// No description provided for @viewEditProfile.
  ///
  /// In en, this message translates to:
  /// **'View / Edit Profile'**
  String get viewEditProfile;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get sectionAccount;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get sectionSupport;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get sectionAbout;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @aboutRepairMe.
  ///
  /// In en, this message translates to:
  /// **'About RepairMe'**
  String get aboutRepairMe;

  /// No description provided for @legalAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Legal & Privacy'**
  String get legalAndPrivacy;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @madeInSriLanka.
  ///
  /// In en, this message translates to:
  /// **'Made in Sri Lanka'**
  String get madeInSriLanka;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @linkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This link isn\'t available yet'**
  String get linkNotAvailable;

  /// No description provided for @logOutQ.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQ;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of RepairMe?'**
  String get logOutConfirm;

  /// No description provided for @logOutAction.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutAction;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @birthdayHint.
  ///
  /// In en, this message translates to:
  /// **'DD / MM / YYYY'**
  String get birthdayHint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderPrefer.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPrefer;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyContactHint.
  ///
  /// In en, this message translates to:
  /// **'Someone we can reach in an emergency. Used only for that purpose.'**
  String get emergencyContactHint;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @relationshipFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get relationshipFamily;

  /// No description provided for @relationshipFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get relationshipFriend;

  /// No description provided for @relationshipNeighbour.
  ///
  /// In en, this message translates to:
  /// **'Neighbour'**
  String get relationshipNeighbour;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get addEmergencyContact;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeContactQ.
  ///
  /// In en, this message translates to:
  /// **'Remove emergency contact?'**
  String get removeContactQ;

  /// No description provided for @removeContactBody.
  ///
  /// In en, this message translates to:
  /// **'This contact will be deleted from your account.'**
  String get removeContactBody;

  /// No description provided for @contactSaved.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact saved'**
  String get contactSaved;

  /// No description provided for @additionalSettings.
  ///
  /// In en, this message translates to:
  /// **'Additional Settings'**
  String get additionalSettings;

  /// No description provided for @changeMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Mobile Number'**
  String get changeMobileNumber;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @enterNewNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your new mobile number'**
  String get enterNewNumber;

  /// No description provided for @changeNumberNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a code to the new number to verify it. Your account and bookings stay the same.'**
  String get changeNumberNote;

  /// No description provided for @sameNumber.
  ///
  /// In en, this message translates to:
  /// **'That is already your number'**
  String get sameNumber;

  /// No description provided for @numberChanged.
  ///
  /// In en, this message translates to:
  /// **'Mobile number updated'**
  String get numberChanged;

  /// No description provided for @verifyNewNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify New Number'**
  String get verifyNewNumber;

  /// No description provided for @notifBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking Updates'**
  String get notifBooking;

  /// No description provided for @notifBookingSub.
  ///
  /// In en, this message translates to:
  /// **'Technician acceptance, arrival and booking-status updates.'**
  String get notifBookingSub;

  /// No description provided for @notifReminders.
  ///
  /// In en, this message translates to:
  /// **'Service Reminders'**
  String get notifReminders;

  /// No description provided for @notifRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Upcoming scheduled services.'**
  String get notifRemindersSub;

  /// No description provided for @notifPayments.
  ///
  /// In en, this message translates to:
  /// **'Payment Updates'**
  String get notifPayments;

  /// No description provided for @notifPaymentsSub.
  ///
  /// In en, this message translates to:
  /// **'Receipts, payment status and refunds.'**
  String get notifPaymentsSub;

  /// No description provided for @notifOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers & Promotions'**
  String get notifOffers;

  /// No description provided for @notifOffersSub.
  ///
  /// In en, this message translates to:
  /// **'Marketing messages and promotions.'**
  String get notifOffersSub;

  /// No description provided for @notifUpdates.
  ///
  /// In en, this message translates to:
  /// **'RepairMe Updates'**
  String get notifUpdates;

  /// No description provided for @notifUpdatesSub.
  ///
  /// In en, this message translates to:
  /// **'Important product and service updates.'**
  String get notifUpdatesSub;

  /// No description provided for @notifEssentialNote.
  ///
  /// In en, this message translates to:
  /// **'Essential account, security and booking-safety messages are always sent.'**
  String get notifEssentialNote;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Your RepairMe Account?'**
  String get deleteTitle;

  /// No description provided for @deleteIntro.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go. Deleting your account may permanently remove your RepairMe profile and associated personal information, subject to information we are required or permitted to retain.'**
  String get deleteIntro;

  /// No description provided for @whyLeaving.
  ///
  /// In en, this message translates to:
  /// **'Why are you leaving?'**
  String get whyLeaving;

  /// No description provided for @delReasonNoNeed.
  ///
  /// In en, this message translates to:
  /// **'I no longer need RepairMe'**
  String get delReasonNoNeed;

  /// No description provided for @delReasonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I have privacy concerns'**
  String get delReasonPrivacy;

  /// No description provided for @delReasonBadExperience.
  ///
  /// In en, this message translates to:
  /// **'I had a bad experience'**
  String get delReasonBadExperience;

  /// No description provided for @delReasonAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'I created another account'**
  String get delReasonAnotherAccount;

  /// No description provided for @delReasonNotifications.
  ///
  /// In en, this message translates to:
  /// **'I receive too many notifications'**
  String get delReasonNotifications;

  /// No description provided for @delReasonServices.
  ///
  /// In en, this message translates to:
  /// **'I couldn\'t find the services I needed'**
  String get delReasonServices;

  /// No description provided for @tellUsMoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get tellUsMoreLabel;

  /// No description provided for @continueToDelete.
  ///
  /// In en, this message translates to:
  /// **'Continue to Delete'**
  String get continueToDelete;

  /// No description provided for @permanentWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'This action may be permanent'**
  String get permanentWarningTitle;

  /// No description provided for @deleteWillRemove.
  ///
  /// In en, this message translates to:
  /// **'These may be removed or anonymised:'**
  String get deleteWillRemove;

  /// No description provided for @delRemoveProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile and contact details'**
  String get delRemoveProfile;

  /// No description provided for @delRemoveAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses and emergency contact'**
  String get delRemoveAddresses;

  /// No description provided for @delRemovePrefs.
  ///
  /// In en, this message translates to:
  /// **'Preferences and notifications'**
  String get delRemovePrefs;

  /// No description provided for @delKeepNote.
  ///
  /// In en, this message translates to:
  /// **'Some records, such as payments and support history, may be kept where required for accounting, security or legal reasons.'**
  String get delKeepNote;

  /// No description provided for @delConfirmCheck.
  ///
  /// In en, this message translates to:
  /// **'I understand and want to delete my account'**
  String get delConfirmCheck;

  /// No description provided for @verifyAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Verify & Delete Account'**
  String get verifyAndDelete;

  /// No description provided for @deleteOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm with a code'**
  String get deleteOtpTitle;

  /// No description provided for @deleteOtpBody.
  ///
  /// In en, this message translates to:
  /// **'For your security, enter the code we sent to {phone}.'**
  String deleteOtpBody(String phone);

  /// No description provided for @deleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccountAction;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t delete your account. Please try again.'**
  String get deleteError;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get accountDeleted;

  /// No description provided for @membershipTitle.
  ///
  /// In en, this message translates to:
  /// **'RepairMe Membership'**
  String get membershipTitle;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @standardMember.
  ///
  /// In en, this message translates to:
  /// **'Standard Member'**
  String get standardMember;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @yourBenefits.
  ///
  /// In en, this message translates to:
  /// **'Your benefits'**
  String get yourBenefits;

  /// No description provided for @benefit1.
  ///
  /// In en, this message translates to:
  /// **'Access to verified technicians'**
  String get benefit1;

  /// No description provided for @benefit2.
  ///
  /// In en, this message translates to:
  /// **'Emergency service requests'**
  String get benefit2;

  /// No description provided for @benefit3.
  ///
  /// In en, this message translates to:
  /// **'Scheduled bookings'**
  String get benefit3;

  /// No description provided for @benefit4.
  ///
  /// In en, this message translates to:
  /// **'Measurement requests'**
  String get benefit4;

  /// No description provided for @benefit5.
  ///
  /// In en, this message translates to:
  /// **'Booking history'**
  String get benefit5;

  /// No description provided for @benefit6.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get benefit6;

  /// No description provided for @membershipSoon.
  ///
  /// In en, this message translates to:
  /// **'More membership benefits are coming soon.'**
  String get membershipSoon;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'+ Add New Address'**
  String get addNewAddress;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultBadge;

  /// No description provided for @deleteAddressQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get deleteAddressQ;

  /// No description provided for @deleteAddressBody.
  ///
  /// In en, this message translates to:
  /// **'Your past bookings are not affected.'**
  String get deleteAddressBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noSavedAddressesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses yet'**
  String get noSavedAddressesYet;

  /// No description provided for @saveAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Save your home or work address to make future bookings faster.'**
  String get saveAddressHint;

  /// No description provided for @addressLabelField.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get addressLabelField;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Contact name (optional)'**
  String get recipientName;

  /// No description provided for @contactPhoneField.
  ///
  /// In en, this message translates to:
  /// **'Contact mobile number (optional)'**
  String get contactPhoneField;

  /// No description provided for @districtField.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtField;

  /// No description provided for @instructionsField.
  ///
  /// In en, this message translates to:
  /// **'Additional instructions (optional)'**
  String get instructionsField;

  /// No description provided for @addressSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save this address. Please try again.'**
  String get addressSaveError;

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved'**
  String get addressSaved;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @cashDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay your technician directly after the job.'**
  String get cashDesc;

  /// No description provided for @cardOnline.
  ///
  /// In en, this message translates to:
  /// **'Card / Online Payment'**
  String get cardOnline;

  /// No description provided for @cardOnlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Coming soon. Payments will be handled securely by a payment provider.'**
  String get cardOnlineDesc;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'+ Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @paymentSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Online payments are coming soon'**
  String get paymentSoonTitle;

  /// No description provided for @paymentSoonBody.
  ///
  /// In en, this message translates to:
  /// **'For now you can pay with cash after the job. We will let you know when cards and other online payments are available.'**
  String get paymentSoonBody;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okLabel;

  /// No description provided for @helpCenterFaqs.
  ///
  /// In en, this message translates to:
  /// **'Help Center / FAQs'**
  String get helpCenterFaqs;

  /// No description provided for @mySupportRequests.
  ///
  /// In en, this message translates to:
  /// **'My Support Requests'**
  String get mySupportRequests;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @paymentIssue.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get paymentIssue;

  /// No description provided for @bookingIssue.
  ///
  /// In en, this message translates to:
  /// **'Booking Issue'**
  String get bookingIssue;

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get emergencyHelp;

  /// No description provided for @emergencyHelpBody.
  ///
  /// In en, this message translates to:
  /// **'In an emergency, request a technician right away.'**
  String get emergencyHelpBody;

  /// No description provided for @requestEmergencyTechnician.
  ///
  /// In en, this message translates to:
  /// **'Request emergency technician'**
  String get requestEmergencyTechnician;

  /// No description provided for @issueHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened and, if it is about a booking or payment, the booking number.'**
  String get issueHint;

  /// No description provided for @noSupportRequests.
  ///
  /// In en, this message translates to:
  /// **'No support requests yet'**
  String get noSupportRequests;

  /// No description provided for @noSupportHint.
  ///
  /// In en, this message translates to:
  /// **'When you contact support, your requests will appear here.'**
  String get noSupportHint;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat With Us'**
  String get chatWithUs;

  /// No description provided for @supportNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Support contact details will be available soon. You can still write to us from My Support Requests.'**
  String get supportNotConfigured;

  /// No description provided for @couldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open that'**
  String get couldNotOpen;

  /// No description provided for @faqSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search help'**
  String get faqSearchHint;

  /// No description provided for @faqNoResults.
  ///
  /// In en, this message translates to:
  /// **'No answers found'**
  String get faqNoResults;

  /// No description provided for @faqCatAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get faqCatAccount;

  /// No description provided for @faqCatBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get faqCatBooking;

  /// No description provided for @faqCatPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get faqCatPayments;

  /// No description provided for @faqCatTechnicians.
  ///
  /// In en, this message translates to:
  /// **'Technicians'**
  String get faqCatTechnicians;

  /// No description provided for @faqPhoneQ.
  ///
  /// In en, this message translates to:
  /// **'How do I change my mobile number?'**
  String get faqPhoneQ;

  /// No description provided for @faqPhoneA.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Personal Information → Change Mobile Number. We send a code to the new number to verify it.'**
  String get faqPhoneA;

  /// No description provided for @faqProfileQ.
  ///
  /// In en, this message translates to:
  /// **'How do I update my profile?'**
  String get faqProfileQ;

  /// No description provided for @faqProfileA.
  ///
  /// In en, this message translates to:
  /// **'Open Profile and tap your name at the top, then change your details and tap Save Changes.'**
  String get faqProfileA;

  /// No description provided for @faqDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get faqDeleteQ;

  /// No description provided for @faqDeleteA.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Personal Information → Delete Account and follow the steps. You will confirm with a code sent to your mobile number.'**
  String get faqDeleteA;

  /// No description provided for @faqBookQ.
  ///
  /// In en, this message translates to:
  /// **'How do I book a technician?'**
  String get faqBookQ;

  /// No description provided for @faqBookA.
  ///
  /// In en, this message translates to:
  /// **'Choose a service on the Home screen, describe the problem, pick a location and confirm. We match you with a verified technician.'**
  String get faqBookA;

  /// No description provided for @faqEmergencyQ.
  ///
  /// In en, this message translates to:
  /// **'How do emergency bookings work?'**
  String get faqEmergencyQ;

  /// No description provided for @faqEmergencyA.
  ///
  /// In en, this message translates to:
  /// **'Emergency requests go to the nearest available technician right away. Pick Emergency when you book.'**
  String get faqEmergencyA;

  /// No description provided for @faqScheduledQ.
  ///
  /// In en, this message translates to:
  /// **'How do scheduled bookings work?'**
  String get faqScheduledQ;

  /// No description provided for @faqScheduledA.
  ///
  /// In en, this message translates to:
  /// **'Choose a day and an arrival window. The technician confirms the visit the day before, and you can reschedule free until 2 hours before.'**
  String get faqScheduledA;

  /// No description provided for @faqMeasureQ.
  ///
  /// In en, this message translates to:
  /// **'What is a measurement request?'**
  String get faqMeasureQ;

  /// No description provided for @faqMeasureA.
  ///
  /// In en, this message translates to:
  /// **'A visit where the technician inspects, measures and gives you a quote before any work starts.'**
  String get faqMeasureA;

  /// No description provided for @faqMethodsQ.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are supported?'**
  String get faqMethodsQ;

  /// No description provided for @faqMethodsA.
  ///
  /// In en, this message translates to:
  /// **'You can pay with cash after the job. Card and online payments are coming soon.'**
  String get faqMethodsA;

  /// No description provided for @faqRefundQ.
  ///
  /// In en, this message translates to:
  /// **'How do refunds work?'**
  String get faqRefundQ;

  /// No description provided for @faqRefundA.
  ///
  /// In en, this message translates to:
  /// **'If you were charged by mistake, open Help & Support → Payment Issue and tell us the booking. We review every request.'**
  String get faqRefundA;

  /// No description provided for @faqReceiptQ.
  ///
  /// In en, this message translates to:
  /// **'Where can I find my receipt?'**
  String get faqReceiptQ;

  /// No description provided for @faqReceiptA.
  ///
  /// In en, this message translates to:
  /// **'Open Bookings → Completed, choose the job and tap View receipt.'**
  String get faqReceiptA;

  /// No description provided for @faqRateQ.
  ///
  /// In en, this message translates to:
  /// **'How can I rate a technician?'**
  String get faqRateQ;

  /// No description provided for @faqRateA.
  ///
  /// In en, this message translates to:
  /// **'After a job is paid, open the receipt and tap Rate. Your feedback helps other customers.'**
  String get faqRateA;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Help When You Need It.'**
  String get aboutTagline;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'RepairMe is an on-demand repair service platform designed to connect customers with trusted and verified technicians for convenient repair and maintenance services.'**
  String get aboutDescription;

  /// No description provided for @aboutSvc1.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get aboutSvc1;

  /// No description provided for @aboutSvc2.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get aboutSvc2;

  /// No description provided for @aboutSvc3.
  ///
  /// In en, this message translates to:
  /// **'AC & Refrigeration'**
  String get aboutSvc3;

  /// No description provided for @aboutSvc4.
  ///
  /// In en, this message translates to:
  /// **'Appliance Repair'**
  String get aboutSvc4;

  /// No description provided for @aboutSvc5.
  ///
  /// In en, this message translates to:
  /// **'Mechanical Services'**
  String get aboutSvc5;

  /// No description provided for @aboutSvc6.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle / Roadside Repair'**
  String get aboutSvc6;

  /// No description provided for @aboutSvc7.
  ///
  /// In en, this message translates to:
  /// **'Home Maintenance'**
  String get aboutSvc7;

  /// No description provided for @aboutSvc8.
  ///
  /// In en, this message translates to:
  /// **'Other supported repair services'**
  String get aboutSvc8;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @officialEmail.
  ///
  /// In en, this message translates to:
  /// **'Official Email'**
  String get officialEmail;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @contactSoon.
  ///
  /// In en, this message translates to:
  /// **'Contact details will be added soon.'**
  String get contactSoon;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get cancellationPolicy;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refundPolicy;

  /// No description provided for @paymentPolicy.
  ///
  /// In en, this message translates to:
  /// **'Payment Policy'**
  String get paymentPolicy;

  /// No description provided for @dataDeletionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Account & Data Deletion'**
  String get dataDeletionPolicy;

  /// No description provided for @lastUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String lastUpdatedOn(String date);

  /// No description provided for @legalDraftNote.
  ///
  /// In en, this message translates to:
  /// **'Sample text for the prototype. Final policies must be reviewed before launch.'**
  String get legalDraftNote;

  /// No description provided for @legalEnglishNote.
  ///
  /// In en, this message translates to:
  /// **'Legal documents are currently available in English only.'**
  String get legalEnglishNote;

  /// No description provided for @deleteActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'Finish or cancel your active bookings before deleting your account.'**
  String get deleteActiveBookings;

  /// No description provided for @acceptTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you continue'**
  String get acceptTermsTitle;

  /// No description provided for @acceptTermsBody.
  ///
  /// In en, this message translates to:
  /// **'To use RepairMe, please read and accept our Terms & Conditions and Privacy Policy.'**
  String get acceptTermsBody;

  /// No description provided for @acceptPrefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the '**
  String get acceptPrefix;

  /// No description provided for @acceptMiddle.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get acceptMiddle;

  /// No description provided for @acceptSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get acceptSuffix;

  /// No description provided for @acceptContinue.
  ///
  /// In en, this message translates to:
  /// **'Accept & Continue'**
  String get acceptContinue;

  /// No description provided for @acceptError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your acceptance. Please try again.'**
  String get acceptError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
