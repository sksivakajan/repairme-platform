import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_language.dart';
import '../core/format.dart';
import '../data/booking_draft.dart';
import '../data/models.dart';
import '../l10n/booking_text.dart';
import '../l10n/catalog_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'home_screen.dart' show ServiceArt;

/// Bottom navigation shell: Home, Bookings, Messages, Profile.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: context.l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: const Icon(Icons.calendar_month_rounded),
              label: context.l10n.navBookings,
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: const Icon(Icons.chat_bubble_rounded),
              label: context.l10n.navMessages,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: context.l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveBookingBanner extends StatelessWidget {
  const ActiveBookingBanner({super.key, required this.booking, required this.onReturn});

  final BookingSummary booking;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(16),
      child: OnYellow(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await context.push('/booking/${booking.id}');
            await onReturn();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CategoryBadge(iconKey: booking.categoryIcon, size: 40, highlight: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.problemName(booking.title), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(
                        '${booking.reference} · ${statusStyle(context, booking.status, booking.type).label.toLowerCase()}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// C06 · Choose a service.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, this.type, this.focusSearch = false});

  /// Set when the customer already chose Emergency / Schedule / Inspection.
  final BookingType? type;

  /// Opened from the home search bar: start typing straight away.
  final bool focusSearch;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.chooseService)),
      body: AsyncView(
        load: context.repo.catalog,
        builder: (context, catalog, _) {
          final q = _query.toLowerCase();
          final categories = catalog.categories
              .where((c) => q.isEmpty || context.categoryName(c.slug, c.name).toLowerCase().contains(q) || context.categoryDescription(c.slug, c.description).toLowerCase().contains(q))
              .toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                autofocus: widget.focusSearch,
                decoration: InputDecoration(
                  hintText: context.l10n.searchService,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 16),
              if (categories.isEmpty) EmptyState(icon: Icons.search_off_rounded, title: context.l10n.noMatchingService),
              for (final category in categories)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: SizedBox(width: 60, height: 60, child: Center(child: ServiceArt(iconKey: category.iconKey, size: 58))),
                      title: Text(context.categoryName(category.slug, category.name), style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(context.categoryDescription(category.slug, category.description)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        final draft = BookingDraft(category: category, type: widget.type ?? BookingType.emergency);
                        if (widget.type == null) {
                          context.push('/request/type', extra: draft);
                        } else {
                          context.push('/request/details', extra: draft);
                        }
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// C22 · Bookings.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.navBookings),
          bottom: TabBar(
            labelColor: AppColors.ink,
            indicatorColor: AppColors.ink,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: context.l10n.tabActive),
              Tab(text: context.l10n.tabCompleted),
              Tab(text: context.l10n.tabCancelled),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BookingList(tab: 'active'),
            _BookingList(tab: 'completed'),
            _BookingList(tab: 'cancelled'),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context) {
    return AsyncView(
      load: () => context.repo.bookings(tab),
      builder: (context, bookings, reload) => RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (bookings.isEmpty)
              EmptyState(
                icon: Icons.receipt_long_outlined,
                title: switch (tab) {
                  'active' => context.l10n.noActiveBookings,
                  'completed' => context.l10n.noCompletedJobs,
                  _ => context.l10n.noCancelledBookings,
                },
              ),
            for (final booking in bookings)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BookingCard(booking: booking, onReturn: reload),
              ),
            if (tab == 'active') ...[
              const SizedBox(height: 8),
              Card(
                color: AppColors.yellowSoft,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(context.l10n.needAnotherRepair, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(context.l10n.bookTechnicianHint),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () => context.push('/services'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onReturn});

  final BookingSummary booking;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final String when;
    if (booking.scheduledStart != null && booking.status != 'PAID' && booking.status != 'CANCELLED') {
      when = context.window(booking.scheduledStart!, booking.scheduledEnd!);
    } else {
      when = '${context.day(booking.createdAt)} · ${booking.reference}';
    }
    final who = booking.cancelledBy == 'CUSTOMER'
        ? context.l10n.cancelledByYou
        : booking.technician?.displayName ?? booking.addressArea;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await context.push('/booking/${booking.id}');
          await onReturn();
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CategoryBadge(iconKey: booking.categoryIcon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.problemName(booking.title), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text('$when · $who', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusPill(status: booking.status, type: booking.type),
                  if (booking.totalCents != null && booking.status == 'PAID') ...[
                    const SizedBox(height: 6),
                    Text(context.lkr(booking.totalCents!), style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// C23 · Notifications.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncView(
      load: context.repo.notifications,
      builder: (context, notifications, reload) {
        final today = notifications.where((n) => isToday(n.createdAt)).toList();
        final earlier = notifications.where((n) => !isToday(n.createdAt)).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.notifications),
            actions: [
              TextButton(
                onPressed: () async {
                  await context.repo.readAllNotifications();
                  await reload();
                },
                child: Text(context.l10n.readAll),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (notifications.isEmpty)
                  EmptyState(icon: Icons.notifications_none_rounded, title: context.l10n.nothingHereYet),
                if (today.isNotEmpty) _GroupLabel(context.l10n.groupToday),
                for (final n in today) _NotificationTile(n),
                if (earlier.isNotEmpty) _GroupLabel(context.l10n.groupEarlier),
                for (final n in earlier) _NotificationTile(n),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: Localizations.localeOf(context).languageCode == 'en' ? 1 : 0,
        color: AppColors.muted,
      ),
    ),
  );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.notification);

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final unread = notification.readAt == null;
    final when = isToday(notification.createdAt)
        ? context.time(notification.createdAt)
        : context.day(notification.createdAt);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: unread ? AppColors.yellowSoft.withValues(alpha: 0.5) : null,
      leading: CircleAvatar(
        backgroundColor: unread ? AppColors.yellow : AppColors.line,
        child: Icon(Icons.notifications_rounded, color: unread ? AppColors.black : AppColors.ink, size: 20),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Text(when, style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
      subtitle: Text(notification.body),
      onTap: notification.bookingId == null ? null : () => context.push('/booking/${notification.bookingId}'),
    );
  }
}

/// Opens a support ticket form. Returns true when a ticket was sent.
Future<bool> showNewTicketSheet(BuildContext context, {String? bookingId, String? subject}) async {
  final subjectController = TextEditingController(text: subject);
  final messageController = TextEditingController();
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(sheetContext.l10n.writeToRepairMe, style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: subjectController,
            decoration: InputDecoration(hintText: sheetContext.l10n.subject),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: messageController,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(hintText: sheetContext.l10n.ticketMessageHint),
          ),
          const SizedBox(height: 16),
          BusyButton(
            label: sheetContext.l10n.send,
            onPressed: () async {
              await context.repo.createTicket(
                subjectController.text.trim(),
                messageController.text.trim(),
                bookingId: bookingId,
              );
              if (sheetContext.mounted) Navigator.pop(sheetContext, true);
            },
          ),
        ],
      ),
    ),
  );
  if (sent == true && context.mounted) context.toast(context.l10n.ticketThanks);
  return sent == true;
}
