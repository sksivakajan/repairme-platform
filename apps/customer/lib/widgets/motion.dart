import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fades (and slides, and optionally pops) its child in once, when it first
/// appears. [begin] and [end] are fractions of one second-long run, so several
/// of these side by side can be staggered without any timers.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.begin = 0,
    this.end = 1,
    this.offset = const Offset(0, 0.12),
    this.pop = false,
  });

  final Widget child;
  final double begin;
  final double end;

  /// Where it starts, as a fraction of its own size.
  final Offset offset;

  /// Also scales up with a little overshoot (for logos).
  final bool pop;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Interval(widget.begin, widget.end, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _pop = CurvedAnimation(
    parent: _controller,
    curve: Interval(widget.begin, widget.end, curve: Curves.easeOutBack),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Respect "remove animations" in the phone's accessibility settings.
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    if (widget.pop) {
      child = ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1).animate(_pop),
        child: child,
      );
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: widget.offset,
          end: Offset.zero,
        ).animate(_fade),
        child: child,
      ),
    );
  }
}

/// Three yellow dots with a white shine that bounce in a wave, for screens that
/// are waiting on the network.
class DotsLoader extends StatefulWidget {
  const DotsLoader({super.key, this.size = 13});

  final double size;

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.of(context).disableAnimations) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 0 → 1 → 0 once per cycle for each dot, one after the other.
  double _wave(int index) {
    final t = (_controller.value - index * 0.14) % 1.0;
    final phase = (t / 0.55).clamp(0.0, 1.0);
    return math.sin(math.pi * phase);
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Semantics(
      label: 'Loading',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => SizedBox(
          height: size * 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size * 0.4),
                  child: Transform.translate(
                    offset: Offset(0, -size * 0.9 * _wave(i)),
                    child: Transform.scale(
                      scale: 0.72 + 0.4 * _wave(i),
                      child: Container(
                        width: size,
                        height: size,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFFD84D), Color(0xFFFFB703)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB703)
                                  .withValues(alpha: 0.18 + 0.4 * _wave(i)),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Container(
                          width: size * 0.36,
                          height: size * 0.36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: 0.65 + 0.35 * _wave(i),
                            ),
                          ),
                        ),
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
