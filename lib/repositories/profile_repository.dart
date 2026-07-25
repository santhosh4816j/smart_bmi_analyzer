import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../models/profile_model.dart';

/// Data-access layer for [ProfileModel] — the only place that touches
/// the Hive box directly. Providers depend on this, never on Hive.
class ProfileRepository {
  ProfileRepository(this._box);

  final Box<ProfileModel> _box;

  static Future<ProfileRepository> open() async {
    final Box<ProfileModel> box =
        await Hive.openBox<ProfileModel>(AppConstants.profileBoxName);
    return ProfileRepository(box);
  }

  List<ProfileModel> getAll() => _box.values.toList(growable: false);

  ProfileModel? getById(String id) => _box.get(id);

  Future<void> save(ProfileModel profile) => _box.put(profile.id, profile);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> clearAll() => _box.clear();
}
