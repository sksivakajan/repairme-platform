import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/env.dart';
import '../core/format.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// C01 · Splash, shown while the session loads.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.yellow,
      body: Center(child: BrandMark(large: true)),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 84 : 48,
          height: large ? 84 : 48,
          decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(large ? 24 : 14)),
          child: Icon(Icons.build_rounded, color: AppColors.yellow, size: large ? 44 : 26),
        ),
        const SizedBox(height: 16),
        Text('Repair Me',
            style: TextStyle(fontSize: large ? 34 : 22, fontWeight: FontWeight.w900, letterSpacing: -1)),
        if (large) ...[
          const SizedBox(height: 6),
          const Text('Fixed. Fast. Verified.', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}

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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _finish, child: const Text('Skip')),
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
                              style: const TextStyle(fontSize: 16, color: AppColors.inkSoft, height: 1.45)),
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

/// C03 · Phone number.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  String? _phone;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await context.session.sendCode(_phone!);
    if (mounted) context.push('/otp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Enter your mobile number', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('We will send a 6-digit code by SMS to confirm it is you.',
              style: TextStyle(color: AppColors.muted, fontSize: 15)),
          const SizedBox(height: 28),
          const Text('Mobile number', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')), LengthLimitingTextInputFormatter(12)],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1),
            decoration: const InputDecoration(
              hintText: '77 123 4567',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text('+94', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onChanged: (value) => setState(() => _phone = toSriLankaE164(value)),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.muted),
              SizedBox(width: 6),
              Expanded(
                child: Text('Your number is only shared with the technician assigned to your booking.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
            ],
          ),
          if (!Env.useFirebase) ...[
            const SizedBox(height: 20),
            const Pill(
                label: 'DEVELOPMENT LOGIN · CODE ${Env.devOtpCode}',
                background: AppColors.yellowSoft,
                foreground: AppColors.ink),
          ],
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BusyButton(label: 'Send code', onPressed: _phone == null ? null : _send),
            const SizedBox(height: 10),
            const Text('By continuing you agree to the Terms and Privacy Policy',
                style: TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
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
  final _controller = TextEditingController();
  Timer? _timer;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  Future<void> _verify() => context.session.verifyCode(_controller.text);

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
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Enter the code', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Sent to ${prettyPhone(phone)} · ', style: const TextStyle(color: AppColors.muted)),
              GestureDetector(
                onTap: () => context.pop(),
                child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 16),
            decoration: const InputDecoration(counterText: '', hintText: '······'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Center(
            child: _secondsLeft > 0
                ? Text('Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: AppColors.muted))
                : TextButton(onPressed: _resend, child: const Text('Resend code')),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: BusyButton(
          label: 'Verify and continue',
          onPressed: _controller.text.length == 6 ? _verify : null,
        ),
      ),
    );
  }
}
