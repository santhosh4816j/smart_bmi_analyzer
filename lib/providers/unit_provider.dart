import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/enums.dart';

class UnitProvider extends ChangeNotifier {
  UnitProvider(this._prefs) {
    final String? stored = _prefs.getString(AppConstants.prefUnitSystem);
    _unitSystem = stored == 'imperial' ? UnitSystem.imperial : UnitSystem.metric;
  }

  final SharedPreferences _prefs;
  late UnitSystem _unitSystem;

  UnitSystem get unitSystem => _unitSystem;

  Future<void> setUnitSystem(UnitSystem system) async {
    _unitSystem = system;
    notifyListeners();
    await _prefs.setString(AppConstants.prefUnitSystem, system.name);
  }

  double displayWeight(double kg) =>
      _unitSystem == UnitSystem.metric ? kg : kg * AppConstants.kgToLb;

  double toKg(double displayValue) => _unitSystem == UnitSystem.metric
      ? displayValue
      : displayValue * AppConstants.lbToKg;

  double displayHeight(double cm) =>
      _unitSystem == UnitSystem.metric ? cm : cm * AppConstants.cmToInch;

  double toCm(double displayValue) => _unitSystem == UnitSystem.metric
      ? displayValue
      : displayValue * AppConstants.inchToCm;

  String get weightUnitLabel =>
      _unitSystem == UnitSystem.metric ? 'kg' : 'lb';

  String get heightUnitLabel =>
      _unitSystem == UnitSystem.metric ? 'cm' : 'in';
}
