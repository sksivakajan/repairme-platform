import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/env.dart';
import '../core/launcher.dart';
import '../data/models.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/brand_footer.dart';
import '../widgets/common.dart';
import '../widgets/settings_widgets.dart';
import 'tab_screens.dart' show showNewTicketSheet;

/// Help & Support: FAQs, requests, contact options and quick ways to report an issue.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _emergency(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = sheetContext.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.emergencyHelp, style: Theme.of(sheetContext).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(l.emergencyHelpBody, style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.push('/services', extra: BookingType.emergency);
                  },
                  child: Text(l.requestEmergencyTechnician),
                ),
                if (Env.supportPhone.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.call(Env.supportPhone),
                    icon: const Icon(Icons.call_rounded),
                    label: Text(l.callUs),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.helpAndSupport)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          SettingsGroup(
            children: [
              SettingsTile(icon: Icons.quiz_outlined, title: l.helpCenterFaqs, onTap: () => context.push('/support/faq')),
              SettingsTile(icon: Icons.inbox_outlined, title: l.mySupportRequests, onTap: () => context.push('/support/requests')),
              SettingsTile(icon: Icons.headset_mic_outlined, title: l.contactSupport, onTap: () => context.push('/support/contact')),
            ],
          ),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.flag_outlined,
                title: l.reportProblem,
                onTap: () => showNewTicketSheet(context, subject: l.reportProblem),
              ),
              SettingsTile(
                icon: Icons.receipt_long_outlined,
                title: l.paymentIssue,
                onTap: () => showNewTicketSheet(context, subject: l.paymentIssue),
              ),
              SettingsTile(
                icon: Icons.event_busy_outlined,
                title: l.bookingIssue,
                onTap: () => showNewTicketSheet(context, subject: l.bookingIssue),
              ),
              SettingsTile(
                icon: Icons.bolt_rounded,
                title: l.emergencyHelp,
                onTap: () => _emergency(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Searchable questions and answers, grouped by topic.
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final categories = [
      (l.faqCatAccount, [(l.faqPhoneQ, l.faqPhoneA), (l.faqProfileQ, l.faqProfileA), (l.faqDeleteQ, l.faqDeleteA)]),
      (l.faqCatBooking, [
        (l.faqBookQ, l.faqBookA),
        (l.faqEmergencyQ, l.faqEmergencyA),
        (l.faqScheduledQ, l.faqScheduledA),
        (l.faqMeasureQ, l.faqMeasureA),
      ]),
      (l.faqCatPayments, [(l.faqMethodsQ, l.faqMethodsA), (l.faqRefundQ, l.faqRefundA), (l.faqReceiptQ, l.faqReceiptA)]),
      (l.faqCatTechnicians, [(l.faqVerifiedQ, l.faqVerifiedA), (l.faqRateQ, l.faqRateA), (l.faqReportQ, l.faqReportA)]),
    ];
    final q = _query.trim().toLowerCase();
    final visible = [
      for (final (title, items) in categories)
        (
          title,
          [for (final item in items) if (q.isEmpty || item.$1.toLowerCase().contains(q) || item.$2.toLowerCase().contains(q)) item],
        ),
    ].where((c) => c.$2.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.helpCenterFaqs)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: l.faqSearchHint, prefixIcon: const Icon(Icons.search_rounded)),
            onChanged: (value) => setState(() => _query = value),
          ),
          if (visible.isEmpty) EmptyState(icon: Icons.search_off_rounded, title: l.faqNoResults),
          for (final (title, items) in visible) ...[
            SectionTitle(title),
            Card(
              child: Column(
                children: [
                  for (final (question, answer) in items)
                    ExpansionTile(
                      shape: const Border(),
                      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      expandedAlignment: Alignment.centerLeft,
                      children: [Text(answer, style: TextStyle(color: AppColors.inkSoft, height: 1.45))],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The ways to reach RepairMe. Only the ones that are configured appear.
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tiles = <Widget>[
      if (Env.supportPhone.isNotEmpty)
        SettingsTile(
          icon: Icons.call_rounded,
          title: l.callUs,
          subtitle: Env.supportPhone,
          onTap: () => context.call(Env.supportPhone),
        ),
      if (Env.supportEmail.isNotEmpty)
        SettingsTile(
          icon: Icons.mail_outline_rounded,
          title: l.emailUs,
          subtitle: Env.supportEmail,
          onTap: () => context.email(Env.supportEmail),
        ),
      if (Env.supportChat.isNotEmpty)
        SettingsTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: l.chatWithUs,
          onTap: () => context.openUrl(Env.supportChat),
        ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.contactSupport)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          if (tiles.isNotEmpty)
            SettingsGroup(children: tiles)
          else ...[
            EmptyState(icon: Icons.headset_mic_outlined, title: l.contactSupport, message: l.supportNotConfigured),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => showNewTicketSheet(context),
            icon: const Icon(Icons.edit_note_rounded),
            label: Text(l.writeToUs),
          ),
        ],
      ),
    );
  }
}

/// The customer's own support tickets.
class SupportRequestsScreen extends StatelessWidget {
  const SupportRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.mySupportRequests)),
      body: AsyncView<List<SupportTicket>>(
        load: context.repo.tickets,
        builder: (context, tickets, reload) => RefreshIndicator(
          onRefresh: reload,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (tickets.isEmpty) EmptyState(icon: Icons.inbox_outlined, title: l.noSupportRequests, message: l.noSupportHint),
              for (final ticket in tickets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(ticket.subject, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text([ticket.reference, if (ticket.bookingReference != null) ticket.bookingReference].join(' · ')),
                      trailing: ticket.status == 'RESOLVED'
                          ? Pill(label: l.ticketResolved, background: const Color(0xFFE2F3E8), foreground: AppColors.success)
                          : Pill(label: l.ticketOpen, background: AppColors.yellow, foreground: AppColors.black),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () async {
                  if (await showNewTicketSheet(context)) await reload();
                },
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l.writeToUs),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// About RepairMe: what it is, how to reach it, and where it was made.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final services = [l.aboutSvc1, l.aboutSvc2, l.aboutSvc3, l.aboutSvc4, l.aboutSvc5, l.aboutSvc6, l.aboutSvc7, l.aboutSvc8];
    final contactRows = <Widget>[
      if (Env.email.isNotEmpty)
        SettingsTile(icon: Icons.mail_outline_rounded, title: l.officialEmail, subtitle: Env.email, onTap: () => context.email(Env.email)),
      if (Env.phone.isNotEmpty)
        SettingsTile(icon: Icons.call_outlined, title: l.phoneLabel, subtitle: Env.phone, onTap: () => context.call(Env.phone)),
      if (Env.website.isNotEmpty)
        SettingsTile(icon: Icons.language_rounded, title: l.websiteLabel, subtitle: Env.website, onTap: () => context.openUrl(Env.website)),
      if (Env.address.isNotEmpty)
        SettingsTile(icon: Icons.location_on_outlined, title: l.officeAddress, subtitle: Env.address),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutRepairMe)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        children: [
          const Center(child: RepairMeLogo(size: 88)),
          const SizedBox(height: 12),
          const Center(child: Wordmark(fontSize: 30)),
          const SizedBox(height: 4),
          Center(child: Text(l.aboutTagline, style: TextStyle(color: AppColors.yellowDeep, fontWeight: FontWeight.w700, fontSize: 16))),
          const SizedBox(height: 20),
          Text(l.aboutDescription, style: TextStyle(color: AppColors.inkSoft, height: 1.5)),
          SectionTitle(l.services),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  for (final service in services)
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                      title: Text(service),
                    ),
                ],
              ),
            ),
          ),
          SectionTitle(l.contactUs),
          if (contactRows.isEmpty)
            Text(l.contactSoon, style: TextStyle(color: AppColors.muted))
          else
            SettingsGroup(children: contactRows),
          SectionTitle(l.followUs),
          const SocialLinks(),
          const BrandFooter(showTagline: true),
        ],
      ),
    );
  }
}
