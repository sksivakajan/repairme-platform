import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/format.dart';
import '../data/booking_draft.dart';
import '../data/models.dart';
import '../l10n/booking_text.dart';
import '../l10n/catalog_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// C07 · How soon do you need help?
class BookingTypeScreen extends StatefulWidget {
  const BookingTypeScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingTypeScreen> createState() => _BookingTypeScreenState();
}

class _BookingTypeScreenState extends State<BookingTypeScreen> {
  late BookingType _type = widget.draft.type;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (BookingType.emergency, Icons.bolt_rounded, l.typeEmergencyBody, l.typeEmergencyHint),
      (BookingType.scheduled, Icons.calendar_month_rounded, l.typeScheduledBody, l.typeScheduledHint),
      (BookingType.inspection, Icons.straighten_rounded, l.typeInspectionBody, l.typeInspectionHint),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(context.categoryName(widget.draft.category.slug, widget.draft.category.name))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.howSoon, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          for (final (type, icon, body, hint) in options)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionCard(
                selected: _type == type,
                onTap: () => setState(() => _type = type),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: type == BookingType.emergency ? AppColors.yellow : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: type == BookingType.emergency ? AppColors.black : AppColors.ink),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.bookingTypeLabel(type),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(body, style: TextStyle(color: AppColors.inkSoft)),
                          const SizedBox(height: 8),
                          Text(hint, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(_type == type ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.yellowSoft, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.howPricingWorks, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  l.pricingBody(context.lkr(widget.draft.category.visitFeeCents)),
                  style: const TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: () {
            widget.draft.type = _type;
            context.push('/request/details', extra: widget.draft);
          },
          child: Text(l.continueWith(context.bookingTypeLabel(_type))),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.selected, required this.onTap, required this.child});

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? AppColors.ink : AppColors.line, width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

const _symptomsByCategory = {
  'electrical': ['Burning smell', 'Sparks seen', 'Only one room', 'Happened before'],
  'plumbing': ['Water leaking now', 'Low pressure', 'Bad smell', 'Happened before'],
  'ac': ['Water dripping', 'Bad smell', 'Not turning on', 'Happened before'],
  'refrigerators': ['Water on floor', 'Ice build-up', 'Noisy', 'Happened before'],
  'washing-machines': ['Water on floor', 'Error code shown', 'Noisy', 'Happened before'],
  'mechanic': ['Vehicle at home', 'Vehicle on the road', 'Warning light on', 'Happened before'],
};
const _defaultSymptoms = ['Urgent', 'Happened before', 'Need parts'];

/// C08 · Problem details.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final _description = TextEditingController(text: widget.draft.description);

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final symptoms = _symptomsByCategory[draft.category.slug] ?? _defaultSymptoms;
    final valid = draft.problemType != null && _description.text.trim().length >= 10;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.requestDetails)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StepHeader(step: 1, label: context.l10n.stepProblem, title: context.l10n.whatIsProblem),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final problem in draft.category.problemTypes)
                ChoiceChip(
                  label: Text(context.problemName(problem.name)),
                  selected: draft.problemType?.id == problem.id,
                  onSelected: (_) => setState(() => draft.problemType = problem),
                ),
            ],
          ),
          SectionTitle(context.l10n.tellUsMore),
          TextField(
            controller: _description,
            minLines: 4,
            maxLines: 6,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: context.l10n.detailsHint),
            onChanged: (value) => setState(() => draft.description = value),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final symptom in symptoms)
                FilterChip(
                  label: Text(context.symptomName(symptom)),
                  selected: draft.symptoms.contains(symptom),
                  onSelected: (on) => setState(() => on ? draft.symptoms.add(symptom) : draft.symptoms.remove(symptom)),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: valid ? () => context.push('/request/photos', extra: draft) : null,
          child: Text(context.l10n.continueLabel),
        ),
      ),
    );
  }
}

/// C09 · Add photos.
class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  static const _max = 6;

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final List<XFile> files;
      if (source == ImageSource.camera) {
        final file = await picker.pickImage(source: source, maxWidth: 1600, imageQuality: 80);
        files = file == null ? [] : [file];
      } else {
        files = await picker.pickMultiImage(maxWidth: 1600, imageQuality: 80, limit: _max - widget.draft.photos.length);
      }
      for (final file in files.take(_max - widget.draft.photos.length)) {
        widget.draft.photos.add(DraftPhoto(await file.readAsBytes(), file.name));
      }
      setState(() {});
    } catch (error) {
      if (mounted) context.showError(context.l10n.photoOpenError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.draft.photos;
    void next() => context.push('/request/location', extra: widget.draft);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.requestDetails)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StepHeader(
            step: 2,
            label: context.l10n.stepPhotos,
            title: context.l10n.addPhotos,
            subtitle: context.l10n.photosSubtitle,
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              for (final (i, photo) in photos.indexed)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(photo.bytes, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => photos.removeAt(i)),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.solid,
                          child: Icon(Icons.close_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              if (photos.length < _max)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _pick(ImageSource.gallery),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.line, width: 1.5),
                      color: AppColors.surface,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded),
                        Text(context.l10n.add, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: photos.length < _max ? () => _pick(ImageSource.camera) : null,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(context.l10n.takePhoto),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: photos.length < _max ? () => _pick(ImageSource.gallery) : null,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(context.l10n.fromGallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(context.l10n.photoTips, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            context.l10n.photoTipsBody,
            style: TextStyle(color: AppColors.inkSoft, height: 1.6),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(onPressed: next, child: Text(context.l10n.continueLabel)),
            if (photos.isEmpty) TextButton(onPressed: next, child: Text(context.l10n.skipForNow)),
          ],
        ),
      ),
    );
  }
}

/// C10 · Location.
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _line1 = TextEditingController();
  final _area = TextEditingController();
  final _city = TextEditingController(text: 'Colombo');
  final _house = TextEditingController();
  final _landmark = TextEditingController();
  late final Future<List<SavedAddress>> _saved = context.repo.addresses().then((list) {
    if (widget.draft.savedAddressId == null && widget.draft.address == null && list.isNotEmpty) {
      final preferred = list.firstWhere((a) => a.isDefault, orElse: () => list.first);
      setState(() => _selectSaved(preferred));
    }
    return list;
  });
  String? _savedId;
  bool _addingNew = false;

  @override
  void initState() {
    super.initState();
    final draft = widget.draft;
    _savedId = draft.savedAddressId;
    final a = draft.address;
    if (a != null) {
      _addingNew = true;
      _line1.text = a.line1;
      _area.text = a.area;
      _city.text = a.city;
      _house.text = a.houseNumber ?? '';
      _landmark.text = a.landmark ?? '';
    }
  }

  @override
  void dispose() {
    for (final c in [_line1, _area, _city, _house, _landmark]) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectSaved(SavedAddress address) {
    _savedId = address.id;
    _addingNew = false;
  }

  bool get _newValid =>
      _line1.text.trim().length >= 3 && _area.text.trim().length >= 2 && _city.text.trim().length >= 2;

  void _confirm() {
    final draft = widget.draft;
    if (_addingNew) {
      draft.savedAddressId = null;
      draft.address = AddressInput(
        line1: _line1.text.trim(),
        area: _area.text.trim(),
        city: _city.text.trim(),
        houseNumber: _house.text.trim(),
        landmark: _landmark.text.trim(),
      );
    } else {
      draft.savedAddressId = _savedId;
      draft.address = null;
    }
    context.push(draft.needsSchedule ? '/request/datetime' : '/request/review', extra: draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.requestDetails)),
      body: FutureBuilder<List<SavedAddress>>(
        future: _saved,
        builder: (context, snapshot) {
          final saved = snapshot.data ?? [];
          final selected = saved.where((a) => a.id == _savedId).firstOrNull;
          final showForm = _addingNew || (snapshot.hasData && saved.isEmpty);
          if (showForm && !_addingNew) _addingNew = true;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: StepHeader(step: 3, label: context.l10n.stepLocation, title: context.l10n.whereShouldComeTitle),
              ),
              MapPanel(
                area: showForm ? (_area.text.isEmpty ? context.l10n.yourArea : _area.text) : (selected?.address.area ?? '…'),
                height: 160,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (saved.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final address in saved)
                            ChoiceChip(
                              avatar: Icon(
                                address.label == 'OFFICE' ? Icons.business_rounded : Icons.home_rounded,
                                size: 18,
                              ),
                              label: Text(context.addressLabelText(address.label)),
                              selected: !_addingNew && _savedId == address.id,
                              onSelected: (_) => setState(() => _selectSaved(address)),
                            ),
                          ChoiceChip(
                            avatar: const Icon(Icons.add_rounded, size: 18),
                            label: Text(context.l10n.addNew),
                            selected: _addingNew,
                            onSelected: (_) => setState(() => _addingNew = true),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (!showForm && selected != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.location_on_rounded),
                          title: Text(selected.address.oneLine, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            [
                              selected.address.city,
                              selected.address.landmark,
                            ].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
                          ),
                        ),
                      ),
                    if (showForm) ...[
                      TextField(
                        controller: _line1,
                        decoration: InputDecoration(labelText: context.l10n.streetAddress),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _area,
                              decoration: InputDecoration(labelText: context.l10n.areaLabel),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _city,
                              decoration: InputDecoration(labelText: context.l10n.cityLabel),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _house,
                        decoration: InputDecoration(labelText: context.l10n.houseNumber),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _landmark,
                        decoration: InputDecoration(labelText: context.l10n.landmarkLabel),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (final label in ['HOME', 'OFFICE', 'OTHER'])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(context.addressLabelText(label)),
                                selected: widget.draft.addressLabel == label,
                                onSelected: (_) => setState(() => widget.draft.addressLabel = label),
                              ),
                            ),
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(context.l10n.saveThisAddress),
                        value: widget.draft.saveAddress,
                        activeTrackColor: AppColors.ink,
                        onChanged: (value) => setState(() => widget.draft.saveAddress = value),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: (_addingNew ? _newValid : _savedId != null) ? _confirm : null,
          child: Text(context.l10n.confirmLocation),
        ),
      ),
    );
  }
}

/// C11 · Date and time.
class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  static const _windows = [(8, 10), (10, 12), (12, 14), (14, 16), (16, 18)];
  late DateTime _day = _days.first;
  (int, int)? _window;

  List<DateTime> get _days {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final hasSlotToday = _windows.any(
      (w) => today.add(Duration(hours: w.$1)).isAfter(now.add(const Duration(hours: 1))),
    );
    return [for (var i = hasSlotToday ? 0 : 1; i < 15; i++) today.add(Duration(days: i))];
  }

  bool _available((int, int) window) =>
      _day.add(Duration(hours: window.$1)).isAfter(DateTime.now().add(const Duration(hours: 1)));

  String _label(BuildContext context, (int, int) w) {
    final locale = Localizations.localeOf(context).languageCode;
    String h(int hour) => DateFormat('h a', locale).format(DateTime(2000, 1, 1, hour));
    return '${h(w.$1)} – ${h(w.$2)}';
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.draft.type == BookingType.inspection ? context.l10n.inspectionVisit : context.l10n.scheduleVisit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(context.l10n.whenShouldWeCome, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMMM y', locale).format(_day),
            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 78,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final day = days[i];
                final selected = day == _day;
                return GestureDetector(
                  onTap: () => setState(() {
                    _day = day;
                    if (_window != null && !_available(_window!)) _window = null;
                  }),
                  child: Container(
                    width: 58,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.solid : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.ink : AppColors.line),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE', locale).format(day),
                          style: TextStyle(
                            color: selected ? AppColors.yellow : AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SectionTitle(context.l10n.arrivalWindow),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final window in _windows)
                ChoiceChip(
                  label: Text(_label(context, window)),
                  selected: _window == window,
                  onSelected: _available(window) ? (_) => setState(() => _window = window) : null,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.visitConfirmNote,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_window != null) ...[
              Text(
                context.l10n.selectedSlot('${DateFormat('EEE d MMM', locale).format(_day)} · ${_label(context, _window!)}'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
            ],
            FilledButton(
              onPressed: _window == null
                  ? null
                  : () {
                      widget.draft
                        ..windowStart = _day.add(Duration(hours: _window!.$1))
                        ..windowEnd = _day.add(Duration(hours: _window!.$2));
                      context.push('/request/review', extra: widget.draft);
                    },
              child: Text(context.l10n.continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// C12 · Review request.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final Future<List<SavedAddress>> _saved = context.repo.addresses();

  Future<void> _submit() async {
    final repo = context.repo;
    final booking = await repo.createBooking(widget.draft);
    var failedPhotos = 0;
    for (final photo in widget.draft.photos) {
      try {
        await repo.uploadPhoto(booking.id, photo.bytes, photo.filename);
      } catch (_) {
        failedPhotos++;
      }
    }
    if (!mounted) return;
    if (failedPhotos > 0) context.toast(context.l10n.photosFailed(failedPhotos));
    context.go('/booking/${booking.id}');
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reviewRequest)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StepHeader(step: 4, label: context.l10n.stepReview, title: context.l10n.checkYourRequest),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryBadge(iconKey: draft.category.iconKey, highlight: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.problemName(draft.title), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                            Text(context.categoryName(draft.category.slug, draft.category.name), style: TextStyle(color: AppColors.muted)),
                          ],
                        ),
                      ),
                      Pill(
                        label: context.bookingTypeLabel(draft.type).toUpperCase(),
                        background: draft.type == BookingType.emergency ? AppColors.yellow : AppColors.background,
                        foreground: draft.type == BookingType.emergency ? AppColors.black : AppColors.ink,
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  FutureBuilder<List<SavedAddress>>(
                    future: _saved,
                    builder: (context, snapshot) {
                      final address =
                          draft.address ??
                          snapshot.data?.where((a) => a.id == draft.savedAddressId).firstOrNull?.address;
                      return _ReviewRow(
                        icon: Icons.location_on_outlined,
                        title: address?.oneLine ?? '…',
                        subtitle: address?.landmark,
                      );
                    },
                  ),
                  if (draft.windowStart != null && draft.needsSchedule)
                    _ReviewRow(icon: Icons.schedule_rounded, title: context.window(draft.windowStart!, draft.windowEnd!)),
                  _ReviewRow(
                    icon: Icons.notes_rounded,
                    title: draft.description.trim(),
                    subtitle: draft.symptoms.isEmpty ? null : draft.symptoms.map(context.symptomName).join(' · '),
                  ),
                  if (draft.photos.isNotEmpty)
                    _ReviewRow(icon: Icons.photo_outlined, title: context.l10n.photosAttached(draft.photos.length)),
                ],
              ),
            ),
          ),
          SectionTitle(context.l10n.estimatedCost),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(context.l10n.visitFee)),
                      Text(
                        context.lkr(draft.category.visitFeeCents),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text(context.l10n.labourAndParts)),
                      Text(context.l10n.quotedOnSite, style: TextStyle(color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.approveFinalCost,
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: Text(context.l10n.payWithCash, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(context.l10n.afterTheJob),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAction(
        child: BusyButton(label: context.l10n.requestTechnician, onPressed: _submit),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(subtitle!, style: TextStyle(color: AppColors.muted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
