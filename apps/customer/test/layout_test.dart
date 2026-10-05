// Renders every screen in English, Sinhala and Tamil at a small phone size with
// the real fonts, and fails on any overflow or other layout error.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:repairme_customer/core/api_client.dart';
import 'package:repairme_customer/core/app_language.dart';
import 'package:repairme_customer/core/appearance.dart';
import 'package:repairme_customer/core/session.dart';
import 'package:repairme_customer/data/booking_draft.dart';
import 'package:repairme_customer/data/models.dart';
import 'package:repairme_customer/data/repository.dart';
import 'package:repairme_customer/l10n/cupertino_fallback.dart';
import 'package:repairme_customer/l10n/l10n.dart';
import 'package:repairme_customer/screens/account_screens.dart';
import 'package:repairme_customer/screens/address_screens.dart';
import 'package:repairme_customer/screens/auth_screens.dart';
import 'package:repairme_customer/screens/booking_screens.dart';
import 'package:repairme_customer/screens/home_screen.dart';
import 'package:repairme_customer/screens/legal_screens.dart';
import 'package:repairme_customer/screens/messages_screen.dart';
import 'package:repairme_customer/screens/profile_screens.dart';
import 'package:repairme_customer/screens/profile_setup_screen.dart';
import 'package:repairme_customer/screens/request_screens.dart';
import 'package:repairme_customer/screens/support_screens.dart';
import 'package:repairme_customer/screens/tab_screens.dart';
import 'package:repairme_customer/theme/app_theme.dart';
import 'package:repairme_customer/widgets/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _now = '2026-10-05T10:00:00.000Z';

Map<String, dynamic> _tech() => {
      'id': 't1',
      'displayName': 'Kasun Perera',
      'rating': '4.8',
      'ratingCount': 212,
      'jobsCompleted': 212,
    };

Map<String, dynamic> _booking(String status, {String type = 'EMERGENCY'}) {
  final hasTech = !{'SEARCHING', 'OPERATOR_ASSIGNING'}.contains(status);
  final pending = status == 'AWAITING_APPROVAL';
  final paid = status == 'PAID';
  return {
    'id': 'b-$status',
    'reference': 'RM-1042',
    'type': type,
    'status': status,
    'title': 'Not cooling',
    'category': {'name': 'AC', 'iconKey': 'ac'},
    'technician': hasTech ? _tech() : null,
    'addressArea': 'Nugegoda',
    'scheduledStart': type == 'SCHEDULED' ? '2026-10-07T08:00:00.000Z' : null,
    'scheduledEnd': type == 'SCHEDULED' ? '2026-10-07T10:00:00.000Z' : null,
    'totalCents': paid ? 325000 : null,
    'cancelledBy': status == 'CANCELLED' ? 'CUSTOMER' : null,
    'createdAt': _now,
    'description': 'The AC is running but the room is not getting cold at all.',
    'symptoms': ['Water dripping', 'Bad smell'],
    'address': {'line1': 'Stanley Thilakaratne Mawatha', 'area': 'Nugegoda', 'city': 'Colombo', 'houseNumber': '12/A', 'landmark': 'Near the temple'},
    'paymentMethod': 'CASH',
    'visitFeeCents': 50000,
    'etaMinutes': status == 'EN_ROUTE' ? 14 : null,
    'jobCode': hasTech && !paid ? '4821' : null,
    'events': [
      for (final s in ['SEARCHING', 'ASSIGNED', 'EN_ROUTE', 'ARRIVED', 'AWAITING_APPROVAL', 'COMPLETED', 'PAID']) {'status': s, 'note': null, 'createdAt': _now},
    ],
    'photos': [
      {'id': 'p1', 'kind': 'PROBLEM'},
      {'id': 'p2', 'kind': 'BEFORE'},
      {'id': 'p3', 'kind': 'AFTER'},
    ],
    'quotation': pending || paid || status == 'COMPLETED' || status == 'IN_PROGRESS'
        ? {
            'id': 'q1',
            'status': pending ? 'PENDING' : 'APPROVED',
            'note': 'The compressor needs a gas refill and a new capacitor.',
            'visitFeeCents': 50000,
            'labourCents': 150000,
            'partsCents': 125000,
            'totalCents': 325000,
            'items': [
              {'description': 'Capacitor', 'quantity': 1, 'totalCents': 75000},
              {'description': 'Gas refill', 'quantity': 1, 'totalCents': 50000},
            ],
          }
        : null,
    'payment': status == 'COMPLETED' || paid
        ? {'method': 'CASH', 'status': paid ? 'PAID' : 'PENDING', 'amountCents': 325000, 'paidAt': paid ? _now : null}
        : null,
    'review': null,
    'unreadMessages': 2,
    'canCancel': {'SEARCHING', 'OPERATOR_ASSIGNING', 'ASSIGNED', 'EN_ROUTE'}.contains(status),
    'canChat': hasTech && !paid && status != 'CANCELLED',
    'canAddPhotos': false,
  };
}

Map<String, dynamic> _summary(String status, {String type = 'EMERGENCY'}) {
  final b = _booking(status, type: type);
  return {for (final k in b.keys.where((k) => const {'id', 'reference', 'type', 'status', 'title', 'category', 'technician', 'addressArea', 'scheduledStart', 'scheduledEnd', 'totalCents', 'cancelledBy', 'createdAt'}.contains(k))) k: b[k]};
}

const _problems = [
  {'id': 'pr1', 'name': 'Not cooling'},
  {'id': 'pr2', 'name': 'Water leaking'},
  {'id': 'pr3', 'name': 'Burst or leaking pipe'},
  {'id': 'pr4', 'name': 'Replace handle or hinge'},
  {'id': 'pr5', 'name': 'Something else'},
];

Map<String, dynamic> _category(String id, String slug, String name, String description, String icon, {bool popular = true}) => {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'iconKey': icon,
      'isPopular': popular,
      'visitFeeCents': 50000,
      'problemTypes': _problems,
    };

final _categories = [
  _category('c1', 'electrical', 'Electrical', 'Wiring, sockets, breakers', 'electrical'),
  _category('c2', 'plumbing', 'Plumbing', 'Taps, pipes, leaks', 'plumbing'),
  _category('c3', 'ac', 'AC', 'Service, gas, repairs', 'ac'),
  _category('c4', 'washing-machines', 'Washing machines', 'Drain, noise, no power', 'washing-machine'),
  _category('c5', 'mechanic', 'Mechanic', 'Bikes and vehicles', 'mechanic'),
  _category('c6', 'doors-locks', 'Doors and locks', 'Locks, handles, hinges', 'lock', popular: false),
  _category('c7', 'general', 'General', 'Small jobs around the home', 'general'),
];

http.Response _json(Object body) => http.Response(jsonEncode(body), 200, headers: {'content-type': 'application/json'});

Future<http.Response> _serve(http.Request request) async {
  final path = request.url.path.replaceFirst('/v1', '');
  final tab = request.url.queryParameters['tab'];
  if (path == '/service-categories') return _json({'categories': _categories, 'onlineTechnicians': 7});
  if (path == '/me') {
    return _json({
      'phoneNumber': '+94771234567',
      'fullName': 'Kajan Sivakumar',
      'firstName': 'Kajan',
      'lastName': 'Sivakumar',
      'email': 'kajan@example.com',
      'birthday': '2001-08-12',
      'gender': 'MALE',
      'language': 'EN',
      'hasPhoto': false,
      'photoVersion': null,
      'profileComplete': true,
      'memberSince': '2026-09-01T10:00:00.000Z',
      'membershipType': 'STANDARD',
      'notificationPreferences': {'bookingUpdates': true, 'serviceReminders': true, 'paymentUpdates': true, 'offers': false, 'repairmeUpdates': true},
      'pendingLegal': [],
      'bookingCount': 4,
      'addressCount': 1,
      'unreadNotifications': 3,
    });
  }
  if (path == '/me/emergency-contact') return _json({'name': 'Nimal Perera', 'relationship': 'Family', 'phoneNumber': '+94712345678'});
  if (path == '/legal/documents') {
    return _json([
      for (final t in ['terms', 'privacy']) {'type': t, 'title': t, 'version': '1.0', 'lastUpdated': '2026-10-05', 'requiresAcceptance': true},
    ]);
  }
  if (path.startsWith('/legal/documents/')) {
    return _json({
      'type': path.split('/').last,
      'title': 'Terms & Conditions',
      'version': '1.0',
      'lastUpdated': '2026-10-05',
      'requiresAcceptance': true,
      'content': 'Welcome to RepairMe.\n\n## 1. About RepairMe\n\nRepairMe is a technology platform designed to help customers discover, request and connect with technicians.\n\n### Account Information\n\n- First Name\n- Last Name\n- Mobile Number\n\n## 14. Contact\n\nEmail: [Official Email]',
    });
  }
  if (path == '/addresses') {
    return _json([
      {'id': 'a1', 'label': 'HOME', 'isDefault': true, 'line1': 'Stanley Thilakaratne Mawatha', 'area': 'Nugegoda', 'city': 'Colombo', 'houseNumber': '12/A', 'landmark': 'Near the temple', 'contactName': 'Nimal Perera', 'contactPhone': '+94712345678', 'district': 'Colombo', 'instructions': 'Ring the bell twice, the gate is blue.', 'latitude': null, 'longitude': null},
    ]);
  }
  if (path == '/bookings') {
    return _json(switch (tab) {
      'completed' => [_summary('PAID')],
      'cancelled' => [_summary('CANCELLED')],
      _ => [_summary('EN_ROUTE'), _summary('ASSIGNED', type: 'SCHEDULED')],
    });
  }
  final detail = RegExp(r'^/bookings/b-(\w+)$').firstMatch(path);
  if (detail != null) return _json(_booking(detail.group(1)!));
  if (path.endsWith('/messages')) {
    return _json([
      {'id': 'm1', 'body': 'I am on my way, about 15 minutes.', 'mine': false, 'readAt': null, 'createdAt': _now},
      {'id': 'm2', 'body': 'Great, the gate is open.', 'mine': true, 'readAt': _now, 'createdAt': _now},
    ]);
  }
  if (path == '/notifications') {
    return _json([
      {'id': 'n1', 'bookingId': 'b-EN_ROUTE', 'title': 'Technician on the way', 'body': 'Kasun is about 14 minutes away.', 'readAt': null, 'createdAt': DateTime.now().toIso8601String()},
      {'id': 'n2', 'bookingId': null, 'title': 'Welcome', 'body': 'Thanks for joining RepairMe.', 'readAt': _now, 'createdAt': '2026-09-01T10:00:00.000Z'},
    ]);
  }
  if (path == '/support/tickets') {
    return _json([
      {'reference': 'TK-88', 'bookingReference': 'RM-1042', 'subject': 'Problem with RM-1042', 'status': 'OPEN'},
      {'reference': 'TK-71', 'bookingReference': null, 'subject': 'Refund question', 'status': 'RESOLVED'},
    ]);
  }
  if (path == '/technicians/top-rated') {
    return _json([
      for (final (i, slug) in ['electrical', 'plumbing', 'ac', 'mechanic'].indexed)
        {'firstName': ['Kasun', 'Amal', 'Saman', 'Nuwan'][i], 'categorySlug': slug, 'categoryName': slug, 'rating': '4.${9 - i}', 'ratingCount': 90 + i, 'jobsCompleted': 120 + i},
    ]);
  }
  if (path == '/conversations') {
    return _json([
      {
        'bookingId': 'b-EN_ROUTE',
        'reference': 'RM-1042',
        'title': 'Not cooling',
        'categoryIcon': 'ac',
        'status': 'EN_ROUTE',
        'technicianName': 'Kasun Perera',
        'chatOpen': true,
        'lastMessage': {'body': 'I am on my way, about 15 minutes.', 'mine': false, 'createdAt': _now},
        'unreadCount': 2,
        'lastActivityAt': DateTime.now().toIso8601String(),
      },
    ]);
  }
  if (path.contains('/photos/')) {
    // A 1x1 transparent PNG.
    return http.Response.bytes(base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='), 200);
  }
  return http.Response('{}', 404);
}

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.sublistView(File('assets/fonts/$f').readAsBytesSync())));
    }
    await loader.load();
  }

  await load('Poppins', ['Poppins-Regular.ttf', 'Poppins-Medium.ttf', 'Poppins-SemiBold.ttf', 'Poppins-Bold.ttf', 'Poppins-ExtraBold.ttf']);
  await load('NotoSansSinhala', ['NotoSansSinhala-Regular.ttf', 'NotoSansSinhala-Medium.ttf', 'NotoSansSinhala-SemiBold.ttf', 'NotoSansSinhala-Bold.ttf']);
  await load('NotoSansTamil', ['NotoSansTamil-Regular.ttf', 'NotoSansTamil-Medium.ttf', 'NotoSansTamil-SemiBold.ttf', 'NotoSansTamil-Bold.ttf']);
}

BookingDraft _draft({BookingType type = BookingType.scheduled}) {
  final category = ServiceCategory.fromJson(_categories[2]);
  return BookingDraft(category: category, type: type)
    ..problemType = category.problemTypes.first
    ..description = 'The AC is running but the room is not getting cold at all.'
    ..symptoms.addAll(['Water dripping', 'Bad smell'])
    ..savedAddressId = 'a1'
    ..windowStart = DateTime.now().add(const Duration(days: 2))
    ..windowEnd = DateTime.now().add(const Duration(days: 2, hours: 2));
}

void main() {
  late SharedPreferences prefs;
  late Session session;
  late Repository repo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    session = Session(prefs);
    await session.sendCode('+94771234567');
    repo = Repository(ApiClient(authHeader: () async => 'Dev +94771234567', client: MockClient(_serve)));
  });

  final screens = <String, Widget Function()>{
    'onboarding': () => const OnboardingScreen(),
    'phone': () => const PhoneScreen(),
    'otp': () => const OtpScreen(),
    'home': () => const Scaffold(body: HomeScreen()),
    'services': () => const ServicesScreen(),
    'top technicians': () => const TopTechniciansScreen(),
    'bookings': () => const BookingsScreen(),
    'notifications': () => const NotificationsScreen(),
    'help & support': () => const HelpSupportScreen(),
    'faq': () => const FaqScreen(),
    'contact support': () => const ContactSupportScreen(),
    'support requests': () => const SupportRequestsScreen(),
    'about': () => const AboutScreen(),
    'legal list': () => const LegalPrivacyScreen(),
    'legal document': () => const LegalDocumentScreen(type: 'terms'),
    'profile': () => const ProfileScreen(),
    'personal information': () => const PersonalInformationScreen(),
    'membership': () => const MembershipScreen(),
    'payment methods': () => const PaymentMethodsScreen(),
    'change number': () => const ChangePhoneScreen(),
    'notification preferences': () => const NotificationPreferencesScreen(),
    'delete: reason': () => const DeleteAccountScreen(),
    'delete: confirm': () => const DeleteConfirmScreen(request: DeleteRequest('OTHER', '')),
    'delete: code': () => const DeleteOtpScreen(request: DeleteRequest('OTHER', '')),
    'complete profile': () => const CompleteProfileScreen(),
    'accept terms': () => const AcceptTermsScreen(),
    'additional settings': () => const AdditionalSettingsScreen(),
    'offline': () => const OfflineScreen(),
    'addresses': () => const AddressesScreen(),
    'address: new': () => const AddressFormScreen(),
    'messages': () => const MessagesScreen(),
    'request: type': () => BookingTypeScreen(draft: _draft()),
    'request: details': () => DetailsScreen(draft: _draft()),
    'request: photos': () => PhotosScreen(draft: _draft()),
    'request: location': () => LocationScreen(draft: _draft()),
    'request: datetime': () => DateTimeScreen(draft: _draft()),
    'request: review': () => ReviewScreen(draft: _draft()),
    for (final status in ['SEARCHING', 'OPERATOR_ASSIGNING', 'ASSIGNED', 'EN_ROUTE', 'ARRIVED', 'AWAITING_APPROVAL', 'IN_PROGRESS', 'COMPLETED', 'PAID', 'CANCELLED'])
      'booking $status': () => BookingScreen(id: 'b-$status'),
    'chat': () => const ChatScreen(id: 'b-EN_ROUTE'),
    'cost approval': () => const CostApprovalScreen(id: 'b-AWAITING_APPROVAL'),
    'payment': () => const PaymentScreen(id: 'b-COMPLETED'),
    'receipt': () => const ReceiptScreen(id: 'b-PAID'),
    'rating': () => const RatingScreen(id: 'b-PAID'),
  };

  for (final language in ['EN', 'SI', 'TA']) {
    testWidgets('no layout problems in $language', (tester) async {
      tester.view.physicalSize = const Size(360 * 2, 780 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final problems = <String>[];
      final language0 = AppLanguage(prefs);
      await language0.set(language);

      for (final entry in screens.entries) {
        final original = FlutterError.onError;
        FlutterError.onError = (details) {
          final info = (details.informationCollector?.call() ?? []).map((n) => n.toStringDeep()).join(' ');
          final creator = RegExp(r'creator: (.*)').firstMatch(info)?.group(1) ?? '';
          problems.add('[$language] ${entry.key}: ${details.exceptionAsString().split(String.fromCharCode(10)).first} :: $creator');
        };

        AppFonts.apply(language.toLowerCase());
        AppColors.apply(Brightness.dark);
        await tester.pumpWidget(
          AppScope(
            session: session,
            repo: repo,
            appearance: Appearance(prefs),
            language: language0,
            child: MaterialApp(
              theme: buildTheme(Brightness.dark),
              locale: language0.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                CupertinoFallbackDelegate(),
              ],
              home: entry.value(),
            ),
          ),
        );
        // Let the fake API answer, without waiting on endless animations or polling timers.
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 10));
        FlutterError.onError = original;
      }

      if (problems.isNotEmpty) {
        fail('${problems.length} layout problems:\n${problems.toSet().join('\n')}');
      }
    });
  }
}
