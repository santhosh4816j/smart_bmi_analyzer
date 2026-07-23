import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/database/hive_boxes.dart';
import '../core/models/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile?> {
  ProfileNotifier() : super(_loadProfile());

  static Box<UserProfile> get _box => Hive.box<UserProfile>(HiveBoxes.profile);

  static UserProfile? _loadProfile() {
    if (_box.isEmpty) return null;
    return _box.getAt(0);
  }

  Future<void> save(UserProfile profile) async {
    if (_box.isEmpty) {
      await _box.add(profile);
    } else {
      await _box.putAt(0, profile);
    }
    state = profile;
  }

  Future<void> updateWeight(double weightKg) async {
    final current = state;
    if (current == null) return;
    current.weightKg = weightKg;
    await current.save();
    state = current;
  }

  bool get hasProfile => state != null;
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  return ProfileNotifier();
});
