import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Which version of the mark to show.
enum LogoPalette {
  /// Black and yellow, for light backgrounds.
  onLight('assets/images/logo_mark.png'),

  /// White and yellow, for dark backgrounds.
  onDark('assets/images/logo_mark_light.png');

  const LogoPalette(this.asset);

  final String asset;
}

/// The RepairMe house-shield mark (from the original artwork).
class RepairMeLogo extends StatelessWidget {
  const RepairMeLogo({
    super.key,
    this.size = 96,
    this.palette = LogoPalette.onLight,
    this.progress = 1,
  });

  final double size;
  final LogoPalette palette;

  /// 0 → 1 reveals the mark from the base up while it scales in (splash).
  final double progress;

  static double _phase(double t, double start, double end, Curve curve) =>
      curve.transform(((t - start) / (end - start)).clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      palette.asset,
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'RepairMe',
    );
    if (progress >= 1) return image;

    final reveal = _phase(progress, 0, 0.7, Curves.easeInOutCubic);
    final scale = 0.82 + 0.18 * _phase(progress, 0.1, 0.9, Curves.easeOutBack);
    return SizedBox.square(
      dimension: size,
      child: Opacity(
        opacity: _phase(progress, 0, 0.25, Curves.easeOut),
        child: Transform.scale(
          scale: scale,
          child: ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: reveal,
              child: image,
            ),
          ),
        ),
      ),
    );
  }
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
