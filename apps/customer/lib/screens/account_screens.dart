import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/api_client.dart';
import '../core/format.dart';
import '../data/models.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/otp_input.dart';
import 'auth_screens.dart' show SriLankaPhoneFormatter;

// ─── Change mobile number ────────────────────────────────────────────────────

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _phone = TextEditingController();
  String? _e164;
  String _code = '';
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l = context.l10n;
    final e164 = toSriLankaE164(_phone.text);
    if (e164 == null) {
      setState(() => _error = l.phoneInvalid);
      return;
    }
    if (e164 == context.session.phoneNumber) {
      setState(() => _error = l.sameNumber);
      return;
    }
    await context.session.sendVerification(e164);
    if (mounted) {
      setState(() {
        _error = null;
        _e164 = e164;
        _code = '';
      });
    }
  }

  Future<void> _verify() async {
    final session = context.session;
    final repo = context.repo;
    final l = context.l10n;
    final newPhone = _e164!;
    await session.confirmVerification(_code, newPhone: newPhone);
    try {
      await repo.changePhone(newPhone);
    } on ApiException catch (error) {
      throw UserMessage(switch (error.statusCode) {
        0 => l.networkError,
        409 => l.authPhoneInUse,
        _ => l.profileUpdateError,
      });
    }
    await session.adoptPhone(newPhone);
    if (!mounted) return;
    context.toast(l.numberChanged);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final verifying = _e164 != null;
    return Scaffold(
      appBar: AppBar(title: Text(verifying ? l.verifyNewNumber : l.changeMobileNumber)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (!verifying) ...[
            Text(l.enterNewNumber, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l.changeNumberNote, style: TextStyle(color: AppColors.muted, height: 1.4)),
            const SizedBox(height: 20),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              autofocus: true,
              inputFormatters: [SriLankaPhoneFormatter()],
              decoration: InputDecoration(labelText: l.mobileNumber, prefixText: '+94  ', errorText: _error, hintText: '77 123 4567'),
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 20),
            BusyButton(label: l.sendCode, trailingIcon: Icons.arrow_forward_rounded, onPressed: _sendCode),
          ] else ...[
            Text(l.sentCodeTo, style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 2),
            Text(prettyPhone(_e164!), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            OtpInput(onChanged: (value) => setState(() => _code = value)),
            const SizedBox(height: 20),
            BusyButton(
              label: l.verify,
              onPressed: _code.length == OtpInput.length ? _verify : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () => context.session.sendVerification(_e164!), child: Text(l.resendCode)),
                TextButton(onPressed: () => setState(() => _e164 = null), child: Text(l.changeNumber)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Notification preferences ────────────────────────────────────────────────

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notificationPreferences)),
      body: AsyncView<Profile>(
        load: context.repo.profile,
        builder: (context, profile, reload) => _PreferencesList(initial: profile.notificationPreferences),
      ),
    );
  }
}

class _PreferencesList extends StatefulWidget {
  const _PreferencesList({required this.initial});

  final NotificationPrefs initial;

  @override
  State<_PreferencesList> createState() => _PreferencesListState();
}

class _PreferencesListState extends State<_PreferencesList> {
  late NotificationPrefs _prefs = widget.initial;

  Future<void> _change(NotificationPrefs next) async {
    final previous = _prefs;
    final repo = context.repo;
    setState(() => _prefs = next);
    try {
      await repo.saveNotificationPreferences(next);
    } catch (error) {
      if (!mounted) return;
      setState(() => _prefs = previous);
      context.showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget row(String title, String subtitle, bool value, NotificationPrefs Function(bool) update) => SwitchListTile(
          value: value,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          activeTrackColor: AppColors.ink,
          onChanged: (on) => _change(update(on)),
        );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Column(
            children: [
              row(l.notifBooking, l.notifBookingSub, _prefs.bookingUpdates, (on) => _prefs.copyWith(bookingUpdates: on)),
              const Divider(indent: 16, endIndent: 16),
              row(l.notifReminders, l.notifRemindersSub, _prefs.serviceReminders, (on) => _prefs.copyWith(serviceReminders: on)),
              const Divider(indent: 16, endIndent: 16),
              row(l.notifPayments, l.notifPaymentsSub, _prefs.paymentUpdates, (on) => _prefs.copyWith(paymentUpdates: on)),
              const Divider(indent: 16, endIndent: 16),
              row(l.notifOffers, l.notifOffersSub, _prefs.offers, (on) => _prefs.copyWith(offers: on)),
              const Divider(indent: 16, endIndent: 16),
              row(l.notifUpdates, l.notifUpdatesSub, _prefs.repairmeUpdates, (on) => _prefs.copyWith(repairmeUpdates: on)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.muted),
            const SizedBox(width: 8),
            Expanded(child: Text(l.notifEssentialNote, style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4))),
          ],
        ),
      ],
    );
  }
}

// ─── Delete account ──────────────────────────────────────────────────────────

/// What the customer chose on the first delete screen, carried to the next two.
class DeleteRequest {
  const DeleteRequest(this.reason, this.details);

  final String reason;
  final String details;
}

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _details = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reasons = [
      ('NO_LONGER_NEEDED', l.delReasonNoNeed),
      ('PRIVACY_CONCERNS', l.delReasonPrivacy),
      ('BAD_EXPERIENCE', l.delReasonBadExperience),
      ('ANOTHER_ACCOUNT', l.delReasonAnotherAccount),
      ('TOO_MANY_NOTIFICATIONS', l.delReasonNotifications),
      ('SERVICES_NOT_FOUND', l.delReasonServices),
      ('OTHER', l.otherLabel),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.deleteAccount)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.deleteTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(l.deleteIntro, style: TextStyle(color: AppColors.inkSoft, height: 1.45)),
          SectionTitle(l.whyLeaving),
          Card(
            child: Column(
              children: [
                for (final (i, (value, label)) in reasons.indexed) ...[
                  if (i > 0) const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    title: Text(label),
                    trailing: Icon(_reason == value ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
                    onTap: () => setState(() => _reason = value),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _details,
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.tellUsMoreLabel, alignLabelWithHint: true),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: Text(l.cancel))),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _reason == null
                      ? null
                      : () => context.push('/settings/delete/confirm', extra: DeleteRequest(_reason!, _details.text.trim())),
                  child: Text(l.continueToDelete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeleteConfirmScreen extends StatefulWidget {
  const DeleteConfirmScreen({super.key, required this.request});

  final DeleteRequest request;

  @override
  State<DeleteConfirmScreen> createState() => _DeleteConfirmScreenState();
}

class _DeleteConfirmScreenState extends State<DeleteConfirmScreen> {
  bool _understood = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget bullet(String text) => Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(top: 6, right: 10), child: Icon(Icons.circle, size: 6, color: AppColors.danger)),
              Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l.deleteAccount)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(l.permanentWarningTitle, style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800, fontSize: 17)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(l.deleteWillRemove),
                bullet(l.delRemoveProfile),
                bullet(l.delRemoveAddresses),
                bullet(l.delRemovePrefs),
                const SizedBox(height: 12),
                Text(l.delKeepNote, style: TextStyle(color: AppColors.inkSoft, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _understood,
            title: Text(l.delConfirmCheck),
            onChanged: (value) => setState(() => _understood = value ?? false),
          ),
          const SizedBox(height: 12),
          BusyButton(
            label: l.verifyAndDelete,
            color: AppColors.danger,
            textColor: Colors.white,
            onPressed: !_understood
                ? null
                : () async {
                    final session = context.session;
                    final router = GoRouter.of(context);
                    await session.sendVerification(session.phoneNumber!);
                    router.push('/settings/delete/otp', extra: widget.request);
                  },
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => context.go('/profile/personal'), child: Text(l.cancel)),
        ],
      ),
    );
  }
}

class DeleteOtpScreen extends StatefulWidget {
  const DeleteOtpScreen({super.key, required this.request});

  final DeleteRequest request;

  @override
  State<DeleteOtpScreen> createState() => _DeleteOtpScreenState();
}

class _DeleteOtpScreenState extends State<DeleteOtpScreen> {
  String _code = '';

  Future<void> _delete() async {
    final session = context.session;
    final repo = context.repo;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    // Proves it is really the customer, which the server requires.
    await session.confirmVerification(_code);
    try {
      await repo.deleteAccount(widget.request.reason, widget.request.details);
    } on ApiException catch (error) {
      throw UserMessage(switch (error.statusCode) {
        0 => l.networkError,
        409 => l.deleteActiveBookings,
        _ => l.deleteError,
      });
    }
    // Signing out sends the app back to the welcome screen.
    await session.signOut();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.accountDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final phone = context.session.phoneNumber ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l.deleteOtpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.deleteOtpBody(prettyPhone(phone)), style: TextStyle(color: AppColors.inkSoft, height: 1.45)),
          const SizedBox(height: 20),
          OtpInput(onChanged: (value) => setState(() => _code = value)),
          const SizedBox(height: 20),
          BusyButton(
            label: l.deleteAccountAction,
            color: AppColors.danger,
            textColor: Colors.white,
            onPressed: _code.length == OtpInput.length ? _delete : null,
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(onPressed: () => context.session.sendVerification(phone), child: Text(l.resendCode)),
          ),
        ],
      ),
    );
  }
}

// ─── Membership ──────────────────────────────────────────────────────────────

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.membershipTitle)),
      body: AsyncView<Profile>(
        load: context.repo.profile,
        builder: (context, profile, reload) {
          final since = profile.memberSince;
          final benefits = [l.benefit1, l.benefit2, l.benefit3, l.benefit4, l.benefit5, l.benefit6];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFCB2F), Color(0xFFFFB703)],
                  ),
                ),
                child: OnYellow(
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                        child: const Icon(Icons.workspace_premium_rounded, color: AppColors.yellow, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.currentPlan, style: const TextStyle(fontSize: 13)),
                            Text(l.standardMember, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                            if (since != null)
                              Text(
                                '${l.memberSince}: ${DateFormat('d MMMM y', locale).format(since.toLocal())}',
                                style: const TextStyle(fontSize: 13),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SectionTitle(l.yourBenefits),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      for (final benefit in benefits)
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.check_circle_rounded, color: AppColors.success),
                          title: Text(benefit),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(l.membershipSoon, style: TextStyle(color: AppColors.muted)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Payment methods ─────────────────────────────────────────────────────────

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget method({
      required IconData icon,
      required String title,
      required String subtitle,
      required bool selected,
      String? badge,
      bool disabled = false,
    }) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Opacity(
            opacity: disabled ? 0.6 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? AppColors.ink : AppColors.line, width: selected ? 2 : 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(icon),
                title: Row(
                  children: [
                    Flexible(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Pill(label: badge, background: AppColors.yellow, foreground: AppColors.black),
                    ],
                  ],
                ),
                subtitle: Text(subtitle),
                trailing: selected ? Icon(Icons.check_circle_rounded, color: AppColors.success) : null,
              ),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.paymentMethods)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          method(icon: Icons.payments_outlined, title: l.cash, subtitle: l.cashDesc, selected: true, badge: l.defaultBadge),
          method(icon: Icons.credit_card_rounded, title: l.cardOnline, subtitle: l.cardOnlineDesc, selected: false, disabled: true),
          const SizedBox(height: 6),
          OutlinedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(dialogContext.l10n.paymentSoonTitle),
                content: Text(dialogContext.l10n.paymentSoonBody),
                actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(dialogContext.l10n.okLabel))],
              ),
            ),
            child: Text(l.addPaymentMethod),
          ),
        ],
      ),
    );
  }
}
