import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/api_client.dart';
import '../core/format.dart';
import '../data/models.dart';
import '../l10n/booking_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Saved addresses: Home, Work and Other, with add, edit, delete and default.
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.savedAddresses)),
      body: AsyncView<List<SavedAddress>>(
        load: context.repo.addresses,
        builder: (context, addresses, reload) {
          Future<void> add() async {
            await context.push('/addresses/new');
            await reload();
          }

          return RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (addresses.isEmpty) ...[
                  EmptyState(
                    icon: Icons.home_work_outlined,
                    title: l.noSavedAddressesYet,
                    message: l.saveAddressHint,
                  ),
                  FilledButton(onPressed: add, child: Text(l.addAddress)),
                ] else ...[
                  for (final address in addresses) _AddressCard(address: address, onChanged: reload),
                  const SizedBox(height: 4),
                  OutlinedButton(onPressed: add, child: Text(l.addNewAddress)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onChanged});

  final SavedAddress address;
  final Future<void> Function() onChanged;

  Future<void> _delete(BuildContext context) async {
    final repo = context.repo;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.deleteAddressQ),
        content: Text(dialogContext.l10n.deleteAddressBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(dialogContext.l10n.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await repo.deleteAddress(address.id);
      await onChanged();
    } catch (error) {
      if (context.mounted) context.showError(error);
    }
  }

  Future<void> _makeDefault(BuildContext context) async {
    final repo = context.repo;
    try {
      await repo.updateAddress(address.id, address.address, label: address.label, isDefault: true);
      await onChanged();
    } catch (error) {
      if (context.mounted) context.showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = address.address;
    final contact = [a.contactName, a.contactPhone].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(address.label == 'OFFICE' ? Icons.business_rounded : (address.label == 'HOME' ? Icons.home_rounded : Icons.place_rounded)),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(context.addressLabelText(address.label), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  if (address.isDefault) ...[
                    const SizedBox(width: 8),
                    Pill(label: l.defaultBadge, background: AppColors.yellow, foreground: AppColors.black),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  [a.oneLine, a.city, a.district].whereType<String>().where((s) => s.isNotEmpty).join(', '),
                  style: const TextStyle(height: 1.4),
                ),
              ),
              if (contact.isNotEmpty) Text(contact, style: TextStyle(color: AppColors.muted, fontSize: 13)),
              if (a.instructions != null && a.instructions!.isNotEmpty)
                Text(a.instructions!, style: TextStyle(color: AppColors.muted, fontSize: 13)),
              Wrap(
                children: [
                  TextButton(
                    onPressed: () async {
                      await context.push('/addresses/edit', extra: address);
                      await onChanged();
                    },
                    child: Text(l.edit),
                  ),
                  if (!address.isDefault) TextButton(onPressed: () => _makeDefault(context), child: Text(l.setAsDefault)),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                    onPressed: () => _delete(context),
                    child: Text(l.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Add a new address, or edit [existing].
class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key, this.existing});

  final SavedAddress? existing;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  late final AddressInput? _a = widget.existing?.address;
  late final _line1 = TextEditingController(text: _a?.line1);
  late final _area = TextEditingController(text: _a?.area);
  late final _city = TextEditingController(text: _a?.city ?? 'Colombo');
  late final _district = TextEditingController(text: _a?.district);
  late final _house = TextEditingController(text: _a?.houseNumber);
  late final _landmark = TextEditingController(text: _a?.landmark);
  late final _contactName = TextEditingController(text: _a?.contactName);
  late final _contactPhone = TextEditingController(text: _a?.contactPhone);
  late final _instructions = TextEditingController(text: _a?.instructions);
  late String _label = widget.existing?.label ?? 'HOME';
  late bool _isDefault = widget.existing?.isDefault ?? false;
  bool _submitted = false;

  @override
  void dispose() {
    for (final c in [_line1, _area, _city, _district, _house, _landmark, _contactName, _contactPhone, _instructions]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _phoneOk => _contactPhone.text.trim().isEmpty || toSriLankaE164(_contactPhone.text) != null;

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (_line1.text.trim().length < 3 || _area.text.trim().length < 2 || _city.text.trim().length < 2 || !_phoneOk) return;

    final repo = context.repo;
    final l = context.l10n;
    final address = AddressInput(
      line1: _line1.text.trim(),
      area: _area.text.trim(),
      city: _city.text.trim(),
      district: _district.text.trim(),
      houseNumber: _house.text.trim(),
      landmark: _landmark.text.trim(),
      contactName: _contactName.text.trim(),
      contactPhone: _contactPhone.text.trim().isEmpty ? null : toSriLankaE164(_contactPhone.text),
      instructions: _instructions.text.trim(),
      latitude: _a?.latitude,
      longitude: _a?.longitude,
    );
    try {
      final existing = widget.existing;
      if (existing == null) {
        await repo.createAddress(address, label: _label, isDefault: _isDefault);
      } else {
        await repo.updateAddress(existing.id, address, label: _label, isDefault: _isDefault);
      }
    } on ApiException catch (error) {
      throw UserMessage(error.statusCode == 0 ? l.networkError : l.addressSaveError);
    }
    if (!mounted) return;
    context.toast(l.addressSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(TextEditingController c, int min) => _submitted && c.text.trim().length < min ? l.fieldRequired : null;
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? l.addAddress : l.editAddress)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.addressLabelField, style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final (value, icon) in const [
                ('HOME', Icons.home_rounded),
                ('OFFICE', Icons.business_rounded),
                ('OTHER', Icons.place_rounded),
              ])
                ChoiceChip(
                  avatar: Icon(icon, size: 18),
                  label: Text(context.addressLabelText(value)),
                  selected: _label == value,
                  onSelected: (_) => setState(() => _label = value),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _line1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: '${l.streetAddress} *', errorText: required(_line1, 3)),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _house,
            decoration: InputDecoration(labelText: l.houseNumber),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _area,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: '${l.areaLabel} *', errorText: required(_area, 2)),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _city,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: '${l.cityLabel} *', errorText: required(_city, 2)),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _district,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.districtField),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _landmark,
            decoration: InputDecoration(labelText: l.landmarkLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactName,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.recipientName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l.contactPhoneField,
              errorText: _submitted && !_phoneOk ? l.phoneInvalid : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructions,
            minLines: 2,
            maxLines: 4,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.instructionsField, alignLabelWithHint: true),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.setAsDefault),
            value: _isDefault,
            activeTrackColor: AppColors.ink,
            onChanged: (value) => setState(() => _isDefault = value),
          ),
          const SizedBox(height: 12),
          BusyButton(label: l.saveAddress, onPressed: _save),
        ],
      ),
    );
  }
}
