import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../widgets/common.dart';

/// Opening phone, email and web links, with a friendly message if the phone can't.
extension LinkOpening on BuildContext {
  Future<void> openUri(Uri uri) async {
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) toast(l10n.couldNotOpen);
  }

  Future<void> openUrl(String url) => openUri(Uri.parse(url));

  /// A link from configuration; says so when it hasn't been set up yet.
  Future<void> openConfiguredUrl(String url) async {
    if (url.isEmpty) {
      toast(l10n.linkNotAvailable);
      return;
    }
    await openUrl(url);
  }

  Future<void> call(String number) => openUri(Uri(scheme: 'tel', path: number));

  Future<void> email(String address) => openUri(Uri(scheme: 'mailto', path: address));
}
