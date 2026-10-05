import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';

/// The splash is always white, like the Android launch screen before it.
const _grey = Color(0xFF73726C);

/// C01 · Splash. The mark assembles itself, then the wordmark and tagline
/// appear while a loading bar fills; [onFinished] fires when it is done.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onFinished});

  final VoidCallback? onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished?.call();
        // If the app is still loading behind this screen, keep the logo breathing.
        if (mounted && !MediaQuery.of(context).disableAnimations) _pulse.repeat(reverse: true);
      }
    });

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final _logo = _interval(0, 0.62, Curves.linear);
  late final _wordmark = _interval(0.46, 0.7);
  late final _tagline = _interval(0.6, 0.84);
  late final _footer = _interval(0.68, 0.9);
  late final _loading = _interval(0.04, 1, Curves.easeInOutCubic);

  Animation<double> _interval(double begin, double end, [Curve curve = Curves.easeOutCubic]) =>
      CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: curve));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    if (MediaQuery.of(context).disableAnimations) {
      // Respect "remove animations": show the finished splash briefly instead.
      _controller.value = 0.999;
      _controller.animateTo(1, duration: const Duration(milliseconds: 400));
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBuilder(
          animation: Listenable.merge([_controller, _pulse]),
          builder: (context, _) => Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 1 + 0.05 * Curves.easeInOut.transform(_pulse.value),
                      child: RepairMeLogo(size: 116, palette: LogoPalette.onLight, progress: _logo.value),
                    ),
                    const SizedBox(height: 18),
                    Opacity(
                      opacity: _wordmark.value,
                      child: Transform.translate(
                        offset: Offset(0, 16 * (1 - _wordmark.value)),
                        child: const Wordmark(fontSize: 40, onDark: false),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: _tagline.value,
                      child: Text(
                        context.l10n.splashTagline,
                        style: TextStyle(
                          color: _grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          // Spaced-out letters only suit the Latin script.
                          letterSpacing: Localizations.localeOf(context).languageCode == 'en' ? 1.5 + 2.5 * _tagline.value : 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      children: [
                        Container(
                          width: 104,
                          height: 4,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECEBE6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: _loading.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Opacity(
                          opacity: _footer.value,
                          child: Text(
                            context.l10n.splashProud,
                            style: TextStyle(color: _grey, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
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
