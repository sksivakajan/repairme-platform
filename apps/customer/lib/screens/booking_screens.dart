import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'tab_screens.dart' show showNewTicketSheet;

const _livePollInterval = Duration(seconds: 5);
const _terminal = {'PAID', 'CANCELLED'};

/// Keeps a booking fresh by polling while it is active (push comes with FCM).
mixin _LiveBooking<T extends StatefulWidget> on State<T> {
  String get bookingId;
  BookingDetail? booking;
  Object? loadError;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    refresh();
    _timer = Timer.periodic(_livePollInterval, (_) {
      if (booking == null || !_terminal.contains(booking!.status)) refresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      final next = await context.repo.booking(bookingId);
      if (mounted) setState(() => (booking = next, loadError = null));
    } catch (error) {
      if (mounted) setState(() => loadError = error);
    }
  }

  void apply(BookingDetail next) => setState(() => booking = next);
}

/// The live booking screen. Shows C13 (finding), C14 (operator assigning),
/// C15 (assigned / on the way) or C17 (job status) depending on status.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.id});

  final String id;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with _LiveBooking {
  @override
  String get bookingId => widget.id;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    if (b == null) {
      return Scaffold(
        appBar: AppBar(),
        body: loadError != null
            ? ErrorState(error: loadError!, onRetry: refresh)
            : const Center(child: CircularProgressIndicator(color: AppColors.ink)),
      );
    }
    final Widget body = switch (b.status) {
      'SEARCHING' || 'OPERATOR_ASSIGNING' => _FindingView(booking: b, onChanged: apply),
      'ASSIGNED' || 'EN_ROUTE' => _AssignedView(booking: b, onChanged: apply, onRefresh: refresh),
      _ => _JobStatusView(booking: b, onRefresh: refresh),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (b.status) {
          'SEARCHING' => 'Finding a technician',
          'OPERATOR_ASSIGNING' => 'Team is assigning',
          'ASSIGNED' || 'EN_ROUTE' => 'Technician assigned',
          'CANCELLED' => 'Cancelled request',
          _ => 'Job status',
        }),
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/home')),
      ),
      body: RefreshIndicator(onRefresh: refresh, child: body),
    );
  }
}

// ─── C13 / C14 · Finding a technician ────────────────────────────────────────

class _FindingView extends StatelessWidget {
  const _FindingView({required this.booking, required this.onChanged});

  final BookingDetail booking;
  final ValueChanged<BookingDetail> onChanged;

  @override
  Widget build(BuildContext context) {
    final operator = booking.status == 'OPERATOR_ASSIGNING';
    final steps = operator
        ? [
            ('Request received', true),
            ('No technician accepted', true),
            ('RepairMe team assigning', false),
            ('Technician confirms', false),
          ]
        : [('Request received', true), ('Matching technicians nearby', false), ('Technician confirms', false)];
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MapPanel(area: booking.addressArea, height: 230, overlay: const Positioned.fill(child: _Pulse())),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request #${booking.reference}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                operator ? 'Our team is finding someone for you' : 'Finding a verified ${booking.categoryName.toLowerCase()} technician',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                operator
                    ? 'No technician accepted yet, so a RepairMe operator is assigning one for you. Usually under 2 minutes.'
                    : booking.type == BookingType.emergency
                        ? 'Matching you with technicians near ${booking.addressArea}.'
                        : 'We are confirming a technician for ${formatWindow(booking.scheduledStart ?? booking.createdAt, booking.scheduledEnd ?? booking.createdAt)}.',
                style: const TextStyle(color: AppColors.inkSoft, height: 1.4),
              ),
              const SizedBox(height: 20),
              for (final (i, (label, done)) in steps.indexed)
                _TimelineRow(label: label, done: done, active: !done && (i == 0 || steps[i - 1].$2), last: i == steps.length - 1),
              if (!operator) ...[
                const SizedBox(height: 12),
                const Text('If nobody accepts, the RepairMe team assigns a technician for you.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              if (booking.canCancel)
                OutlinedButton(
                  onPressed: () => showCancelSheet(context, booking, onChanged),
                  child: const Text('Cancel request'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse();

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Center(
          child: Container(
            width: 40 + 160 * _controller.value,
            height: 40 + 160 * _controller.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.yellow.withValues(alpha: 0.45 * (1 - _controller.value)),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.label, required this.done, this.active = false, this.last = false, this.detail});

  final String label;
  final bool done;
  final bool active;
  final bool last;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.ink : (active ? AppColors.yellow : AppColors.surface),
                  border: Border.all(color: done || active ? AppColors.ink : AppColors.line, width: 2),
                ),
                child: done ? const Icon(Icons.check_rounded, size: 14, color: AppColors.yellow) : null,
              ),
              if (!last) Expanded(child: Container(width: 2, color: done ? AppColors.ink : AppColors.line)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontWeight: done || active ? FontWeight.w700 : FontWeight.w500,
                        color: done || active ? AppColors.ink : AppColors.muted,
                      )),
                  if (detail != null) Text(detail!, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── C26 · Cancel request ────────────────────────────────────────────────────

Future<void> showCancelSheet(BuildContext context, BookingDetail booking, ValueChanged<BookingDetail> onChanged) async {
  const reasons = [
    ('FOUND_SOMEONE_ELSE', 'Found someone else'),
    ('PROBLEM_FIXED', 'Problem is fixed'),
    ('WAITING_TOO_LONG', 'Waiting too long'),
    ('OTHER', 'Other'),
  ];
  String? reason;
  final details = TextEditingController();
  final noTechnician = booking.technician == null;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Cancel this request?', style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              noTechnician
                  ? 'No charge, since no technician has been assigned yet.'
                  : 'No charge, since ${booking.technician!.firstName} has not arrived yet.',
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 12),
            for (final (value, label) in reasons)
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: value,
                groupValue: reason,
                activeColor: AppColors.ink,
                title: Text(label),
                onChanged: (v) => setSheetState(() => reason = v),
              ),
            if (reason == 'OTHER')
              TextField(controller: details, decoration: const InputDecoration(hintText: 'Tell us more (optional)')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.pop(sheetContext), child: const Text('Keep waiting')),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BusyButton(
                    label: 'Cancel request',
                    color: AppColors.danger,
                    onPressed: reason == null
                        ? null
                        : () async {
                            final updated = await context.repo.cancel(booking.id, reason!, details: details.text.trim());
                            onChanged(updated);
                            if (sheetContext.mounted) Navigator.pop(sheetContext);
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── C15 · Technician assigned / on the way ─────────────────────────────────

class _AssignedView extends StatelessWidget {
  const _AssignedView({required this.booking, required this.onChanged, required this.onRefresh});

  final BookingDetail booking;
  final ValueChanged<BookingDetail> onChanged;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final tech = booking.technician!;
    final onTheWay = booking.status == 'EN_ROUTE';
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MapPanel(
          area: booking.addressArea,
          height: 220,
          overlay: booking.etaMinutes == null
              ? null
              : Positioned(
                  left: 16,
                  top: 16,
                  child: Pill(label: 'ETA ${booking.etaMinutes} MIN', background: AppColors.ink, foreground: AppColors.yellow),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: onTheWay
                    ? const Pill(label: 'ON THE WAY', background: AppColors.yellow, foreground: AppColors.ink)
                    : StatusPill(status: booking.status, type: booking.type),
              ),
              const SizedBox(height: 10),
              Text(
                onTheWay
                    ? '${tech.firstName} is on the way'
                    : booking.scheduledStart != null
                        ? '${tech.firstName} will visit ${formatWindow(booking.scheduledStart!, booking.scheduledEnd!)}'
                        : '${tech.firstName} accepted your request',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (onTheWay && booking.etaMinutes != null)
                Text('Arrives in about ${booking.etaMinutes} min', style: const TextStyle(color: AppColors.inkSoft)),
              const SizedBox(height: 16),
              TechnicianCard(technician: tech, categoryName: booking.categoryName),
              const SizedBox(height: 12),
              if (booking.jobCode != null) JobCodeCard(code: booking.jobCode!, technicianName: tech.firstName),
              const SizedBox(height: 16),
              ChatButton(booking: booking, onReturn: onRefresh),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.push('/booking/${booking.id}/status'),
                child: const Text('View job status'),
              ),
              if (booking.canCancel)
                TextButton(
                  onPressed: () => showCancelSheet(context, booking, onChanged),
                  child: const Text('Cancel booking', style: TextStyle(color: AppColors.danger)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class TechnicianCard extends StatelessWidget {
  const TechnicianCard({super.key, required this.technician, required this.categoryName});

  final Technician technician;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Avatar(name: technician.displayName, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(technician.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Row(children: [
                    const Icon(Icons.verified_rounded, size: 15, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('Verified ${categoryName.toLowerCase()} technician',
                        style: const TextStyle(color: AppColors.inkSoft, fontSize: 13)),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5A300)),
                    const SizedBox(width: 2),
                    Text(
                      '${technician.rating?.toStringAsFixed(1) ?? 'New'} · ${technician.jobsCompleted} jobs',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCodeCard extends StatelessWidget {
  const JobCodeCard({super.key, required this.code, required this.technicianName});

  final String code;
  final String technicianName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Text('Job code · share only when $technicianName arrives',
                style: const TextStyle(color: Color(0xFFBDBBB3), fontSize: 13)),
          ),
          Text(code,
              style: const TextStyle(color: AppColors.yellow, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 6)),
        ],
      ),
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({super.key, required this.booking, required this.onReturn});

  final BookingDetail booking;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    if (!booking.canChat) return const SizedBox.shrink();
    return FilledButton.icon(
      style: FilledButton.styleFrom(backgroundColor: AppColors.yellow, foregroundColor: AppColors.ink),
      onPressed: () async {
        await context.push('/booking/${booking.id}/chat');
        await onReturn();
      },
      icon: Badge(
        isLabelVisible: booking.unreadMessages > 0,
        label: Text('${booking.unreadMessages}'),
        child: const Icon(Icons.chat_bubble_outline_rounded),
      ),
      label: Text('Message ${booking.technician!.firstName}'),
    );
  }
}

// ─── C17 · Job status ────────────────────────────────────────────────────────

class _JobStatusView extends StatelessWidget {
  const _JobStatusView({required this.booking, required this.onRefresh});

  final BookingDetail booking;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final pending = b.pendingQuotation;
    final techName = b.technician?.firstName ?? 'Technician';
    String? at(String status) {
      final time = b.eventAt(status);
      return time == null ? null : '${formatDay(time)}, ${formatTime(time)}';
    }

    final order = ['SEARCHING', 'ASSIGNED', 'EN_ROUTE', 'ARRIVED', 'AWAITING_APPROVAL', 'COMPLETED', 'PAID'];
    final reached = b.status == 'IN_PROGRESS' ? order.indexOf('AWAITING_APPROVAL') : order.indexOf(b.status);
    bool done(String status) => order.indexOf(status) <= reached && reached >= 0;

    final before = b.photos.where((p) => p.kind == 'BEFORE').toList();
    final after = b.photos.where((p) => p.kind == 'AFTER').toList();
    final problem = b.photos.where((p) => p.kind == 'PROBLEM').toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Job #${b.reference}', style: Theme.of(context).textTheme.headlineSmall),
        Text('${b.categoryName} · ${bookingTypeLabel(b.type)}', style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 16),
        if (pending != null)
          _ActionBanner(
            title: 'Cost ready for your approval',
            body: '$techName sent ${formatLkr(pending.totalCents)} · Tap to review',
            onTap: () async {
              await context.push('/booking/${b.id}/cost');
              await onRefresh();
            },
          ),
        if (b.status == 'COMPLETED')
          _ActionBanner(
            title: 'Repair completed',
            body: 'Pay ${formatLkr(b.payment?.amountCents ?? 0)} to $techName',
            onTap: () async {
              await context.push('/booking/${b.id}/payment');
              await onRefresh();
            },
          ),
        if (b.status == 'PAID')
          _ActionBanner(
            title: 'Payment received',
            body: b.rating == null ? 'View receipt and rate $techName' : 'View receipt',
            onTap: () => context.push('/booking/${b.id}/receipt'),
          ),
        if (b.status == 'CANCELLED')
          Card(
            child: ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('This booking was cancelled', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(b.cancelledBy == 'CUSTOMER' ? 'Cancelled by you · no charge' : 'Cancelled by RepairMe'),
            ),
          ),
        const SizedBox(height: 16),
        if (b.status != 'CANCELLED') ...[
          _TimelineRow(label: 'Request created', done: true, detail: at('SEARCHING')),
          _TimelineRow(label: 'Technician accepted', done: done('ASSIGNED'),
              detail: b.technician == null ? null : '${b.technician!.displayName} · ${at('ASSIGNED') ?? ''}'),
          _TimelineRow(label: 'On the way', done: done('EN_ROUTE'), detail: at('EN_ROUTE')),
          _TimelineRow(label: 'Arrived', done: done('ARRIVED'),
              detail: done('ARRIVED') ? 'Job code verified · ${at('ARRIVED') ?? ''}' : null),
          _TimelineRow(
            label: 'Working',
            done: done('AWAITING_APPROVAL'),
            active: b.status == 'ARRIVED' || b.status == 'IN_PROGRESS',
            detail: b.status == 'IN_PROGRESS'
                ? 'Cost approved, work under way'
                : (pending != null ? 'Inspection done, cost sent' : null),
          ),
          _TimelineRow(label: 'Completed', done: done('COMPLETED'), detail: at('COMPLETED')),
          _TimelineRow(label: 'Pay and rate', done: done('PAID'), last: true, detail: at('PAID')),
        ],
        if (b.technician != null) ...[
          const SizedBox(height: 8),
          TechnicianCard(technician: b.technician!, categoryName: b.categoryName),
          const SizedBox(height: 12),
          ChatButton(booking: b, onReturn: onRefresh),
        ],
        if (problem.isNotEmpty) PhotoStrip(title: 'Your photos', bookingId: b.id, photos: problem),
        if (before.isNotEmpty) PhotoStrip(title: 'Before photos by $techName', bookingId: b.id, photos: before),
        if (after.isNotEmpty) PhotoStrip(title: 'After photos', bookingId: b.id, photos: after),
        const SectionTitle('Request'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(b.description),
                const SizedBox(height: 8),
                Text(b.address.oneLine, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => showNewTicketSheet(context, bookingId: b.id, subject: 'Problem with ${b.reference}'),
          icon: const Icon(Icons.flag_outlined),
          label: const Text('Report a problem with this job'),
        ),
      ],
    );
  }
}

class _ActionBanner extends StatelessWidget {
  const _ActionBanner({required this.title, required this.body, required this.onTap});

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(body),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoStrip extends StatelessWidget {
  const PhotoStrip({super.key, required this.title, required this.bookingId, required this.photos});

  final String title;
  final String bookingId;
  final List<BookingPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => _RemotePhoto(bookingId: bookingId, photoId: photos[i].id),
          ),
        ),
      ],
    );
  }
}

class _RemotePhoto extends StatefulWidget {
  const _RemotePhoto({required this.bookingId, required this.photoId});

  final String bookingId;
  final String photoId;

  @override
  State<_RemotePhoto> createState() => _RemotePhotoState();
}

class _RemotePhotoState extends State<_RemotePhoto> {
  late final Future<Uint8List> _bytes = context.repo.photoBytes(widget.bookingId, widget.photoId);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 96,
        height: 96,
        child: FutureBuilder<Uint8List>(
          future: _bytes,
          builder: (context, snapshot) => snapshot.hasData
              ? Image.memory(snapshot.data!, fit: BoxFit.cover)
              : Container(color: AppColors.line, child: const Icon(Icons.image_outlined, color: AppColors.muted)),
        ),
      ),
    );
  }
}

/// Opens the job status (C17) directly, e.g. from C15.
class JobStatusScreen extends StatefulWidget {
  const JobStatusScreen({super.key, required this.id});

  final String id;

  @override
  State<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends State<JobStatusScreen> with _LiveBooking {
  @override
  String get bookingId => widget.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job status')),
      body: booking == null
          ? (loadError != null
              ? ErrorState(error: loadError!, onRetry: refresh)
              : const Center(child: CircularProgressIndicator(color: AppColors.ink)))
          : RefreshIndicator(onRefresh: refresh, child: _JobStatusView(booking: booking!, onRefresh: refresh)),
    );
  }
}

// ─── C16 · Chat ──────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id});

  final String id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with _LiveBooking {
  @override
  String get bookingId => widget.id;

  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  Timer? _chatTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _chatTimer = Timer.periodic(const Duration(seconds: 4), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _chatTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await context.repo.messages(widget.id);
      if (!mounted) return;
      final grew = messages.length != _messages.length;
      setState(() => _messages = messages);
      if (grew) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
        });
      }
    } catch (_) {}
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty) return;
    try {
      await context.repo.sendMessage(widget.id, text);
      if (preset == null) _input.clear();
      await _loadMessages();
    } catch (error) {
      if (mounted) context.showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final tech = b?.technician;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: tech == null
            ? const Text('Chat')
            : Row(
                children: [
                  Avatar(name: tech.displayName, size: 36),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tech.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(
                        b!.status == 'EN_ROUTE' && b.etaMinutes != null
                            ? 'On the way · ETA ${b.etaMinutes} min'
                            : statusStyle(b.status, b.type).label.toLowerCase(),
                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(12)),
            child: Text(
              'Messages are recorded for your safety. Never share your job code until ${tech?.firstName ?? 'the technician'} arrives.',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: m.mine ? AppColors.ink : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: m.mine ? null : Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(m.body, style: TextStyle(color: m.mine ? Colors.white : AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(
                          '${formatTime(m.createdAt)}${m.mine && m.readAt != null ? ' · Seen' : ''}',
                          style: TextStyle(fontSize: 11, color: m.mine ? const Color(0xFFBDBBB3) : AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (b?.canChat ?? false) ...[
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final quick in ['I am at home', 'Call me', 'Use the side gate'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(label: Text(quick), onPressed: () => _send(quick)),
                    ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(hintText: 'Message'),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: AppColors.ink, minimumSize: const Size(52, 52)),
                      onPressed: _send,
                      icon: const Icon(Icons.send_rounded, color: AppColors.yellow),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Chat is closed for this booking.', style: TextStyle(color: AppColors.muted)),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── C18 · Approve cost ──────────────────────────────────────────────────────

class CostApprovalScreen extends StatefulWidget {
  const CostApprovalScreen({super.key, required this.id});

  final String id;

  @override
  State<CostApprovalScreen> createState() => _CostApprovalScreenState();
}

class _CostApprovalScreenState extends State<CostApprovalScreen> with _LiveBooking {
  @override
  String get bookingId => widget.id;

  Future<void> _decide(Quotation quotation, bool approve) async {
    if (!approve) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Decline this cost?'),
          content: const Text('The technician will be told. Only the visit fee applies if no work is done.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Back')),
            TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Decline')),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    if (!mounted) return;
    await context.repo.decideQuotation(widget.id, quotation.id, approve: approve);
    if (mounted) {
      context.toast(approve ? 'Cost approved. Work continues.' : 'Cost declined');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final q = b?.pendingQuotation;
    return Scaffold(
      appBar: AppBar(title: const Text('Approve cost')),
      body: b == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.ink))
          : q == null
              ? const EmptyState(icon: Icons.task_alt_rounded, title: 'Nothing to approve right now')
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('#${b.reference}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('Total to approve', style: TextStyle(color: AppColors.inkSoft)),
                    Text(formatLkr(q.totalCents), style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    if (q.note != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Avatar(name: b.technician!.displayName, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Note from ${b.technician!.firstName}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(q.note!, style: const TextStyle(height: 1.4)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                        child: CostLines(
                          visitFeeCents: q.visitFeeCents,
                          labourCents: q.labourCents,
                          partsCents: q.partsCents,
                          totalCents: q.totalCents,
                          items: q.items,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Work starts only after you approve. If the cost changes, you will be asked again.',
                        style: TextStyle(color: AppColors.muted, height: 1.4)),
                  ],
                ),
      bottomNavigationBar: q == null
          ? null
          : BottomAction(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BusyButton(label: 'Approve ${formatLkr(q.totalCents)}', onPressed: () => _decide(q, true)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/booking/${widget.id}/chat'),
                          child: const Text('Ask a question'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                          onPressed: () => _decide(q, false),
                          child: const Text('Decline'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

// ─── C19 · Payment ───────────────────────────────────────────────────────────

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.id});

  final String id;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with _LiveBooking {
  @override
  String get bookingId => widget.id;

  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    if (b != null && b.status == 'PAID') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement('/booking/${b.id}/receipt');
      });
    }
    final payment = b?.payment;
    final quotation = b?.quotation?.status == 'APPROVED' ? b!.quotation : null;
    final completedAt = b?.eventAt('COMPLETED');

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: b == null || payment == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.ink))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('#${b.reference}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  'Repair completed by ${b.technician?.firstName ?? 'your technician'}'
                  '${completedAt == null ? '' : ' · ${formatTime(completedAt)}'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (b.photos.any((p) => p.kind == 'AFTER'))
                  PhotoStrip(title: 'After photos', bookingId: b.id, photos: b.photos.where((p) => p.kind == 'AFTER').toList()),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: quotation == null
                        ? CostLines(visitFeeCents: b.visitFeeCents, labourCents: 0, partsCents: 0, totalCents: payment.amountCents)
                        : CostLines(
                            visitFeeCents: quotation.visitFeeCents,
                            labourCents: quotation.labourCents,
                            partsCents: quotation.partsCents,
                            totalCents: payment.amountCents,
                          ),
                  ),
                ),
                const SectionTitle('Payment method'),
                _MethodTile(
                  icon: Icons.payments_outlined,
                  title: 'Cash',
                  subtitle: 'Pay ${b.technician?.firstName ?? 'the technician'} directly',
                  selected: true,
                ),
                const _MethodTile(icon: Icons.credit_card_rounded, title: 'Card', subtitle: 'Coming soon', selected: false, disabled: true),
                const _MethodTile(icon: Icons.qr_code_rounded, title: 'Mobile wallet', subtitle: 'Coming soon', selected: false, disabled: true),
                if (_confirmed) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                              'Hand ${formatLkr(payment.amountCents)} to ${b.technician?.firstName ?? 'the technician'}. '
                              'Your receipt appears as soon as they confirm.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
      bottomNavigationBar: payment == null || _confirmed
          ? null
          : BottomAction(
              child: BusyButton(
                label: 'Confirm payment · ${formatLkr(payment.amountCents)}',
                onPressed: () async {
                  final updated = await context.repo.choosePayment(widget.id, 'CASH');
                  apply(updated);
                  setState(() => _confirmed = true);
                },
              ),
            ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.icon, required this.title, required this.subtitle, required this.selected, this.disabled = false});

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AppColors.ink : AppColors.line, width: selected ? 2 : 1),
          ),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(subtitle),
            trailing: Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
          ),
        ),
      ),
    );
  }
}

// ─── C20 · Receipt ───────────────────────────────────────────────────────────

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/home')),
      ),
      body: AsyncView(
        load: () => context.repo.booking(id),
        builder: (context, b, reload) {
          final payment = b.payment!;
          final quotation = b.quotation?.status == 'APPROVED' ? b.quotation : null;
          final tech = b.technician!;
          return Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.yellow,
                        child: Icon(Icons.check_rounded, size: 38, color: AppColors.ink),
                      ),
                      const SizedBox(height: 12),
                      Text('Payment received', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text('${formatLkr(payment.amountCents)} paid in ${payment.method.toLowerCase()}',
                          style: const TextStyle(color: AppColors.inkSoft)),
                      Text('Receipt #${b.reference}', style: const TextStyle(color: AppColors.muted)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Avatar(name: tech.displayName),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tech.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text(
                                    '${b.categoryName}${payment.paidAt == null ? '' : ' · ${formatDay(payment.paidAt!)} · ${formatTime(payment.paidAt!)}'}',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        quotation == null
                            ? CostLines(visitFeeCents: b.visitFeeCents, labourCents: 0, partsCents: 0,
                                totalCents: payment.amountCents, totalLabel: 'Total paid')
                            : CostLines(
                                visitFeeCents: quotation.visitFeeCents,
                                labourCents: quotation.labourCents,
                                partsCents: quotation.partsCents,
                                totalCents: payment.amountCents,
                                items: quotation.items,
                                totalLabel: 'Total paid',
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(16)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_outlined),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '7-day workmanship cover\nIf the same fault returns, we send someone back at no labour cost.',
                          style: TextStyle(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => showNewTicketSheet(context, bookingId: b.id, subject: 'Problem with ${b.reference}'),
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Report a problem with this job'),
                ),
              ],
            ),
            bottomNavigationBar: b.rating != null
                ? BottomAction(
                    child: OutlinedButton(onPressed: () => context.go('/home'), child: Text('You rated ${tech.firstName} ${b.rating}★ · Done')),
                  )
                : BottomAction(
                    child: FilledButton(
                      onPressed: () async {
                        await context.push('/booking/${b.id}/rate');
                        await reload();
                      },
                      child: Text('Rate ${tech.firstName}'),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

// ─── C21 · Rating ────────────────────────────────────────────────────────────

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.id});

  final String id;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  static const _tags = [
    ('ON_TIME', 'On time'),
    ('PROFESSIONAL', 'Professional'),
    ('CLEAN_WORK', 'Clean work'),
    ('FAIR_PRICE', 'Fair price'),
    ('EXPLAINED_CLEARLY', 'Explained clearly'),
  ];
  static const _words = ['', 'Poor', 'Could be better', 'Good', 'Great', 'Excellent'];

  late final Future<BookingDetail> _booking = context.repo.booking(widget.id);
  int _rating = 0;
  final Set<String> _selected = {};
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate your experience'),
        actions: [TextButton(onPressed: () => context.pop(), child: const Text('Skip'))],
      ),
      body: FutureBuilder<BookingDetail>(
        future: _booking,
        builder: (context, snapshot) {
          final b = snapshot.data;
          if (b == null) return const Center(child: CircularProgressIndicator(color: AppColors.ink));
          final tech = b.technician!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(child: Avatar(name: tech.displayName, size: 72)),
              const SizedBox(height: 12),
              Center(child: Text('How was ${tech.firstName}?', style: Theme.of(context).textTheme.headlineSmall)),
              Center(child: Text('${b.categoryName} · ${b.title}', style: const TextStyle(color: AppColors.muted))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      iconSize: 44,
                      onPressed: () => setState(() => _rating = i),
                      icon: Icon(i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: i <= _rating ? const Color(0xFFF5A300) : AppColors.line),
                    ),
                ],
              ),
              Center(child: Text(_words[_rating], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
              const SectionTitle('What went well?'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (value, label) in _tags)
                    FilterChip(
                      label: Text(label),
                      selected: _selected.contains(value),
                      onSelected: (on) => setState(() => on ? _selected.add(value) : _selected.remove(value)),
                    ),
                ],
              ),
              const SectionTitle('Add a comment (optional)'),
              TextField(
                controller: _comment,
                minLines: 3,
                maxLines: 5,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'Tell others about the job'),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAction(
        child: BusyButton(
          label: 'Submit rating',
          onPressed: _rating == 0
              ? null
              : () async {
                  await context.repo.review(widget.id, _rating, _selected.toList(), _comment.text);
                  if (mounted) {
                    context.toast('Thank you for your rating!');
                    context.pop();
                  }
                },
        ),
      ),
    );
  }
}
