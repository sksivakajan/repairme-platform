import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/api_client.dart';
import '../core/format.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/motion.dart';
import 'auth_screens.dart' show AuthLayout;

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// True for an empty address (it is optional) or one that looks like an email.
bool isValidOptionalEmail(String value) => value.isEmpty || _emailPattern.hasMatch(value);

/// First-time account setup, shown after the number is verified and only when
/// that number has no account yet.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _submitted = true);
    final first = _first.text.trim();
    final last = _last.text.trim();
    final email = _email.text.trim();
    if (first.isEmpty || last.isEmpty || !isValidOptionalEmail(email)) return;

    final repo = context.repo;
    final session = context.session;
    final l = context.l10n;
    try {
      // Record the versions of the documents the customer agreed to on the previous screen.
      final documents = await repo.legalDocuments();
      await repo.completeProfile(
        firstName: first,
        lastName: last,
        email: email,
        accepted: [for (final d in documents.where((d) => d.requiresAcceptance)) d.ref],
      );
    } on ApiException catch (error) {
      if (error.statusCode == 409) {
        session.profileCompleted(); // the account was already set up
        return;
      }
      throw UserMessage(error.statusCode == 0 ? l.networkError : l.createAccountError);
    }
    session.profileCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final phone = context.session.phoneNumber ?? '';
    return AuthLayout(
      title: l.completeYourProfile,
      subtitle: Text(l.completeProfileSub),
      children: [
        TextField(
          controller: _first,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.givenName],
          decoration: InputDecoration(
            labelText: '${l.firstName} *',
            errorText: _submitted && _first.text.trim().isEmpty ? l.firstNameRequired : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _last,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.familyName],
          decoration: InputDecoration(
            labelText: '${l.lastName} *',
            errorText: _submitted && _last.text.trim().isEmpty ? l.lastNameRequired : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            labelText: l.emailOptional,
            errorText: _submitted && !isValidOptionalEmail(_email.text.trim()) ? l.emailInvalid : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        VerifiedPhoneField(phone: phone),
        const SizedBox(height: 22),
        BusyButton(label: l.createAccount, onPressed: _create),
        const SizedBox(height: 4),
        TextButton(onPressed: () => context.session.signOut(), child: Text(l.changeNumber)),
      ],
    );
  }
}

/// A read-only mobile number with its "Verified" tick.
class VerifiedPhoneField extends StatelessWidget {
  const VerifiedPhoneField({super.key, required this.phone, this.trailing});

  final String phone;

  /// Replaces the "Verified" tick, e.g. with a Change link.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InputDecorator(
      decoration: InputDecoration(labelText: l.mobileNumber),
      child: Row(
        children: [
          Expanded(
            child: Text(prettyPhone(phone), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 18, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(l.verifiedBadge, style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
        ],
      ),
    );
  }
}

/// Shown when the app can't ask the server whether this number has an account.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.muted),
                const SizedBox(height: 16),
                Text(l.offlineTitle, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(l.offlineBody, style: TextStyle(color: AppColors.muted), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: BusyButton(label: l.tryAgain, onPressed: () => context.session.resolveAccount()),
                ),
                TextButton(onPressed: () => context.session.signOut(), child: Text(l.logOutAction)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when the customer has not accepted the current Terms & Conditions and
/// Privacy Policy (existing customers, or after the documents change). Nothing
/// else in the app is reachable until they accept.
class AcceptTermsScreen extends StatefulWidget {
  const AcceptTermsScreen({super.key});

  @override
  State<AcceptTermsScreen> createState() => _AcceptTermsScreenState();
}

class _AcceptTermsScreenState extends State<AcceptTermsScreen> {
  late final _termsTap = TapGestureRecognizer()..onTap = () => context.push('/legal/terms');
  late final _privacyTap = TapGestureRecognizer()..onTap = () => context.push('/legal/privacy');
  bool _accepted = false;

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    final repo = context.repo;
    final session = context.session;
    final l = context.l10n;
    try {
      final profile = await repo.profile();
      await repo.acceptLegal(profile.pendingLegal);
    } on ApiException catch (error) {
      throw UserMessage(error.statusCode == 0 ? l.networkError : l.acceptError);
    }
    session.termsAccepted();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final link = TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, decoration: TextDecoration.underline);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            const Center(child: FadeSlideIn(pop: true, end: 0.6, child: RepairMeLogo(size: 84))),
            const SizedBox(height: 24),
            FadeSlideIn(
              begin: 0.2,
              end: 0.8,
              child: Text(l.acceptTermsTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              begin: 0.3,
              end: 0.9,
              child: Text(l.acceptTermsBody, style: TextStyle(color: AppColors.muted, height: 1.45), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 28),
            Card(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _accepted,
                onChanged: (value) => setState(() => _accepted = value ?? false),
                title: Text.rich(
                  TextSpan(
                    text: l.acceptPrefix,
                    children: [
                      TextSpan(text: l.termsAndConditions, style: link, recognizer: _termsTap),
                      TextSpan(text: l.acceptMiddle),
                      TextSpan(text: l.privacyPolicy, style: link, recognizer: _privacyTap),
                      TextSpan(text: l.acceptSuffix),
                    ],
                  ),
                  style: const TextStyle(height: 1.45),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BusyButton(label: l.acceptContinue, onPressed: _accepted ? _accept : null),
            const SizedBox(height: 4),
            TextButton(onPressed: () => context.session.signOut(), child: Text(l.logOutAction)),
          ],
        ),
      ),
    );
  }
}
