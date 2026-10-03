// Renders the RepairMe mark to PNG files (previews and Android launcher icons).
//
//   flutter test tool/brand_assets_test.dart --dart-define=OUT=<preview dir>
//
// Without OUT it writes the launcher icons into android/app/src/main/res.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repairme_customer/theme/app_theme.dart';
import 'package:repairme_customer/widgets/brand.dart';

const _previewDir = String.fromEnvironment('OUT');

Future<void> _writePng(String path, int width, int height, void Function(Canvas canvas) paint) async {
  final recorder = ui.PictureRecorder();
  paint(Canvas(recorder));
  final image = await recorder.endRecording().toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  await File(path).create(recursive: true);
  await File(path).writeAsBytes(bytes!.buffer.asUint8List());
}

void _paintLogo(Canvas canvas, Offset origin, double size, LogoPalette palette, {double progress = 1}) {
  canvas
    ..save()
    ..translate(origin.dx, origin.dy);
  LogoPainter(palette: palette, progress: progress).paint(canvas, Size.square(size));
  canvas.restore();
}

const _res = 'android/app/src/main/res';

/// Android density buckets and their scale factor relative to mdpi.
const _densities = {'mdpi': 1.0, 'hdpi': 1.5, 'xhdpi': 2.0, 'xxhdpi': 3.0, 'xxxhdpi': 4.0};

void main() {
  test('launcher icons', () async {
    if (_previewDir.isNotEmpty) return;
    for (final MapEntry(key: density, value: scale) in _densities.entries) {
      // Legacy icon (Android 7 and older): the mark on a black rounded square.
      final legacy = (48 * scale).round();
      await _writePng('$_res/mipmap-$density/ic_launcher.png', legacy, legacy, (canvas) {
        final size = legacy.toDouble();
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size, size), Radius.circular(size * 0.22)),
          Paint()..color = AppColors.ink,
        );
        _paintLogo(canvas, Offset(size * 0.18, size * 0.18), size * 0.64, LogoPalette.onDark);
      });

      // Adaptive icon foreground (108dp canvas, mark inside the 66dp safe zone).
      final foreground = (108 * scale).round();
      await _writePng('$_res/mipmap-$density/ic_launcher_foreground.png', foreground, foreground, (canvas) {
        final size = foreground.toDouble();
        _paintLogo(canvas, Offset(size * 0.25, size * 0.25), size * 0.5, LogoPalette.onDark);
      });
    }
  });

  test('preview', () async {
    if (_previewDir.isEmpty) return;
    const cell = 220.0;
    const frames = [0.15, 0.3, 0.45, 0.6, 0.75, 1.0];
    await _writePng('$_previewDir/logo_frames.png', (cell * frames.length).toInt(), cell.toInt(), (canvas) {
      canvas.drawRect(const Rect.fromLTWH(0, 0, cell * 6, cell), Paint()..color = Colors.white);
      for (var i = 0; i < frames.length; i++) {
        _paintLogo(canvas, Offset(cell * i + 20, 20), cell - 40, LogoPalette.onLight, progress: frames[i]);
      }
    });
    await _writePng('$_previewDir/logo_large.png', 900, 450, (canvas) {
      canvas.drawRect(const Rect.fromLTWH(0, 0, 450, 450), Paint()..color = Colors.white);
      canvas.drawRect(const Rect.fromLTWH(450, 0, 450, 450), Paint()..color = AppColors.ink);
      _paintLogo(canvas, const Offset(45, 45), 360, LogoPalette.onLight);
      _paintLogo(canvas, const Offset(495, 45), 360, LogoPalette.onDark);
    });
  });
}
