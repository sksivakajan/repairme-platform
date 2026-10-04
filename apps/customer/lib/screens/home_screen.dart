import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../data/booking_draft.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import 'tab_screens.dart' show ActiveBookingBanner;

class _HomeData {
  const _HomeData(this.catalog, this.profile, this.active, this.addresses, this.technicians);

  final Catalog catalog;
  final Profile profile;
  final List<BookingSummary> active;
  final List<SavedAddress> addresses;
  final List<TopTechnician> technicians;
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

/// C05 · Home.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<_HomeData> _load(BuildContext context) async {
    final repo = context.repo;
    // The technicians row is optional: never fail the whole screen for it.
    final technicians = repo.topTechnicians().catchError((Object _) => <TopTechnician>[]);
    final results = await Future.wait<Object>([
      repo.catalog(),
      repo.profile(),
      repo.bookings('active'),
      repo.addresses(),
      technicians,
    ]);
    return _HomeData(
      results[0] as Catalog,
      results[1] as Profile,
      results[2] as List<BookingSummary>,
      results[3] as List<SavedAddress>,
      results[4] as List<TopTechnician>,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: SafeArea(
        bottom: false,
        child: AsyncView(
          load: () => _load(context),
          builder: (context, data, reload) {
            final popular = data.catalog.categories.where((c) => c.isPopular).take(6).toList();
            return RefreshIndicator(
              color: AppColors.ink,
              onRefresh: reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  _Header(profile: data.profile, addresses: data.addresses, onReturn: reload),
                  const SizedBox(height: 18),
                  const _SearchBar(),
                  for (final booking in data.active.take(2)) ...[
                    const SizedBox(height: 12),
                    ActiveBookingBanner(booking: booking, onReturn: reload),
                  ],
                  const SizedBox(height: 18),
                  _PromoCarousel(onlineTechnicians: data.catalog.onlineTechnicians),
                  _SectionHeader(title: 'Services', action: 'See all', onAction: () => context.push('/services')),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.98,
                    children: [for (final category in popular) _ServiceTile(category: category)],
                  ),
                  if (data.technicians.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Top rated technicians',
                      action: 'View all',
                      onAction: () => context.push('/technicians'),
                    ),
                    SizedBox(
                      height: 176,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: data.technicians.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => _TechnicianCard(technician: data.technicians[i]),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Booking type first (Emergency banner), then the service.
  static void startRequest(BuildContext context, BookingType type) => context.push('/services', extra: type);
}

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.addresses, required this.onReturn});

  final Profile profile;
  final List<SavedAddress> addresses;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final name = profile.firstName.isEmpty ? 'Welcome' : profile.firstName;
    final address = addresses.where((a) => a.isDefault).firstOrNull ?? addresses.firstOrNull;
    final place = address == null
        ? 'Add your address'
        : (address.address.area.isNotEmpty ? address.address.area : address.address.city);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_greeting()},', style: TextStyle(color: AppColors.muted, fontSize: 14)),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.25),
              ),
              const SizedBox(height: 2),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  await context.push('/addresses');
                  await onReturn();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_rounded, size: 17, color: AppColors.yellowDeep),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          place,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkSoft),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.inkSoft),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _BellButton(
          unread: profile.unreadNotifications,
          onTap: () async {
            await context.push('/notifications');
            await onReturn();
          },
        ),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: 'Profile',
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go('/profile'),
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFCB2F), Color(0xFFFFB703)],
                ),
              ),
              child: profile.fullName == null || profile.fullName!.trim().isEmpty
                  ? const Icon(Icons.person_rounded, color: AppColors.black)
                  : Text(
                      initials(profile.fullName!)[0],
                      style: const TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton({required this.unread, required this.onTap});

  final int unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: unread > 0 ? 'Notifications, $unread unread' : 'Notifications',
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            width: 46,
            height: 46,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 24),
                if (unread > 0)
                  Positioned(
                    top: 11,
                    right: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.yellowDeep,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/services?search=1'),
        child: SizedBox(
          height: 54,
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.search_rounded, color: AppColors.muted),
              SizedBox(width: 10),
              Text('Search for a service...', style: TextStyle(color: AppColors.muted, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoCarousel extends StatefulWidget {
  const _PromoCarousel({required this.onlineTechnicians});

  final int onlineTechnicians;

  @override
  State<_PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<_PromoCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  List<Widget> _slides(BuildContext context) => [
        const _BrandBanner(),
        const _ImageBanner(asset: 'assets/images/banner_team.jpg', label: 'RepairMe team', alignment: Alignment.center),
        _ImageBanner(
          asset: 'assets/images/banner_emergency.jpg',
          label: 'Need help right now? Get emergency help',
          onTap: () => HomeScreen.startRequest(context, BookingType.emergency),
        ),
        _ImageBanner(
          asset: 'assets/images/banner_schedule.jpg',
          label: 'Repair it on your time. Schedule a repair',
          onTap: () => HomeScreen.startRequest(context, BookingType.scheduled),
        ),
        _ImageBanner(
          asset: 'assets/images/banner_measure.jpg',
          label: 'Planning something bigger? Request a measurement',
          onTap: () => HomeScreen.startRequest(context, BookingType.inspection),
        ),
        _EmergencyBanner(onlineTechnicians: widget.onlineTechnicians),
      ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_page + 1) % _slides(context).length,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides(context);
    return Column(
      children: [
        SizedBox(
          height: 172,
          child: PageView(
            controller: _controller,
            onPageChanged: (page) => setState(() => _page = page),
            children: slides,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: i == _page ? AppColors.yellowDeep : AppColors.line,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// A banner made from artwork. Wide banners are fitted to the height and
/// keep their left side, where the headline and button are.
class _ImageBanner extends StatelessWidget {
  const _ImageBanner({required this.asset, required this.label, this.onTap, this.alignment = Alignment.centerLeft});

  final String asset;
  final String label;
  final VoidCallback? onTap;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: onTap != null,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover, alignment: alignment, filterQuality: FilterQuality.medium),
            if (onTap != null) Material(color: Colors.transparent, child: InkWell(onTap: onTap)),
          ],
        ),
      ),
    );
  }
}

Widget _circle(double size, Color color) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
);

class _BrandBanner extends StatelessWidget {
  const _BrandBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF2F2A20)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: -40, bottom: -70, child: _circle(200, AppColors.yellow.withValues(alpha: 0.14))),
          const Positioned(right: 20, top: 20, child: RepairMeLogo(size: 88, palette: LogoPalette.onDark)),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Built in Sri Lanka,',
                  style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.25),
                ),
                Text(
                  'for every Sri Lankan',
                  style: TextStyle(color: AppColors.yellow, fontSize: 19, fontWeight: FontWeight.w700, height: 1.25),
                ),
                SizedBox(height: 6),
                Text(
                  'Verified expertise. Trusted integrity.',
                  style: TextStyle(color: Color(0xFFCFCCC4), fontSize: 11.5),
                ),
                Spacer(),
                Row(
                  children: [
                    _TrustChip(icon: Icons.verified_rounded, label: 'Verified'),
                    SizedBox(width: 6),
                    _TrustChip(icon: Icons.bolt_rounded, label: 'Fast'),
                    SizedBox(width: 6),
                    _TrustChip(icon: Icons.star_rounded, label: 'Trusted'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  const _TrustChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.yellow),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner({required this.onlineTechnicians});

  final int onlineTechnicians;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFCB2F), Color(0xFFFFB703)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: -30, top: -50, child: _circle(160, Colors.white.withValues(alpha: 0.2))),
          Positioned(
            right: 22,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                child: const Icon(Icons.bolt_rounded, color: AppColors.yellow, size: 36),
              ),
            ),
          ),
          OnYellow(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 100, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Pill(label: 'EMERGENCY', background: AppColors.black, foreground: AppColors.yellow),
                  const SizedBox(height: 10),
                  const Text(
                    'Need help right now?',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: 1.2),
                  ),
                  Text(
                    onlineTechnicians > 0
                        ? '$onlineTechnicians technicians online · avg. 18 min'
                        : 'Verified technicians, 24 hours a day',
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF3D3D3A)),
                  ),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => HomeScreen.startRequest(context, BookingType.emergency),
                    child: const Text('Get help now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, required this.onAction});

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.yellowDeep,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 36),
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(18),
  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 4))],
);

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push(
            '/request/type',
            extra: BookingDraft(category: category, type: BookingType.emergency),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(14)),
                  child: Icon(categoryIcon(category.iconKey), color: AppColors.yellowDeep, size: 25),
                ),
                const SizedBox(height: 8),
                // Room for two lines on every tile keeps the icons aligned.
                SizedBox(
                  height: 32,
                  child: Center(
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard({required this.technician});

  final TopTechnician technician;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${technician.firstName}, ${technician.trade}, rated ${technician.rating.toStringAsFixed(1)}',
      excludeSemantics: true,
      child: Container(
        width: 118,
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.yellow, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: AppColors.yellowSoft,
                    child: Text(
                      technician.firstName[0].toUpperCase(),
                      style: TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.solid,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded, size: 13, color: AppColors.yellow),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              technician.firstName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              technician.trade,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5A300)),
                const SizedBox(width: 2),
                Text(
                  technician.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "View all" from the home screen.
class TopTechniciansScreen extends StatelessWidget {
  const TopTechniciansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top rated technicians')),
      body: AsyncView(
        load: context.repo.topTechnicians,
        builder: (context, technicians, reload) => RefreshIndicator(
          color: AppColors.ink,
          onRefresh: reload,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(14)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'When you book, we match you with the nearest available verified technician.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (technicians.isEmpty) const EmptyState(icon: Icons.star_outline_rounded, title: 'No ratings yet'),
              for (final technician in technicians)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.yellowSoft,
                        child: Text(
                          technician.firstName[0].toUpperCase(),
                          style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(technician.firstName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
                        ],
                      ),
                      subtitle: Text('${technician.trade} · ${technician.jobsCompleted} jobs'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF5A300)),
                          const SizedBox(width: 2),
                          Text(
                            technician.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
