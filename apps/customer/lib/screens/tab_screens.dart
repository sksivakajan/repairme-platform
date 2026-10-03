import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../data/booking_draft.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Bottom navigation shell: Home, Bookings, Messages, Profile.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.line))),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'Bookings'),
            NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
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
                    Text(booking.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('${booking.reference} · ${statusStyle(booking.status, booking.type).label.toLowerCase()}',
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
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
      appBar: AppBar(title: const Text('Choose a service')),
      body: AsyncView(
        load: context.repo.catalog,
        builder: (context, catalog, _) {
          final q = _query.toLowerCase();
          final categories = catalog.categories
              .where((c) => q.isEmpty || c.name.toLowerCase().contains(q) || c.description.toLowerCase().contains(q))
              .toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                autofocus: widget.focusSearch,
                decoration: const InputDecoration(hintText: 'Search for a service...', prefixIcon: Icon(Icons.search_rounded)),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 16),
              if (categories.isEmpty)
                const EmptyState(icon: Icons.search_off_rounded, title: 'No matching service'),
              for (final category in categories)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: CategoryBadge(iconKey: category.iconKey),
                      title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(category.description),
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
          title: const Text('Bookings'),
          bottom: const TabBar(
            labelColor: AppColors.ink,
            indicatorColor: AppColors.ink,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [Tab(text: 'Active'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
          ),
        ),
        body: const TabBarView(
          children: [_BookingList(tab: 'active'), _BookingList(tab: 'completed'), _BookingList(tab: 'cancelled')],
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
                  'active' => 'No active bookings',
                  'completed' => 'No completed jobs yet',
                  _ => 'No cancelled bookings',
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
                  title: const Text('Need another repair?', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('Book a verified technician in about 2 minutes.'),
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
      when = formatWindow(booking.scheduledStart!, booking.scheduledEnd!);
    } else {
      when = '${formatDay(booking.createdAt)} · ${booking.reference}';
    }
    final who = booking.cancelledBy == 'CUSTOMER'
        ? 'Cancelled by you'
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
                    Text(booking.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text('$when · $who', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
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
                    Text(formatLkr(booking.totalCents!), style: const TextStyle(fontWeight: FontWeight.w700)),
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
        final today = notifications.where((n) => formatDay(n.createdAt) == 'Today').toList();
        final earlier = notifications.where((n) => formatDay(n.createdAt) != 'Today').toList();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              TextButton(
                onPressed: () async {
                  await context.repo.readAllNotifications();
                  await reload();
                },
                child: const Text('Read all'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (notifications.isEmpty)
                  const EmptyState(icon: Icons.notifications_none_rounded, title: 'Nothing here yet'),
                if (today.isNotEmpty) const _GroupLabel('TODAY'),
                for (final n in today) _NotificationTile(n),
                if (earlier.isNotEmpty) const _GroupLabel('EARLIER'),
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
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.muted)),
      );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.notification);

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final unread = notification.readAt == null;
    final when = formatDay(notification.createdAt) == 'Today'
        ? formatTime(notification.createdAt)
        : formatDay(notification.createdAt);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: unread ? AppColors.yellowSoft.withValues(alpha: 0.5) : null,
      leading: CircleAvatar(
        backgroundColor: unread ? AppColors.yellow : AppColors.line,
        child: const Icon(Icons.notifications_rounded, color: AppColors.ink, size: 20),
      ),
      title: Row(
        children: [
          Expanded(child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w700))),
          Text(when, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
      subtitle: Text(notification.body),
      onTap: notification.bookingId == null ? null : () => context.push('/booking/${notification.bookingId}'),
    );
  }
}

/// C24 · Support.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _faqs = [
    ('Report a problem with a booking',
        'Open the booking and use "Report a problem", or create a ticket below. Our team replies within minutes during the day.'),
    ('How is the price calculated?',
        'Every visit has a Rs. 500 visit fee. Labour and parts are quoted by the technician on site, and nothing is charged until you approve the cost in the app.'),
    ('How are technicians verified?',
        'Every RepairMe technician is ID-checked and their trade documents are reviewed by our team before they can accept jobs.'),
    ('Refunds and cancellations',
        'Cancelling before a technician arrives is free. Every completed job has a 7-day workmanship cover: if the same fault returns, we send someone back at no labour cost.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: AsyncView(
        load: context.repo.tickets,
        builder: (context, tickets, reload) => RefreshIndicator(
          onRefresh: reload,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SupportAction(
                      icon: Icons.call_rounded,
                      title: 'Call RepairMe',
                      subtitle: 'Open 24 hours',
                      onTap: () => context.toast('Call +94 11 000 0000'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SupportAction(
                      icon: Icons.edit_note_rounded,
                      title: 'Write to us',
                      subtitle: 'Replies in minutes',
                      onTap: () async {
                        final sent = await showNewTicketSheet(context);
                        if (sent) await reload();
                      },
                    ),
                  ),
                ],
              ),
              if (tickets.isNotEmpty) ...[
                const SectionTitle('Your tickets'),
                for (final ticket in tickets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        title: Text(ticket.subject, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text([ticket.reference, if (ticket.bookingReference != null) ticket.bookingReference].join(' · ')),
                        trailing: ticket.status == 'RESOLVED'
                            ? const Pill(label: 'RESOLVED', background: Color(0xFFE2F3E8), foreground: AppColors.success)
                            : const Pill(label: 'OPEN', background: AppColors.yellow, foreground: AppColors.ink),
                      ),
                    ),
                  ),
              ],
              const SectionTitle('Common questions'),
              Card(
                child: Column(
                  children: [
                    for (final (question, answer) in _faqs)
                      ExpansionTile(
                        shape: const Border(),
                        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [Text(answer, style: const TextStyle(color: AppColors.inkSoft, height: 1.4))],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportAction extends StatelessWidget {
  const _SupportAction({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: AppColors.yellow, child: Icon(icon, color: AppColors.ink)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ],
          ),
        ),
      ),
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
          Text('Write to RepairMe', style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(controller: subjectController, decoration: const InputDecoration(hintText: 'Subject')),
          const SizedBox(height: 10),
          TextField(
            controller: messageController,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(hintText: 'Tell us what happened (at least 10 characters)'),
          ),
          const SizedBox(height: 16),
          BusyButton(
            label: 'Send',
            onPressed: () async {
              await context.repo.createTicket(subjectController.text.trim(), messageController.text.trim(),
                  bookingId: bookingId);
              if (sheetContext.mounted) Navigator.pop(sheetContext, true);
            },
          ),
        ],
      ),
    ),
  );
  if (sent == true && context.mounted) context.toast('Thanks — our team will get back to you shortly');
  return sent == true;
}

/// C25 · Profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _languages = {'EN': 'English', 'SI': 'සිංහල', 'TA': 'தமிழ்'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AsyncView(
        load: context.repo.profile,
        builder: (context, profile, reload) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Avatar(name: profile.fullName ?? '?', size: 56, dark: false),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.fullName ?? 'Add your name',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          Text(prettyPhone(profile.phoneNumber ?? ''), style: const TextStyle(color: AppColors.muted)),
                          const SizedBox(height: 4),
                          const Row(children: [
                            Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
                            SizedBox(width: 4),
                            Text('Phone verified', style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600)),
                          ]),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (await _editName(context, profile.fullName)) await reload();
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(value: '${profile.bookingCount}', label: 'Bookings'),
                const SizedBox(width: 12),
                _Stat(value: '${profile.addressCount}', label: 'Addresses'),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_work_outlined),
                    title: const Text('Saved addresses'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/addresses'),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  const ListTile(
                    leading: Icon(Icons.payments_outlined),
                    title: Text('Payment methods'),
                    trailing: Text('Cash', style: TextStyle(color: AppColors.muted)),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/notifications'),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.support_agent_outlined),
                    title: const Text('Help & support'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/support'),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.translate_rounded),
                    title: const Text('Language'),
                    trailing: DropdownButton<String>(
                      value: profile.language,
                      underline: const SizedBox(),
                      items: [
                        for (final entry in _languages.entries)
                          DropdownMenuItem(value: entry.key, child: Text(entry.value)),
                      ],
                      onChanged: (value) async {
                        try {
                          await context.repo.updateProfile(language: value);
                          await reload();
                        } catch (error) {
                          if (context.mounted) context.showError(error);
                        }
                      },
                    ),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  const ListTile(
                    leading: Icon(Icons.description_outlined),
                    title: Text('Terms and privacy'),
                    trailing: Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
              onPressed: () => context.session.signOut(),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _editName(BuildContext context, String? current) async {
    final controller = TextEditingController(text: current);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Full name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                await context.repo.updateProfile(fullName: controller.text.trim());
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (context.mounted) context.showError(error);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    return saved == true;
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text(label, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ),
      );
}

/// Saved addresses (from Profile).
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved addresses')),
      body: AsyncView(
        load: context.repo.addresses,
        builder: (context, addresses, reload) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (addresses.isEmpty)
              const EmptyState(
                icon: Icons.home_work_outlined,
                title: 'No saved addresses',
                message: 'Addresses you use for bookings are saved here.',
              ),
            for (final address in addresses)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ListTile(
                    leading: Icon(address.label == 'OFFICE' ? Icons.business_rounded : Icons.home_rounded),
                    title: Text(address.labelText + (address.isDefault ? ' · Default' : ''),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${address.address.oneLine}\n${address.address.city}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () async {
                        try {
                          await context.repo.deleteAddress(address.id);
                          await reload();
                        } catch (error) {
                          if (context.mounted) context.showError(error);
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
