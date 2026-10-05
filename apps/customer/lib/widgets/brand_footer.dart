import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/env.dart';
import '../core/launcher.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// Instagram, Facebook and LinkedIn. The links come from configuration; until
/// RepairMe sets them, tapping says the link isn't available yet.
class SocialLinks extends StatelessWidget {
  const SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    Widget button(Widget icon, String label, String url) => Semantics(
          button: true,
          label: label,
          child: Material(
            color: AppColors.surface,
            shape: CircleBorder(side: BorderSide(color: AppColors.line)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.openConfiguredUrl(url),
              child: SizedBox(width: 52, height: 52, child: Center(child: icon)),
            ),
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        button(Icon(Icons.camera_alt_outlined, color: AppColors.ink), 'Instagram', Env.instagramUrl),
        const SizedBox(width: 14),
        button(Icon(Icons.facebook, color: AppColors.ink), 'Facebook', Env.facebookUrl),
        const SizedBox(width: 14),
        button(
          Text('in', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 19)),
          'LinkedIn',
          Env.linkedinUrl,
        ),
      ],
    );
  }
}

/// "Made in Sri Lanka", the brand name and the app version (read from the build).
class BrandFooter extends StatelessWidget {
  const BrandFooter({super.key, this.showTagline = false});

  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text('🇱🇰 ${context.l10n.madeInSriLanka}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('RepairMe', style: TextStyle(fontWeight: FontWeight.w800)),
          if (showTagline) ...[
            const SizedBox(height: 2),
            Text(context.l10n.aboutTagline, style: TextStyle(color: AppColors.muted, fontSize: 13)),
          ],
          const SizedBox(height: 4),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) => Text(
              snapshot.hasData ? context.l10n.appVersion(snapshot.data!.version) : '',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
