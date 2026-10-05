import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/env.dart';
import '../core/format.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/language_chips.dart';
import '../widgets/motion.dart';

/// C02 · Onboarding.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.session.markOnboarded();
    if (mounted) context.go('/phone');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = [
      (icon: Icons.bolt_rounded, title: l.onboard1Title, body: l.onboard1Body),
      (
        icon: Icons.event_available_rounded,
        title: l.onboard2Title,
        body: l.onboard2Body,
      ),
      (
        icon: Icons.verified_user_rounded,
        title: l.onboard3Title,
        body: l.onboard3Body,
      ),
    ];
    final last = _page == _pageCount - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
              child: Row(
                children: [
                  const RepairMeLogo(size: 32),
                  const SizedBox(width: 8),
                  const Wordmark(fontSize: 20),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: Text(l.skip)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LanguageChips(),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  for (final page in pages)
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Icon(
                              page.icon,
                              size: 52,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            page.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page.body,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.inkSoft,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? AppColors.ink : AppColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton(
                onPressed: last
                    ? _finish
                    : () => _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                child: Text(last ? l.getStarted : l.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The yellow "Welcome to RepairMe" header of the sign-in screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFCB2F), Color(0xFFFFB703)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            left: -60,
            child: _circle(200, Colors.white.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: _circle(
              210,
              const Color(0xFFF2A100).withValues(alpha: 0.35),
            ),
          ),
          OnYellow(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: onBack == null
                            ? null
                            : IconButton(
                                onPressed: onBack,
                                color: AppColors.black,
                                icon: const Icon(Icons.arrow_back_rounded),
                                tooltip: context.l10n.back,
                              ),
                      ),
                    ),
                    const FadeSlideIn(
                      pop: true,
                      end: 0.55,
                      offset: Offset(0, 0.25),
                      child: AppIconBadge(size: 78),
                    ),
                    const SizedBox(height: 18),
                    FadeSlideIn(
                      begin: 0.25,
                      end: 0.75,
                      child: Text(
                        context.l10n.welcomeToRepairMe,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: AppFonts.indic ? 0 : -0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FadeSlideIn(
                      begin: 0.35,
                      end: 0.85,
                      child: Text(
                        context.l10n.homeRepairsSimple,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3D3D3A),
                        ),
                      ),
                    ),
                    if (onBack == null) ...[
                      const SizedBox(height: 16),
                      const FadeSlideIn(
                        begin: 0.5,
                        end: 1,
                        offset: Offset(0, 0.3),
                        child: LanguageChips(onYellow: true),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onBack,
  });

  final String title;
  final Widget subtitle;
  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            AuthHeader(onBack: onBack),
            FadeSlideIn(
              begin: 0.45,
              end: 1,
              offset: const Offset(0, 0.04),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                      child: subtitle,
                    ),
                    const SizedBox(height: 18),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevLoginHint extends StatelessWidget {
  const _DevLoginHint();

  @override
  Widget build(BuildContext context) {
    if (Env.useFirebase) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 18),
      child: Center(
        child: Pill(
          label: 'DEVELOPMENT LOGIN · CODE ${Env.devOtpCode}',
          background: AppColors.yellowSoft,
          foreground: AppColors.inkSoft,
        ),
      ),
    );
  }
}

/// C03 · Phone number.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String? _phone;
  late final _termsTap = TapGestureRecognizer()
    ..onTap = () => context.push('/legal/terms');
  late final _privacyTap = TapGestureRecognizer()
    ..onTap = () => context.push('/legal/privacy');

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await context.session.sendCode(_phone!);
    if (mounted) context.push('/otp');
  }

  @override
  Widget build(BuildContext context) {
    final active = _focus.hasFocus || _controller.text.isNotEmpty;
    final link = TextStyle(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    return AuthLayout(
      title: context.l10n.enterMobileToContinue,
      subtitle: const SizedBox.shrink(),
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? AppColors.ink : AppColors.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text('🇱🇰', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                '+94',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 28, color: AppColors.line),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [SriLankaPhoneFormatter()],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  decoration: const InputDecoration(
                    hintText: '77 123 4567',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                  ),
                  onChanged: (value) =>
                      setState(() => _phone = toSriLankaE164(value)),
                  onSubmitted: (_) {
                    if (_phone != null) _send();
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BusyButton(
          label: context.l10n.continueLabel,
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: _phone == null ? null : _send,
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: context.l10n.legalPrefix,
            children: [
              TextSpan(
                text: context.l10n.termsAndConditions,
                style: link,
                recognizer: _termsTap,
              ),
              TextSpan(text: context.l10n.legalMiddle),
              TextSpan(
                text: context.l10n.privacyPolicyLink,
                style: link,
                recognizer: _privacyTap,
              ),
              TextSpan(text: context.l10n.legalSuffix),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const _DevLoginHint(),
      ],
    );
  }
}

/// C04 · Verify code.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 6;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = 30;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) timer.cancel();
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_verifying || _controller.text.length != _length) return;
    setState(() => _verifying = true);
    try {
      // On success the router leaves this screen.
      await context.session.verifyCode(_controller.text);
    } catch (error) {
      if (!mounted) return;
      context.showError(error);
      _controller.clear();
      _focus.requestFocus();
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    try {
      await context.session.sendCode(context.session.phoneNumber!);
      _startTimer();
      if (mounted) context.toast(context.l10n.newCodeSent);
    } catch (error) {
      if (mounted) context.showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.session.phoneNumber ?? '';
    final code = _controller.text;
    return AuthLayout(
      title: context.l10n.verifyYourNumber,
      onBack: () => context.pop(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.sentCodeTo),
          const SizedBox(height: 2),
          Text(
            prettyPhone(phone),
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
      children: [
        SizedBox(
          height: 58,
          child: Stack(
            children: [
              // The real input sits underneath and receives the taps.
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    enableInteractiveSelection: false,
                    showCursor: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_length),
                    ],
                    decoration: const InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {});
                      if (value.length == _length) _verify();
                    },
                  ),
                ),
              ),
              IgnorePointer(
                child: Row(
                  children: [
                    for (var i = 0; i < _length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: i == 0 ? 0 : 5,
                            right: i == _length - 1 ? 0 : 5,
                          ),
                          child: _DigitBox(
                            digit: i < code.length ? code[i] : '',
                            active:
                                _focus.hasFocus &&
                                (i == code.length ||
                                    (i == _length - 1 &&
                                        code.length == _length)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: code.length == _length && !_verifying ? _verify : null,
          child: _verifying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.verify),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            context.l10n.didntReceive,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        Center(
          child: _secondsLeft > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    context.l10n.resendIn(
                      '0:${_secondsLeft.toString().padLeft(2, '0')}',
                    ),
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                )
              : TextButton(
                  onPressed: _resend,
                  child: Text(context.l10n.resendCode),
                ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.changeNumber),
          ),
        ),
        const _DevLoginHint(),
      ],
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({required this.digit, required this.active});

  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final filled = digit.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: filled
              ? AppColors.ink
              : (active ? AppColors.yellowDeep : AppColors.line),
          width: filled || active ? 1.6 : 1.2,
        ),
      ),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Formats a Sri Lankan mobile number while typing: "77 123 4567", or
/// "077 123 4567" when it starts with 0.
class SriLankaPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final leadingZero = digits.startsWith('0');
    digits = digits.substring(0, digits.length.clamp(0, leadingZero ? 10 : 9));

    // Groups: 2-3-4 digits, or 3-3-4 with a leading 0.
    final first = leadingZero ? 3 : 2;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == first || i == first + 3) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();

    // Keep the cursor after the same number of digits as before formatting.
    final digitsBeforeCursor = newValue.text
        .substring(0, newValue.selection.end.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'\D'), '')
        .length;
    var offset = 0;
    var seen = 0;
    while (offset < text.length && seen < digitsBeforeCursor) {
      if (text[offset] != ' ') seen++;
      offset++;
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
