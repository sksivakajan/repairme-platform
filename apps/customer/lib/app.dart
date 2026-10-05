import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/app_language.dart';
import 'core/appearance.dart';
import 'core/session.dart';
import 'data/booking_draft.dart';
import 'data/models.dart';
import 'data/repository.dart';
import 'l10n/cupertino_fallback.dart';
import 'l10n/l10n.dart';
import 'screens/account_screens.dart';
import 'screens/address_screens.dart';
import 'screens/auth_screens.dart';
import 'screens/booking_screens.dart';
import 'screens/home_screen.dart';
import 'screens/legal_screens.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screens.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/request_screens.dart';
import 'screens/splash_screen.dart';
import 'screens/support_screens.dart';
import 'screens/tab_screens.dart';
import 'theme/app_theme.dart';
import 'widgets/common.dart';

class RepairMeApp extends StatefulWidget {
  const RepairMeApp({super.key, required this.session, required this.repo, required this.appearance, required this.language});

  final Session session;
  final Repository repo;
  final Appearance appearance;
  final AppLanguage language;

  @override
  State<RepairMeApp> createState() => _RepairMeAppState();
}

class _RepairMeAppState extends State<RepairMeApp> with WidgetsBindingObserver {
  /// The splash animation plays once per app start before any other screen.
  final _splashDone = ValueNotifier(false);
  late final GoRouter _router = _buildRouter(widget.session, _splashDone);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.appearance.addListener(_rebuild);
    widget.language.addListener(_rebuild);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.appearance.removeListener(_rebuild);
    widget.language.removeListener(_rebuild);
    _splashDone.dispose();
    super.dispose();
  }

  /// Redraws every screen with the new palette, keeping navigation and state.
  /// (Widgets read [AppColors] directly, so const widgets must be rebuilt too.)
  void _rebuild() {
    setState(() {});
    void markDirty(Element element) {
      element.markNeedsBuild();
      element.visitChildren(markDirty);
    }

    (context as Element).visitChildren(markDirty);
  }

  /// Follows the phone's dark mode when the customer chose "System".
  @override
  void didChangePlatformBrightness() => _rebuild();

  @override
  Widget build(BuildContext context) {
    final brightness = widget.appearance.resolve(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    AppColors.apply(brightness);
    AppFonts.apply(widget.language.locale.languageCode);
    return AppScope(
      session: widget.session,
      repo: widget.repo,
      appearance: widget.appearance,
      language: widget.language,
      child: MaterialApp.router(
        title: 'RepairMe',
        debugShowCheckedModeBanner: false,
        locale: widget.language.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CupertinoFallbackDelegate(),
        ],
        scrollBehavior: const _NoStretchScrollBehavior(),
        theme: buildTheme(brightness),
        routerConfig: _router,
      ),
    );
  }
}

const _authRoutes = {'/onboarding', '/phone', '/otp'};

/// Fades in, used for the screens that replace the splash.
Page<void> _fade(GoRouterState state, Widget child) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
    );

GoRouter _buildRouter(Session session, ValueNotifier<bool> splashDone) {
  /// Request screens receive the draft through `extra`; without it (e.g. after
  /// a process restart) send the customer back home.
  GoRoute requestRoute(String path, Widget Function(BookingDraft draft) build) => GoRoute(
        path: path,
        redirect: (context, state) => state.extra is BookingDraft ? null : '/home',
        builder: (context, state) => build(state.extra! as BookingDraft),
      );

  GoRoute bookingRoute(String path, Widget Function(String id) build) =>
      GoRoute(path: path, builder: (context, state) => build(state.pathParameters['id']!));

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: Listenable.merge([session, splashDone]),
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (!splashDone.value || session.status == SessionStatus.loading) {
        return location == '/splash' ? null : '/splash';
      }
      // The legal documents can be read before signing in (the sign-in screen links to them).
      final isLegal = location == '/legal' || location.startsWith('/legal/');
      switch (session.status) {
        case SessionStatus.loading:
          return null;
        case SessionStatus.offline:
          return location == '/offline' ? null : '/offline';
        case SessionStatus.signedOut:
          if (_authRoutes.contains(location) || isLegal) return null;
          return session.hasOnboarded ? '/phone' : '/onboarding';
        case SessionStatus.needsProfile:
          // A verified number with no account yet: finish setup before anything else.
          if (location == '/complete-profile' || isLegal) return null;
          return '/complete-profile';
        case SessionStatus.needsTerms:
          // The current Terms & Privacy Policy must be accepted before anything else.
          if (location == '/accept-terms' || isLegal) return null;
          return '/accept-terms';
        case SessionStatus.signedIn:
          if (location == '/splash' ||
              location == '/offline' ||
              location == '/complete-profile' ||
              location == '/accept-terms' ||
              _authRoutes.contains(location)) {
            return '/home';
          }
          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fade(state, SplashScreen(onFinished: () => splashDone.value = true)),
      ),
      GoRoute(path: '/onboarding', pageBuilder: (context, state) => _fade(state, const OnboardingScreen())),
      GoRoute(path: '/phone', pageBuilder: (context, state) => _fade(state, const PhoneScreen())),
      GoRoute(path: '/otp', builder: (_, _) => const OtpScreen()),
      GoRoute(path: '/complete-profile', builder: (_, _) => const CompleteProfileScreen()),
      GoRoute(path: '/offline', builder: (_, _) => const OfflineScreen()),
      GoRoute(path: '/accept-terms', builder: (_, _) => const AcceptTermsScreen()),
      GoRoute(path: '/legal', builder: (_, _) => const LegalPrivacyScreen()),
      GoRoute(path: '/legal/:type', builder: (_, state) => LegalDocumentScreen(type: state.pathParameters['type']!)),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, shell) => _fade(state, HomeShell(shell: shell)),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/bookings', builder: (_, _) => const BookingsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/messages', builder: (_, _) => const MessagesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())]),
        ],
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => ServicesScreen(
          type: state.extra is BookingType ? state.extra! as BookingType : null,
          focusSearch: state.uri.queryParameters['search'] == '1',
        ),
      ),
      GoRoute(path: '/technicians', builder: (_, _) => const TopTechniciansScreen()),
      GoRoute(path: '/support', builder: (_, _) => const HelpSupportScreen()),
      GoRoute(path: '/support/faq', builder: (_, _) => const FaqScreen()),
      GoRoute(path: '/support/contact', builder: (_, _) => const ContactSupportScreen()),
      GoRoute(path: '/support/requests', builder: (_, _) => const SupportRequestsScreen()),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
      GoRoute(path: '/profile/personal', builder: (_, _) => const PersonalInformationScreen()),
      GoRoute(path: '/profile/membership', builder: (_, _) => const MembershipScreen()),
      GoRoute(path: '/profile/payments', builder: (_, _) => const PaymentMethodsScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const AdditionalSettingsScreen()),
      GoRoute(path: '/settings/phone', builder: (_, _) => const ChangePhoneScreen()),
      GoRoute(path: '/settings/notifications', builder: (_, _) => const NotificationPreferencesScreen()),
      GoRoute(path: '/settings/delete', builder: (_, _) => const DeleteAccountScreen()),
      GoRoute(
        path: '/settings/delete/confirm',
        redirect: (context, state) => state.extra is DeleteRequest ? null : '/profile/personal',
        builder: (_, state) => DeleteConfirmScreen(request: state.extra! as DeleteRequest),
      ),
      GoRoute(
        path: '/settings/delete/otp',
        redirect: (context, state) => state.extra is DeleteRequest ? null : '/profile/personal',
        builder: (_, state) => DeleteOtpScreen(request: state.extra! as DeleteRequest),
      ),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/addresses', builder: (_, _) => const AddressesScreen()),
      GoRoute(path: '/addresses/new', builder: (_, _) => const AddressFormScreen()),
      GoRoute(
        path: '/addresses/edit',
        redirect: (context, state) => state.extra is SavedAddress ? null : '/addresses',
        builder: (_, state) => AddressFormScreen(existing: state.extra! as SavedAddress),
      ),
      requestRoute('/request/type', (draft) => BookingTypeScreen(draft: draft)),
      requestRoute('/request/details', (draft) => DetailsScreen(draft: draft)),
      requestRoute('/request/photos', (draft) => PhotosScreen(draft: draft)),
      requestRoute('/request/location', (draft) => LocationScreen(draft: draft)),
      requestRoute('/request/datetime', (draft) => DateTimeScreen(draft: draft)),
      requestRoute('/request/review', (draft) => ReviewScreen(draft: draft)),
      bookingRoute('/booking/:id', (id) => BookingScreen(id: id)),
      bookingRoute('/booking/:id/status', (id) => JobStatusScreen(id: id)),
      bookingRoute('/booking/:id/chat', (id) => ChatScreen(id: id)),
      bookingRoute('/booking/:id/cost', (id) => CostApprovalScreen(id: id)),
      bookingRoute('/booking/:id/payment', (id) => PaymentScreen(id: id)),
      bookingRoute('/booking/:id/receipt', (id) => ReceiptScreen(id: id)),
      bookingRoute('/booking/:id/rate', (id) => RatingScreen(id: id)),
    ],
  );
}

/// Keeps screens still at the scroll edges: no Android stretch effect when
/// pulling down (pull-to-refresh only shows its spinner).
class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}
