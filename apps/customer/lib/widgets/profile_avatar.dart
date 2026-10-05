import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/models.dart';
import 'common.dart';

/// The customer's photo, or their initials until they add one.
class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key, required this.profile, this.size = 56});

  final Profile profile;
  final double size;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  // Photos by version, so reopening a screen doesn't download the same photo again.
  static final _cache = <String, Uint8List>{};

  Future<Uint8List>? _future;
  String? _loadedVersion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  @override
  void didUpdateWidget(ProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _load();
  }

  void _load() {
    final version = widget.profile.hasPhoto ? widget.profile.photoVersion : null;
    if (version == _loadedVersion) return;
    _loadedVersion = version;
    if (version == null) {
      _future = null;
    } else if (_cache.containsKey(version)) {
      _future = Future.value(_cache[version]);
    } else {
      _future = context.repo.profilePhoto().then((bytes) => _cache[version] = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = Avatar(name: widget.profile.fullName ?? '?', size: widget.size, dark: false);
    final future = _future;
    if (future == null) return initials;
    return FutureBuilder<Uint8List>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return initials;
        return CircleAvatar(
          radius: widget.size / 2,
          backgroundImage: MemoryImage(snapshot.data!),
        );
      },
    );
  }
}
