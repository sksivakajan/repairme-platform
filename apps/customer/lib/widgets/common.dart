import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../core/app_language.dart';
import '../core/appearance.dart';
import '../core/format.dart';
import '../core/session.dart';
import '../data/models.dart';
import '../data/repository.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'motion.dart';

/// Gives every screen access to the session, the API repository and the
/// appearance and language settings.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.session,
    required this.repo,
    required this.appearance,
    required this.language,
    required super.child,
  });

  final Session session;
  final Repository repo;
  final Appearance appearance;
  final AppLanguage language;

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      session != oldWidget.session || repo != oldWidget.repo || appearance != oldWidget.appearance ||
      language != oldWidget.language;
}

/// A message already written for the customer (in their language), to throw
/// from an action so the button shows it instead of a raw error.
class UserMessage implements Exception {
  const UserMessage(this.text);

  final String text;

  @override
  String toString() => text;
}

/// Server messages are English, so the ones that are about the connection or
/// the session are replaced with the customer's language.
String friendlyApiMessage(BuildContext context, ApiException error) {
  if (error.statusCode == 0) return context.l10n.networkError;
  if (error.isUnauthorized) return context.l10n.signInAgain;
  return error.message;
}

extension AppContext on BuildContext {
  Repository get repo => AppScope.of(this).repo;
  Session get session => AppScope.of(this).session;
  Appearance get appearance => AppScope.of(this).appearance;
  AppLanguage get language => AppScope.of(this).language;

  void showError(Object error) {
    final message = switch (error) {
      ApiException() => friendlyApiMessage(this, error),
      AuthError() => switch (error.issue) {
          AuthIssue.incorrectCodeDev => l10n.authIncorrectCodeDev(error.detail ?? ''),
          AuthIssue.requestNewCode => l10n.authRequestNewCode,
          AuthIssue.incorrectCode => l10n.authIncorrectCode,
          AuthIssue.invalidPhone => l10n.authInvalidPhone,
          AuthIssue.tooManyAttempts => l10n.authTooMany,
          AuthIssue.expired => l10n.authExpired,
          AuthIssue.phoneInUse => l10n.authPhoneInUse,
          AuthIssue.failed => l10n.authFailed,
        },
      _ => error.toString(),
    };
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void toast(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Content on a yellow background: always black text and icons, in both
/// light and dark mode.
class OnYellow extends StatelessWidget {
  const OnYellow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: AppColors.black),
      child: IconTheme.merge(data: const IconThemeData(color: AppColors.black), child: child),
    );
  }
}

/// Loads data with a spinner and an error state with retry.
class AsyncView<T> extends StatefulWidget {
  const AsyncView({super.key, required this.load, required this.builder});

  final Future<T> Function() load;
  final Widget Function(BuildContext context, T data, Future<void> Function() reload) builder;

  @override
  State<AsyncView<T>> createState() => _AsyncViewState<T>();
}

class _AsyncViewState<T> extends State<AsyncView<T>> {
  late Future<T> _future = widget.load();
  T? _last;

  Future<void> _reload() async {
    final next = widget.load();
    setState(() => _future = next);
    try {
      await next;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) _last = snapshot.data;
        final data = snapshot.data ?? _last;
        if (snapshot.hasError && data == null) {
          return ErrorState(error: snapshot.error!, onRetry: _reload);
        }
        if (data == null) {
          return const Center(child: LogoLoader());
        }
        return widget.builder(context, data, _reload);
      },
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (error is! ApiException) debugPrint('Unexpected error: $error');
    final message = error is ApiException
        ? friendlyApiMessage(context, error as ApiException)
        : context.l10n.somethingWentWrong;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            SizedBox(width: 160, child: OutlinedButton(onPressed: onRetry, child: Text(context.l10n.tryAgain))),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.message});

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(message!, style: TextStyle(color: AppColors.muted), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

IconData categoryIcon(String key) => switch (key) {
      'electrical' => Icons.bolt_rounded,
      'plumbing' => Icons.plumbing_rounded,
      'ac' => Icons.ac_unit_rounded,
      'fridge' => Icons.kitchen_rounded,
      'washing-machine' => Icons.local_laundry_service_rounded,
      'mechanic' => Icons.two_wheeler_rounded,
      'fan' => Icons.wind_power_rounded,
      'lock' => Icons.lock_rounded,
      _ => Icons.handyman_rounded,
    };

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.iconKey, this.size = 44, this.highlight = false});

  final String iconKey;
  final double size;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: highlight ? AppColors.yellow : AppColors.background,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(categoryIcon(iconKey), size: size * 0.52, color: highlight ? AppColors.black : AppColors.ink),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.name, this.size = 44, this.dark = true});

  final String name;
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: dark ? AppColors.solid : AppColors.yellow,
      child: Text(
        initials(name),
        style: TextStyle(
          color: dark ? AppColors.yellow : AppColors.black,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}

/// Booking status as the customer sees it (C22 tags).
({String label, Color background, Color foreground}) statusStyle(
  BuildContext context,
  String status,
  BookingType type,
) {
  final l = context.l10n;
  return switch (status) {
    'SEARCHING' => (label: l.statusFinding, background: AppColors.yellow, foreground: AppColors.black),
    'OPERATOR_ASSIGNING' => (label: l.statusAssigning, background: AppColors.yellow, foreground: AppColors.black),
    'ASSIGNED' => type == BookingType.emergency
        ? (label: l.statusAssigned, background: AppColors.yellowSoft, foreground: AppColors.ink)
        : (label: l.statusScheduled, background: const Color(0xFFE3EEFB), foreground: AppColors.info),
    'EN_ROUTE' => (label: l.statusOnTheWay, background: AppColors.yellow, foreground: AppColors.black),
    'ARRIVED' || 'AWAITING_APPROVAL' || 'IN_PROGRESS' =>
      (label: l.statusWorking, background: AppColors.solid, foreground: AppColors.yellow),
    'COMPLETED' => (label: l.statusPaymentDue, background: AppColors.yellow, foreground: AppColors.black),
    'PAID' => (label: l.statusCompleted, background: const Color(0xFFE2F3E8), foreground: AppColors.success),
    'CANCELLED' => (label: l.statusCancelled, background: AppColors.line, foreground: AppColors.muted),
    _ => (label: status, background: AppColors.line, foreground: AppColors.ink),
  };
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, required this.type});

  final String status;
  final BookingType type;

  @override
  Widget build(BuildContext context) {
    final style = statusStyle(context, status, type);
    return Pill(label: style.label, background: style.background, foreground: style.foreground);
  }
}

class Pill extends StatelessWidget {
  const Pill({super.key, required this.label, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: Localizations.localeOf(context).languageCode == 'en' ? 0.6 : 0,
        ),
      ),
    );
  }
}

/// Stand-in for the live map until Google Maps is integrated.
class MapPanel extends StatelessWidget {
  const MapPanel({super.key, required this.area, this.height = 220, this.overlay});

  final String area;
  final double height;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFEDEBE3),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 40, color: AppColors.black),
                const SizedBox(height: 4),
                Text(area.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, letterSpacing: 2, color: Color(0xFF3D3D3A))),
              ],
            ),
          ),
          ?overlay,
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.86, 0, size.width * 0.14, size.height),
      Paint()..color = const Color(0xFFCFE3EE),
    );
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 4;
    for (var i = 1; i < 6; i++) {
      canvas.drawLine(Offset(size.width * i / 6, 0), Offset(size.width * i / 6 + 20, size.height), minor);
    }
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.42, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.62), Offset(size.width * 0.86, size.height * 0.48), road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, required this.label, required this.title, this.subtitle});

  final int step;
  final String label;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: i < step ? AppColors.ink : AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(context.l10n.stepOf('$step', label),
            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, style: TextStyle(color: AppColors.muted)),
        ],
      ],
    );
  }
}

/// A primary action pinned to the bottom of the screen.
class BottomAction extends StatelessWidget {
  const BottomAction({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(top: false, child: child),
    );
  }
}

/// A filled button that shows a spinner while its async action runs.
class BusyButton extends StatefulWidget {
  const BusyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
    this.trailingIcon,
  });

  final String label;
  final Future<void> Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? trailingIcon;

  @override
  State<BusyButton> createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  bool _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } catch (error) {
      if (mounted) context.showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: widget.color == null
          ? null
          : FilledButton.styleFrom(backgroundColor: widget.color, foregroundColor: widget.textColor),
      onPressed: widget.onPressed == null || _busy ? null : _run,
      child: _busy
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: widget.textColor ?? Colors.white))
          : widget.trailingIcon == null
              ? Text(widget.label)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(widget.label), const SizedBox(width: 8), Icon(widget.trailingIcon, size: 20)],
                ),
    );
  }
}

class CostLines extends StatelessWidget {
  const CostLines({
    super.key,
    required this.visitFeeCents,
    required this.labourCents,
    required this.partsCents,
    required this.totalCents,
    this.items = const [],
    this.totalLabel,
  });

  final int visitFeeCents;
  final int labourCents;
  final int partsCents;
  final int totalCents;
  final List<QuotationItem> items;
  final String? totalLabel;

  @override
  Widget build(BuildContext context) {
    Widget line(String label, int cents, {bool bold = false, bool sub = false}) {
      final style = TextStyle(
        color: sub ? AppColors.muted : AppColors.ink,
        fontWeight: bold ? FontWeight.w800 : (sub ? FontWeight.w500 : FontWeight.w600),
        fontSize: bold ? 17 : (sub ? 13 : 15),
      );
      return Padding(
        padding: EdgeInsets.only(top: sub ? 4 : 10, left: sub ? 12 : 0),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            Text(context.lkr(cents), style: style),
          ],
        ),
      );
    }

    return Column(
      children: [
        line(context.l10n.visitFee, visitFeeCents),
        line(context.l10n.labour, labourCents),
        line(context.l10n.parts, partsCents),
        for (final item in items) line('${item.description} × ${item.quantity}', item.totalCents, sub: true),
        const Padding(padding: EdgeInsets.only(top: 12), child: Divider()),
        line(totalLabel ?? context.l10n.total, totalCents, bold: true),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
          ?trailing,
        ],
      ),
    );
  }
}
