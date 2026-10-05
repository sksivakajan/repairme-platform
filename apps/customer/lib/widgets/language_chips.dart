import 'package:flutter/material.dart';

import '../core/app_language.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// English / සිංහල / தமிழ் switch for the screens shown before sign-in.
class LanguageChips extends StatelessWidget {
  const LanguageChips({super.key, this.onYellow = false});

  /// Drawn on the yellow sign-in header (always dark ink), not on the page background.
  final bool onYellow;

  @override
  Widget build(BuildContext context) {
    final language = context.language;
    return ListenableBuilder(
      listenable: language,
      builder: (context, _) => Wrap(
        spacing: 8,
        children: [
          for (final entry in AppLanguage.names.entries)
            _chip(entry.value, selected: language.code == entry.key, onTap: () => language.set(entry.key)),
        ],
      ),
    );
  }

  Widget _chip(String label, {required bool selected, required VoidCallback onTap}) {
    final ink = onYellow ? AppColors.black : AppColors.ink;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? (onYellow ? AppColors.black : AppColors.yellow) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? Colors.transparent : ink.withValues(alpha: 0.35)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? (onYellow ? AppColors.yellow : AppColors.black) : ink,
            ),
          ),
        ),
      ),
    );
  }
}
