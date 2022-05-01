import 'package:shared_preferences/shared_preferences.dart';

class _SharedPreferencesState {
  // Values here
  // ex.: double lastMapCameraLat;

  _SharedPreferencesState(
      //this.lastMapCameraLat,
      );

  // Keys
  // ex.: static const lastMapCameraLatKey = 'lastMapCameraLat';
}

class SharedPreferencesService {
  final _currentPrefs = _SharedPreferencesState();

  // getters
  // ex.: double get lastMapCameraLat => _currentPrefs.lastMapCameraLat;

  SharedPreferencesService() {
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // load values from prefs
    // final lastMapCameraLat =
    //     prefs.get(_SharedPreferencesState.lastMapCameraLatKey);

    //_currentPrefs
    // ..lastMapCameraLat = lastMapCameraLat
  }

  // Setters
  // set lastMapCameraLat(double newValue) {
  //   if (newValue == _currentPrefs.lastMapCameraLat) return;
  //   _currentPrefs.lastMapCameraLat = newValue;
  //   _savePreference(_SharedPreferencesState.lastMapCameraLatKey, newValue);
  // }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case bool:
        await prefs.setBool(key, value);
        break;
      case double:
        await prefs.setDouble(key, value);
        break;
      case int:
        await prefs.setInt(key, value);
        break;
      case String:
        await prefs.setString(key, value);
        break;
      default:
        throw Exception(
          "${value.runtimeType} isn't supported as SharedPreferences value.",
        );
    }
  }
}
