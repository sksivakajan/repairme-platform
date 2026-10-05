import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../data/booking_draft.dart';
import '../data/models.dart';
import '../l10n/catalog_text.dart';
import '../l10n/l10n.dart';
import '../l10n/trade_text.dart';
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

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;
  if (hour < 12) return context.l10n.greetMorning;
  if (hour < 17) return context.l10n.greetAfternoon;
  return context.l10n.greetEvening;
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
                  _SectionHeader(title: context.l10n.services, action: context.l10n.seeAll, onAction: () => context.push('/services')),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.88,
                    children: [for (final category in popular) _ServiceTile(category: category)],
                  ),
                  if (data.technicians.isNotEmpty) ...[
                    _SectionHeader(
                      title: context.l10n.topRatedTechnicians,
                      action: context.l10n.viewAll,
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
    final name = profile.firstName.isEmpty ? context.l10n.welcome : profile.firstName;
    final address = addresses.where((a) => a.isDefault).firstOrNull ?? addresses.firstOrNull;
    final place = address == null
        ? context.l10n.addYourAddress
        : (address.address.area.isNotEmpty ? address.address.area : address.address.city);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_greeting(context)},', style: TextStyle(color: AppColors.muted, fontSize: 14)),
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
          label: context.l10n.navProfile,
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
      label: unread > 0 ? context.l10n.notificationsUnread('$unread') : context.l10n.notifications,
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
              const SizedBox(width: 16),
              Icon(Icons.search_rounded, color: AppColors.muted),
              const SizedBox(width: 10),
              Text(context.l10n.searchService, style: TextStyle(color: AppColors.muted, fontSize: 14)),
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
        const _TeamBanner(),
        _OfferBanner(
          tag: context.l10n.offerNewTag,
          title: context.l10n.offerNewTitle,
          subtitle: context.l10n.offerNewSub,
          code: 'WELCOME20',
          cta: context.l10n.bookNow,
          icon: Icons.local_offer_rounded,
          colors: const [Color(0xFF1A1A1A), Color(0xFF3A3220)],
          onTap: () => context.push('/services'),
        ),
        _OfferBanner(
          tag: context.l10n.offerHomeTag,
          title: context.l10n.offerHomeTitle,
          subtitle: context.l10n.offerHomeSub,
          cta: context.l10n.bookTechnician,
          icon: Icons.home_repair_service_rounded,
          colors: const [Color(0xFFFFCB2F), Color(0xFFFFB703)],
          darkText: true,
          onTap: () => context.push('/services'),
        ),
        _OfferBanner(
          tag: context.l10n.offerRoadTag,
          title: context.l10n.offerRoadTitle,
          subtitle: context.l10n.offerRoadSub,
          code: 'ROAD500',
          cta: context.l10n.getHelpNow,
          icon: Icons.directions_car_rounded,
          colors: const [Color(0xFF2B2B2B), Color(0xFF111111)],
          onTap: () => HomeScreen.startRequest(context, BookingType.emergency),
        ),
        _EmergencyBanner(onlineTechnicians: widget.onlineTechnicians),
        const _BrandBanner(),
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

/// A promotion / offer banner drawn with widgets (real text, no baked-in artwork).
class _OfferBanner extends StatelessWidget {
  const _OfferBanner({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.colors,
    required this.onTap,
    this.code,
    this.darkText = false,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String cta;
  final String? code;
  final IconData icon;
  final List<Color> colors;
  final bool darkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = darkText ? AppColors.black : Colors.white;
    final sub = darkText ? const Color(0xFF3D3D3A) : const Color(0xFFCFCCC4);
    final accent = darkText ? AppColors.black : AppColors.yellow;
    return Semantics(
      label: '$title. $subtitle${code != null ? '. ${context.l10n.useCode(code!)}' : ''}',
      button: true,
      excludeSemantics: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
        child: Stack(
          children: [
            Positioned(right: -40, bottom: -60, child: _circle(190, accent.withValues(alpha: 0.14))),
            Positioned(right: 18, top: 0, bottom: 0, child: Center(child: Icon(icon, size: 70, color: accent.withValues(alpha: 0.9)))),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 110, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pill(label: tag, background: accent, foreground: darkText ? AppColors.yellow : AppColors.black),
                  const SizedBox(height: 8),
                  Text(title, style: TextStyle(color: fg, fontSize: 26, fontWeight: FontWeight.w800, height: 1.1)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: sub, fontSize: 12.5)),
                  const Spacer(),
                  Row(
                    children: [
                      if (code != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: accent.withValues(alpha: 0.7)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(code!, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(cta, style: TextStyle(color: fg, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 18, color: fg),
                    ],
                  ),
                ],
              ),
            ),
            Positioned.fill(child: Material(color: Colors.transparent, child: InkWell(onTap: onTap))),
          ],
        ),
      ),
    );
  }
}

/// The team photo with "Built in Sri Lanka, for every Sri Lankan".
class _TeamBanner extends StatelessWidget {
  const _TeamBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/banner_team.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0.6, -0.2),
            filterQuality: FilterQuality.medium,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.92),
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0),
                ],
                stops: const [0, 0.42, 0.8],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.teamLine1,
                    style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.2)),
                Text(context.l10n.teamLine2,
                    style: const TextStyle(color: AppColors.yellow, fontSize: 19, fontWeight: FontWeight.w700, height: 1.2)),
                const Spacer(),
                Row(
                  children: [
                    const Text('🇱🇰', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(context.l10n.meetTheTeam,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.teamLine1,
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.25),
                ),
                Text(
                  context.l10n.teamLine2,
                  style: const TextStyle(color: AppColors.yellow, fontSize: 19, fontWeight: FontWeight.w700, height: 1.25),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.brandTagline,
                  style: const TextStyle(color: Color(0xFFCFCCC4), fontSize: 11.5),
                ),
                const Spacer(),
                Row(
                  children: [
                    _TrustChip(icon: Icons.verified_rounded, label: context.l10n.chipVerified),
                    const SizedBox(width: 6),
                    _TrustChip(icon: Icons.bolt_rounded, label: context.l10n.chipFast),
                    const SizedBox(width: 6),
                    _TrustChip(icon: Icons.star_rounded, label: context.l10n.chipTrusted),
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
                  Pill(label: context.l10n.emergencyTag, background: AppColors.black, foreground: AppColors.yellow),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.needHelpNow,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: 1.2),
                  ),
                  Text(
                    onlineTechnicians > 0
                        ? context.l10n.techniciansOnline(onlineTechnicians)
                        : context.l10n.verifiedTechniciansAllDay,
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
                      textStyle: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => HomeScreen.startRequest(context, BookingType.emergency),
                    child: Text(context.l10n.getHelpNow),
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
                ServiceArt(iconKey: category.iconKey),
                const SizedBox(height: 8),
                // Room for two lines on every tile keeps the icons aligned.
                SizedBox(
                  height: 38,
                  child: Center(
                    child: Text(
                      context.categoryName(category.slug, category.name),
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
      label: context.l10n.technicianRated(technician.firstName, context.tradeOf(technician), technician.rating.toStringAsFixed(1)),
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
              context.tradeOf(technician),
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
      appBar: AppBar(title: Text(context.l10n.topRatedTechnicians)),
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
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.l10n.topTechInfo,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (technicians.isEmpty) EmptyState(icon: Icons.star_outline_rounded, title: context.l10n.noRatingsYet),
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
                      subtitle: Text(context.l10n.tradeAndJobs(context.tradeOf(technician), technician.jobsCompleted)),
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

/// 3D illustration for the main services; other services use [PremiumIcon].
class ServiceArt extends StatelessWidget {
  const ServiceArt({super.key, required this.iconKey, this.size = 66});

  final String iconKey;
  final double size;

  static const _illustrated = {'electrical', 'plumbing', 'ac', 'washing-machine', 'mechanic', 'general'};

  @override
  Widget build(BuildContext context) {
    if (!_illustrated.contains(iconKey)) return PremiumIcon(icon: categoryIcon(iconKey), size: size * 0.79);
    // Transparent artwork, so it sits on the card in light and dark mode.
    return Image.asset(
      'assets/images/services/$iconKey.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
    );
  }
}
