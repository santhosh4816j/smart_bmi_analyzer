import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../models/bmi_record_model.dart';
import '../models/enums.dart';
import '../models/profile_model.dart';
import '../repositories/bmi_record_repository.dart';
import '../repositories/profile_repository.dart';
import '../services/bmi_calculator_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({
    required ProfileRepository profileRepository,
    required BmiRecordRepository bmiRecordRepository,
    required SharedPreferences prefs,
  })  : _profileRepository = profileRepository,
        _bmiRecordRepository = bmiRecordRepository,
        _prefs = prefs {
    _profiles = _profileRepository.getAll();
    final String? activeId = _prefs.getString(AppConstants.prefActiveProfileId);
    if (activeId != null && _profiles.any((ProfileModel p) => p.id == activeId)) {
      _activeProfileId = activeId;
    } else if (_profiles.isNotEmpty) {
      _activeProfileId = _profiles.first.id;
    }
  }

  final ProfileRepository _profileRepository;
  final BmiRecordRepository _bmiRecordRepository;
  final SharedPreferences _prefs;
  static const Uuid _uuid = Uuid();

  List<ProfileModel> _profiles = <ProfileModel>[];
  String? _activeProfileId;

  List<ProfileModel> get profiles => List<ProfileModel>.unmodifiable(_profiles);

  ProfileModel? get activeProfile => _activeProfileId == null
      ? null
      : _profileRepository.getById(_activeProfileId!);

  String? get activeProfileId => _activeProfileId;

  List<ProfileModel> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return profiles;
    return _profiles
        .where((ProfileModel p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> setActiveProfile(String id) async {
    _activeProfileId = id;
    notifyListeners();
    await _prefs.setString(AppConstants.prefActiveProfileId, id);
  }

  Future<ProfileModel> createProfile({
    required String name,
    required int age,
    required BiologicalSex sex,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activityLevel,
    required FitnessGoal goal,
    double? goalWeightKg,
    String? photoPath,
    String? notes,
    DietPreference? dietPreference,
  }) async {
    final ProfileModel profile = ProfileModel(
      id: _uuid.v4(),
      name: name,
      age: age,
      sex: sex,
      heightCm: heightCm,
      weightKg: weightKg,
      activityLevel: activityLevel,
      goal: goal,
      goalWeightKg: goalWeightKg,
      photoPath: photoPath,
      notes: notes,
      dietPreference: dietPreference,
    );
    await _profileRepository.save(profile);
    await _recordInitialMeasurement(profile);
    _profiles = _profileRepository.getAll();
    if (_activeProfileId == null) {
      await setActiveProfile(profile.id);
    }
    notifyListeners();
    return profile;
  }

  Future<void> _recordInitialMeasurement(ProfileModel profile) async {
    final double bmi = BmiCalculatorService.calculateBmi(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
    );
    await _bmiRecordRepository.add(
      BmiRecordModel(
        id: _uuid.v4(),
        profileId: profile.id,
        weightKg: profile.weightKg,
        bmi: bmi,
        recordedAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateProfile(ProfileModel updated) async {
    await _profileRepository.save(updated);
    _profiles = _profileRepository.getAll();
    notifyListeners();
  }

  /// Updates the profile's current weight and logs a new history point —
  /// this is the entry point for "log today's weight" flows.
  Future<void> logWeight(String profileId, double weightKg, {String? note}) async {
    final ProfileModel? profile = _profileRepository.getById(profileId);
    if (profile == null) return;
    final ProfileModel updated = profile.copyWith(weightKg: weightKg);
    await _profileRepository.save(updated);

    final double bmi = BmiCalculatorService.calculateBmi(
      weightKg: weightKg,
      heightCm: updated.heightCm,
    );
    await _bmiRecordRepository.add(
      BmiRecordModel(
        id: _uuid.v4(),
        profileId: profileId,
        weightKg: weightKg,
        bmi: bmi,
        recordedAt: DateTime.now(),
        note: note,
      ),
    );
    _profiles = _profileRepository.getAll();
    notifyListeners();
  }

  List<BmiRecordModel> historyFor(String profileId) =>
      _bmiRecordRepository.getAllForProfile(profileId);

  Future<void> deleteProfile(String id) async {
    await _profileRepository.delete(id);
    await _bmiRecordRepository.deleteAllForProfile(id);
    _profiles = _profileRepository.getAll();
    if (_activeProfileId == id) {
      _activeProfileId = _profiles.isNotEmpty ? _profiles.first.id : null;
      if (_activeProfileId != null) {
        await _prefs.setString(AppConstants.prefActiveProfileId, _activeProfileId!);
      } else {
        await _prefs.remove(AppConstants.prefActiveProfileId);
      }
    }
    notifyListeners();
  }
}
