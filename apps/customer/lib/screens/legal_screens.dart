import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../config/env.dart';
import '../data/models.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/settings_widgets.dart';

/// The legal documents, in the order they are listed.
const legalDocumentTypes = ['terms', 'privacy', 'cancellation', 'refund', 'payment', 'data-deletion'];

String _titleFor(BuildContext context, String type, String fallback) {
  final l = context.l10n;
  return switch (type) {
    'terms' => l.termsAndConditions,
    'privacy' => l.privacyPolicy,
    'cancellation' => l.cancellationPolicy,
    'refund' => l.refundPolicy,
    'payment' => l.paymentPolicy,
    'data-deletion' => l.dataDeletionPolicy,
    _ => fallback,
  };
}

/// Legal & Privacy: the list of documents.
class LegalPrivacyScreen extends StatelessWidget {
  const LegalPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'terms': Icons.gavel_rounded,
      'privacy': Icons.privacy_tip_outlined,
      'cancellation': Icons.event_busy_outlined,
      'refund': Icons.currency_exchange_rounded,
      'payment': Icons.payments_outlined,
      'data-deletion': Icons.delete_sweep_outlined,
    };
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.legalAndPrivacy)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          SettingsGroup(
            children: [
              for (final type in legalDocumentTypes)
                SettingsTile(
                  icon: icons[type]!,
                  title: _titleFor(context, type, type),
                  onTap: () => context.push('/legal/$type'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One document, from the server, so the text can change without an app update.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleFor(context, type, ''))),
      body: AsyncView<LegalDocument>(
        load: () => context.repo.legalDocument(type),
        builder: (context, document, reload) => _DocumentBody(document: document),
      ),
    );
  }
}

/// Company details written into the documents as [Square Brackets] are filled
/// from configuration when it exists, and left visible when it doesn't.
String fillLegalPlaceholders(String text) {
  final values = {
    '[Official Email]': Env.email,
    '[Official Privacy Email]': Env.privacyEmail.isNotEmpty ? Env.privacyEmail : Env.email,
    '[Official Phone]': Env.phone,
    '[Official Address]': Env.address,
  };
  var result = text;
  values.forEach((placeholder, value) {
    if (value.isNotEmpty) result = result.replaceAll(placeholder, value);
  });
  return result;
}

class _DocumentBody extends StatelessWidget {
  const _DocumentBody({required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final updated = document.lastUpdated;
    final blocks = <Widget>[];
    for (final raw in fillLegalPlaceholders(document.content).split('\n')) {
      final line = raw.trimRight();
      if (line.isEmpty) continue;
      if (line.startsWith('### ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 4),
          child: Text(line.substring(4), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ));
      } else if (line.startsWith('## ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 4, height: 20, margin: const EdgeInsets.only(right: 10, top: 2), color: AppColors.yellow),
              Expanded(child: Text(line.substring(3), style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
        ));
      } else if (line.startsWith('- ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(top: 8, right: 10), child: Icon(Icons.circle, size: 5, color: AppColors.ink)),
              Expanded(child: Text(line.substring(2), style: const TextStyle(height: 1.5))),
            ],
          ),
        ));
      } else {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(line, style: TextStyle(height: 1.55, color: AppColors.ink)),
        ));
      }
    }

    Widget note(String text) => Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(12)),
          child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4)),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        const Row(children: [RepairMeLogo(size: 30), SizedBox(width: 8), Wordmark(fontSize: 20)]),
        const SizedBox(height: 16),
        Text(_titleFor(context, document.type, document.title), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          [
            if (updated != null) l.lastUpdatedOn(DateFormat('d MMMM y', locale).format(updated.toLocal())),
            l.appVersion(document.version),
          ].join(' · '),
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        note(l.legalDraftNote),
        if (locale != 'en') note(l.legalEnglishNote),
        ...blocks,
      ],
    );
  }
}
