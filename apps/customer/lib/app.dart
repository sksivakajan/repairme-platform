import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/session.dart';
import 'data/booking_draft.dart';
import 'data/models.dart';
import 'data/repository.dart';
import 'screens/auth_screens.dart';
import 'screens/booking_screens.dart';
import 'screens/home_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/request_screens.dart';
import 'screens/splash_screen.dart';
import 'screens/tab_screens.dart';
import 'theme/app_theme.dart';
import 'widgets/common.dart';

class RepairMeApp extends StatefulWidget {
  const RepairMeApp({super.key, required this.session, required this.repo});

  final Session session;
  final Repository repo;

  @override
  State<RepairMeApp> createState() => _RepairMeAppState();
}

class _RepairMeAppState extends State<RepairMeApp> {
  /// The splash animation plays once per app start before any other screen.
  final _splashDone = ValueNotifier(false);
  late final GoRouter _router = _buildRouter(widget.session, _splashDone);

  @override
  void dispose() {
    _splashDone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      session: widget.session,
      repo: widget.repo,
      child: MaterialApp.router(
        title: 'RepairMe',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
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
      switch (session.status) {
        case SessionStatus.loading:
          return null;
        case SessionStatus.signedOut:
          if (_authRoutes.contains(location)) return null;
          return session.hasOnboarded ? '/phone' : '/onboarding';
        case SessionStatus.signedIn:
          if (location == '/splash' || _authRoutes.contains(location)) return '/home';
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
      GoRoute(path: '/support', builder: (_, _) => const SupportScreen()),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/addresses', builder: (_, _) => const AddressesScreen()),
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
