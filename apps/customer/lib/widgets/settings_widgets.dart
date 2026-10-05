import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A titled card of rows, for Profile and settings screens.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.title, required this.children, this.danger = false});

  final String? title;
  final List<Widget> children;

  /// A red-outlined group, for destructive actions only.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final latin = Localizations.localeOf(context).languageCode == 'en';
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: latin ? 1 : 0,
                  color: danger ? AppColors.danger : AppColors.muted,
                ),
              ),
            ),
          Card(
            shape: danger
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
                  )
                : null,
            child: Column(
              children: [
                for (final (i, child) in children.indexed) ...[
                  if (i > 0) const Divider(indent: 16, endIndent: 16),
                  child,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One tappable row: icon, title, optional subtitle, chevron.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.danger : AppColors.ink;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ?? (onTap == null ? null : Icon(Icons.chevron_right_rounded, color: color)),
      onTap: onTap,
    );
  }
}
