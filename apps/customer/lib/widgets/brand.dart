import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Colours of the RepairMe mark: the left half (outline, window, wrench) and
/// the right half (outline, hand).
class LogoPalette {
  const LogoPalette({required this.left, required this.right});

  final Color left;
  final Color right;

  static const onLight = LogoPalette(left: AppColors.ink, right: AppColors.yellow);
  static const onDark = LogoPalette(left: Colors.white, right: AppColors.yellow);
}

/// The RepairMe house-shield mark.
class RepairMeLogo extends StatelessWidget {
  const RepairMeLogo({
    super.key,
    this.size = 96,
    this.palette = LogoPalette.onLight,
    this.progress = 1,
  });

  final double size;
  final LogoPalette palette;

  /// 0 → 1 assembles the mark (used by the splash animation).
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: LogoPainter(palette: palette, progress: progress),
    );
  }
}

/// Draws the mark on a 100 × 100 grid. As [progress] goes from 0 to 1 the
/// outline traces up from the base to the roof, then the window, wrench and
/// hand appear.
class LogoPainter extends CustomPainter {
  LogoPainter({required this.palette, this.progress = 1});

  final LogoPalette palette;
  final double progress;

  static const _stroke = 8.5;

  static double _phase(double t, double start, double end, [Curve curve = Curves.easeOutCubic]) =>
      curve.transform(((t - start) / (end - start)).clamp(0.0, 1.0));

  static final Path _leftHalf = Path()
    ..moveTo(50, 94)
    ..quadraticBezierTo(14, 86, 10, 62)
    ..lineTo(10, 42)
    ..lineTo(50, 6);

  static final Path _rightHalf = Path()
    ..moveTo(50, 94)
    ..quadraticBezierTo(86, 86, 90, 62)
    ..lineTo(90, 42)
    ..lineTo(50, 6);

  /// A cupped hand on the right, holding the end of the wrench.
  static final Path _hand = Path()
    ..moveTo(49, 73)
    ..quadraticBezierTo(65, 80, 69, 63)
    ..quadraticBezierTo(71, 55, 63.5, 54);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 100;
    canvas
      ..save()
      ..translate((size.width - 100 * scale) / 2, (size.height - 100 * scale) / 2)
      ..scale(scale);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Each half is clipped at the centre line so the colours meet in a clean seam.
    final outline = _phase(progress, 0, 0.45, Curves.easeInOutCubic);
    canvas
      ..save()
      ..clipRect(const Rect.fromLTRB(-10, -10, 50, 110));
    _trace(canvas, _leftHalf, outline, stroke..color = palette.left);
    canvas
      ..restore()
      ..save()
      ..clipRect(const Rect.fromLTRB(50, -10, 110, 110));
    _trace(canvas, _rightHalf, outline, stroke..color = palette.right);
    canvas.restore();

    _paintWindow(canvas);
    _paintWrench(canvas, _phase(progress, 0.42, 0.75, Curves.easeOutBack));
    _trace(canvas, _hand, _phase(progress, 0.55, 0.85), stroke..color = palette.right);

    canvas.restore();
  }

  /// Draws the first [fraction] of [path]'s length.
  void _trace(Canvas canvas, Path path, double fraction, Paint paint) {
    if (fraction <= 0) return;
    if (fraction >= 1) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * fraction), paint);
    }
  }

  void _paintWindow(Canvas canvas) {
    final fill = Paint()..color = palette.left;
    const origins = [Offset(36, 25), Offset(43.5, 25), Offset(36, 32.5), Offset(43.5, 32.5)];
    for (var i = 0; i < origins.length; i++) {
      final t = _phase(progress, 0.32 + i * 0.05, 0.5 + i * 0.05, Curves.easeOutBack);
      if (t <= 0) continue;
      final rect = Rect.fromCenter(
        center: origins[i] + const Offset(3, 3),
        width: 6 * t,
        height: 6 * t,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(1.4 * t)), fill);
    }
  }

  void _paintWrench(Canvas canvas, double t) {
    if (t <= 0) return;
    canvas
      ..save()
      ..translate(34, 62)
      ..rotate(math.pi / 4 - (1 - t) * 0.9)
      ..scale(0.4 + 0.6 * t);

    final head = Path()..addOval(Rect.fromCircle(center: const Offset(-13, 0), radius: 9));
    final jaw = Path()..addRect(const Rect.fromLTRB(-24, -3.6, -12.5, 3.6));
    final handle = Path()
      ..addRRect(RRect.fromRectAndRadius(const Rect.fromLTRB(-9, -4, 19, 4), const Radius.circular(4)));
    final wrench = Path.combine(
      PathOperation.union,
      Path.combine(PathOperation.difference, head, jaw),
      handle,
    );
    canvas.drawPath(
      wrench,
      Paint()..color = palette.left.withValues(alpha: t.clamp(0.0, 1.0)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(LogoPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.palette != palette;
}

/// "RepairMe" with "Me" in brand yellow.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.fontSize = 34, this.onDark = false});

  final double fontSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Repair', style: TextStyle(color: onDark ? Colors.white : AppColors.ink)),
          const TextSpan(text: 'Me', style: TextStyle(color: AppColors.yellow)),
        ],
      ),
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.04 * fontSize,
        height: 1.1,
      ),
    );
  }
}

/// The app icon: the mark on a black rounded square.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({super.key, this.size = 76});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      alignment: Alignment.center,
      child: RepairMeLogo(size: size * 0.64, palette: LogoPalette.onDark),
    );
  }
}
