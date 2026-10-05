import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/api_client.dart';
import '../core/app_language.dart';
import '../core/format.dart';
import '../data/models.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_footer.dart';
import '../widgets/common.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/settings_widgets.dart';
import 'auth_screens.dart' show SriLankaPhoneFormatter;
import 'profile_setup_screen.dart';

/// Asks "Log out?" and signs out when confirmed. The account is not touched.
Future<void> confirmLogout(BuildContext context) async {
  final session = context.session;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.l10n.logOutQ),
      content: Text(dialogContext.l10n.logOutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(dialogContext.l10n.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(dialogContext.l10n.logOutAction),
        ),
      ],
    ),
  );
  if (confirmed == true) await session.signOut();
}

String displayName(BuildContext context, Profile profile) {
  final name = [
    profile.firstName,
    profile.lastName,
  ].where((p) => p.isNotEmpty).join(' ');
  return name.isNotEmpty
      ? name
      : (profile.fullName ?? context.l10n.addYourName);
}

/// C25 · Profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navProfile)),
      body: AsyncView<Profile>(
        load: context.repo.profile,
        builder: (context, profile, reload) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _ProfileCard(
              profile: profile,
              onTap: () async {
                await context.push('/profile/personal');
                await reload();
              },
            ),
            SettingsGroup(
              title: l.sectionAccount,
              children: [
                SettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: l.membership,
                  onTap: () => context.push('/profile/membership'),
                ),
                SettingsTile(
                  icon: Icons.home_work_outlined,
                  title: l.savedAddresses,
                  onTap: () => context.push('/addresses'),
                ),
                SettingsTile(
                  icon: Icons.payments_outlined,
                  title: l.paymentMethods,
                  onTap: () => context.push('/profile/payments'),
                ),
              ],
            ),
            SettingsGroup(
              title: l.sectionSupport,
              children: [
                SettingsTile(
                  icon: Icons.support_agent_outlined,
                  title: l.helpAndSupport,
                  onTap: () => context.push('/support'),
                ),
              ],
            ),
            SettingsGroup(
              title: l.sectionAbout,
              children: [
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: l.aboutRepairMe,
                  onTap: () => context.push('/about'),
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: l.legalAndPrivacy,
                  onTap: () => context.push('/legal'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
              ),
              onPressed: () => confirmLogout(context),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l.logOut),
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                l.followUs,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            const SocialLinks(),
            const BrandFooter(),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onTap});

  final Profile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  ProfileAvatar(profile: profile, size: 60),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName(context, profile),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                prettyPhone(profile.phoneNumber ?? ''),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.muted),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.viewEditProfile,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Personal Information: details, emergency contact and account settings.
class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.personalInformation)),
      body: AsyncView<Profile>(
        load: context.repo.profile,
        builder: (context, profile, reload) =>
            _PersonalForm(profile: profile, reload: reload),
      ),
    );
  }
}

class _PersonalForm extends StatefulWidget {
  const _PersonalForm({required this.profile, required this.reload});

  final Profile profile;
  final Future<void> Function() reload;

  @override
  State<_PersonalForm> createState() => _PersonalFormState();
}

class _PersonalFormState extends State<_PersonalForm> {
  late final _first = TextEditingController(text: widget.profile.firstName);
  late final _last = TextEditingController(text: widget.profile.lastName);
  late final _email = TextEditingController(text: widget.profile.email ?? '');
  late DateTime? _birthday = widget.profile.birthday;
  late String? _gender = widget.profile.gender;
  bool _submitted = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final l = context.l10n;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.takePhoto),
              onTap: () => Navigator.pop(sheetContext, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.fromGallery),
              onTap: () => Navigator.pop(sheetContext, 'gallery'),
            ),
            if (widget.profile.hasPhoto)
              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.danger,
                ),
                title: Text(
                  l.removePhoto,
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () => Navigator.pop(sheetContext, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    final repo = context.repo;
    try {
      if (action == 'remove') {
        await repo.removeProfilePhoto();
      } else {
        final file = await ImagePicker().pickImage(
          source: action == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 900,
          imageQuality: 85,
        );
        if (file == null) return;
        await repo.uploadProfilePhoto(await file.readAsBytes(), file.name);
      }
      await widget.reload();
    } catch (error) {
      if (mounted)
        context.showError(error is ApiException ? error : l.profileUpdateError);
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _pickLanguage() async {
    final language = context.language;
    final repo = context.repo;
    final code = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  sheetContext.l10n.chooseLanguage,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
            ),
            for (final entry in AppLanguage.names.entries)
              ListTile(
                title: Text(entry.value),
                trailing: Icon(
                  language.code == entry.key
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                ),
                onTap: () => Navigator.pop(sheetContext, entry.key),
              ),
          ],
        ),
      ),
    );
    if (code == null) return;
    // Switch the app straight away, then remember it on the server.
    await language.set(code);
    try {
      await repo.updateProfile(language: code);
    } catch (_) {
      // Offline: the phone keeps the choice.
    }
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    final first = _first.text.trim();
    final last = _last.text.trim();
    final email = _email.text.trim();
    if (first.isEmpty || last.isEmpty || !isValidOptionalEmail(email)) return;

    final repo = context.repo;
    final l = context.l10n;
    try {
      await repo.updateProfile(
        firstName: first,
        lastName: last,
        email: email,
        birthday: _birthday == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_birthday!),
        gender: _gender,
      );
    } on ApiException catch (error) {
      throw UserMessage(
        error.statusCode == 0 ? l.networkError : l.profileUpdateError,
      );
    }
    if (!mounted) return;
    context.toast(l.changesSaved);
    await widget.reload();
  }

  String _genderLabel(String value) {
    final l = context.l10n;
    return switch (value) {
      'MALE' => l.genderMale,
      'FEMALE' => l.genderFemale,
      _ => l.genderPrefer,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Center(child: ProfileAvatar(profile: widget.profile, size: 96)),
        Center(
          child: TextButton(
            onPressed: _changePhoto,
            child: Text(l.changeProfilePhoto),
          ),
        ),
        SectionTitle(l.personalDetails),
        TextField(
          controller: _first,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l.firstName,
            errorText: _submitted && _first.text.trim().isEmpty
                ? l.firstNameRequired
                : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _last,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l.lastName,
            errorText: _submitted && _last.text.trim().isEmpty
                ? l.lastNameRequired
                : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        VerifiedPhoneField(phone: widget.profile.phoneNumber ?? ''),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l.emailLabel,
            errorText: _submitted && !isValidOptionalEmail(_email.text.trim())
                ? l.emailInvalid
                : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _pickBirthday,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l.birthday,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            ),
            child: Text(
              _birthday == null
                  ? l.birthdayHint
                  : DateFormat('dd / MM / yyyy', locale).format(_birthday!),
              style: TextStyle(
                color: _birthday == null ? AppColors.muted : AppColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _gender,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.gender),
          hint: Text(l.selectGender),
          items: [
            for (final value in const ['MALE', 'FEMALE', 'PREFER_NOT_TO_SAY'])
              DropdownMenuItem(value: value, child: Text(_genderLabel(value))),
          ],
          onChanged: (value) => setState(() => _gender = value),
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _pickLanguage,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l.language,
              suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
            ),
            child: ListenableBuilder(
              listenable: context.language,
              builder: (context, _) =>
                  Text(AppLanguage.names[context.language.code] ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const AppearanceCard(),
        const SizedBox(height: 20),
        BusyButton(label: l.saveChanges, onPressed: _save),
        SectionTitle(l.emergencyContact),
        const _EmergencyContactCard(),
        SettingsGroup(
          children: [
            SettingsTile(
              icon: Icons.tune_rounded,
              title: l.additionalSettings,
              onTap: () async {
                await context.push('/settings');
                await widget.reload();
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// One emergency contact: shown with Edit / Remove, or an Add button.
class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncView<({EmergencyContact? value})>(
      load: () async => (value: await context.repo.emergencyContact()),
      builder: (context, data, reload) {
        final contact = data.value;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (contact == null) ...[
                  Text(
                    l.emergencyContactHint,
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l.addEmergencyContact),
                    onPressed: () async {
                      if (await showEmergencyContactSheet(context, null))
                        await reload();
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      Avatar(name: contact.name, size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              contact.relationship,
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              prettyPhone(contact.phoneNumber),
                              style: TextStyle(
                                color: AppColors.inkSoft,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (await showEmergencyContactSheet(context, contact))
                            await reload();
                        },
                        child: Text(l.edit),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.danger,
                        ),
                        onPressed: () async {
                          final repo = context.repo;
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(dialogContext.l10n.removeContactQ),
                              content: Text(
                                dialogContext.l10n.removeContactBody,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: Text(dialogContext.l10n.cancel),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.danger,
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: Text(dialogContext.l10n.remove),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          await repo.removeEmergencyContact();
                          await reload();
                        },
                        child: Text(l.remove),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Add or edit the emergency contact. Returns true when it was saved.
Future<bool> showEmergencyContactSheet(
  BuildContext context,
  EmergencyContact? existing,
) async {
  final name = TextEditingController(text: existing?.name);
  final relationship = TextEditingController(text: existing?.relationship);
  final phone = TextEditingController(
    text: existing == null ? '' : existing.phoneNumber.replaceFirst('+94', '0'),
  );
  var submitted = false;

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        final l = sheetContext.l10n;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.emergencyContact,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l.contactName,
                    errorText: submitted && name.text.trim().length < 2
                        ? l.fieldRequired
                        : null,
                  ),
                  onChanged: (_) => setSheetState(() {}),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: relationship,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l.relationship,
                    errorText: submitted && relationship.text.trim().length < 2
                        ? l.fieldRequired
                        : null,
                  ),
                  onChanged: (_) => setSheetState(() {}),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final option in [
                      l.relationshipFamily,
                      l.relationshipFriend,
                      l.relationshipNeighbour,
                    ])
                      ActionChip(
                        label: Text(option),
                        onPressed: () =>
                            setSheetState(() => relationship.text = option),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [SriLankaPhoneFormatter()],
                  decoration: InputDecoration(
                    labelText: l.mobileNumber,
                    prefixText: '+94  ',
                    errorText: submitted && toSriLankaE164(phone.text) == null
                        ? l.phoneInvalid
                        : null,
                  ),
                  onChanged: (_) => setSheetState(() {}),
                ),
                const SizedBox(height: 16),
                BusyButton(
                  label: l.save,
                  onPressed: () async {
                    setSheetState(() => submitted = true);
                    final e164 = toSriLankaE164(phone.text);
                    if (name.text.trim().length < 2 ||
                        relationship.text.trim().length < 2 ||
                        e164 == null)
                      return;
                    final repo = sheetContext.repo;
                    final failure = UserMessage(l.profileUpdateError);
                    try {
                      await repo.saveEmergencyContact(
                        name.text.trim(),
                        relationship.text.trim(),
                        e164,
                      );
                    } on ApiException {
                      throw failure;
                    }
                    if (sheetContext.mounted) Navigator.pop(sheetContext, true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  name.dispose();
  relationship.dispose();
  phone.dispose();
  if (saved == true && context.mounted)
    context.toast(context.l10n.contactSaved);
  return saved == true;
}

/// Light / dark / system appearance, saved on the device.
class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appearance = context.appearance;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.contrast_rounded),
                const SizedBox(width: 16),
                Text(
                  context.l10n.appearance,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListenableBuilder(
              listenable: appearance,
              builder: (context, _) => SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.yellow,
                  selectedForegroundColor: AppColors.black,
                  side: BorderSide(color: AppColors.line),
                ),
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Icons.light_mode_outlined),
                    label: Text(context.l10n.appearanceLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Icons.dark_mode_outlined),
                    label: Text(context.l10n.appearanceDark),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(Icons.brightness_auto_outlined),
                    label: Text(context.l10n.appearanceSystem),
                  ),
                ],
                selected: {appearance.mode},
                onSelectionChanged: (selection) =>
                    appearance.setMode(selection.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Change number, notifications and logout, on a page of their own.
class AdditionalSettingsScreen extends StatelessWidget {
  const AdditionalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.additionalSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.phone_iphone_rounded,
                title: l.changeMobileNumber,
                onTap: () => context.push('/settings/phone'),
              ),
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: l.notificationPreferences,
                onTap: () => context.push('/settings/notifications'),
              ),
              SettingsTile(
                icon: Icons.logout_rounded,
                title: l.logOut,
                onTap: () => confirmLogout(context),
              ),
            ],
          ),
          SettingsGroup(
            title: l.dangerZone,
            danger: true,
            children: [
              SettingsTile(
                icon: Icons.delete_outline_rounded,
                title: l.deleteAccount,
                destructive: true,
                onTap: () => context.push('/settings/delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
