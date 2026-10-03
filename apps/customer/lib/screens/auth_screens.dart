import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/env.dart';
import '../core/format.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// C02 · Onboarding.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    (
      icon: Icons.bolt_rounded,
      title: 'Help in minutes, not days',
      body: 'Pipe burst or power gone? Press Emergency and the nearest verified technician is on the way.',
    ),
    (
      icon: Icons.event_available_rounded,
      title: 'Book a time that suits you',
      body: 'Choose a day and an arrival window for repairs, servicing, or an inspection and quote first.',
    ),
    (
      icon: Icons.verified_user_rounded,
      title: 'Verified. And you stay in control',
      body: 'Every technician is ID-checked. You approve the cost before any work is charged.',
    ),
  ];

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
    final last = _page == _pages.length - 1;
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
                  TextButton(onPressed: _finish, child: const Text('Skip')),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  for (final page in _pages)
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
                                color: AppColors.yellow, borderRadius: BorderRadius.circular(28)),
                            child: Icon(page.icon, size: 52),
                          ),
                          const SizedBox(height: 32),
                          Text(page.title, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 12),
                          Text(page.body,
                              style: const TextStyle(fontSize: 16, color: AppColors.inkSoft, height: 1.5)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
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
                        duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                child: Text(last ? 'Get started' : 'Next'),
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
          Positioned(top: -70, left: -60, child: _circle(200, Colors.white.withValues(alpha: 0.16))),
          Positioned(bottom: -80, right: -50, child: _circle(210, const Color(0xFFF2A100).withValues(alpha: 0.35))),
          SafeArea(
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
                              icon: const Icon(Icons.arrow_back_rounded),
                              tooltip: 'Back',
                            ),
                    ),
                  ),
                  const AppIconBadge(size: 78),
                  const SizedBox(height: 18),
                  const Text(
                    'Welcome to RepairMe',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: -0.6),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Home repairs, made simple',
                    style: TextStyle(fontSize: 14, color: AppColors.inkSoft),
                  ),
                ],
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

class _AuthLayout extends StatelessWidget {
  const _AuthLayout({required this.title, required this.subtitle, required this.children, this.onBack});

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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    child: subtitle,
                  ),
                  const SizedBox(height: 18),
                  ...children,
                ],
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
    return const Padding(
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

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await context.session.sendCode(_phone!);
    if (mounted) context.push('/otp');
  }

  @override
  Widget build(BuildContext context) {
    final active = _focus.hasFocus || _controller.text.isNotEmpty;
    return _AuthLayout(
      title: 'Enter your mobile number',
      subtitle: const Text("We'll send you a one-time code"),
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? AppColors.ink : AppColors.line, width: 1.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text('🇱🇰', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('+94', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(width: 14),
              Container(width: 1, height: 28, color: AppColors.line),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                    LengthLimitingTextInputFormatter(12),
                  ],
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  decoration: const InputDecoration(
                    hintText: '77 123 4567',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                  ),
                  onChanged: (value) => setState(() => _phone = toSriLankaE164(value)),
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
          label: 'Send code',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: _phone == null ? null : _send,
        ),
        const SizedBox(height: 16),
        const Text.rich(
          TextSpan(
            text: 'By continuing you agree to our ',
            children: [
              TextSpan(text: 'Terms & Privacy', style: TextStyle(color: AppColors.inkSoft, fontWeight: FontWeight.w500)),
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
      if (mounted) context.toast('A new code is on its way');
    } catch (error) {
      if (mounted) context.showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.session.phoneNumber ?? '';
    final code = _controller.text;
    return _AuthLayout(
      title: 'Enter verification code',
      onBack: () => context.pop(),
      subtitle: Text('Sent to ${prettyPhone(phone)}'),
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
                    decoration: const InputDecoration(filled: false, border: InputBorder.none),
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
                          padding: EdgeInsets.only(left: i == 0 ? 0 : 5, right: i == _length - 1 ? 0 : 5),
                          child: _DigitBox(
                            digit: i < code.length ? code[i] : '',
                            active: _focus.hasFocus && (i == code.length || (i == _length - 1 && code.length == _length)),
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
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                )
              : const Text('Verify'),
        ),
        const SizedBox(height: 12),
        Center(
          child: _secondsLeft > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                )
              : TextButton(onPressed: _resend, child: const Text('Resend code')),
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
          color: filled ? AppColors.ink : (active ? AppColors.yellowDeep : AppColors.line),
          width: filled || active ? 1.6 : 1.2,
        ),
      ),
      child: Text(digit, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
    );
  }
}
