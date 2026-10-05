import 'package:flutter/material.dart';

import 'brand.dart';

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

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
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
      child = ScaleTransition(scale: Tween<double>(begin: 0.6, end: 1).animate(_pop), child: child);
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(_fade),
        child: child,
      ),
    );
  }
}

/// The RepairMe mark gently breathing, for screens that are waiting on the network.
class LogoLoader extends StatefulWidget {
  const LogoLoader({super.key, this.size = 64});

  final double size;

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final Animation<double> _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.of(context).disableAnimations) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) => Opacity(
        opacity: 0.65 + 0.35 * _t.value,
        child: Transform.scale(scale: 0.9 + 0.16 * _t.value, child: child),
      ),
      child: RepairMeLogo(size: widget.size),
    );
  }
}
