import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_time_record.dart';
import '../../domain/usecases/get_daily_prayer_times.dart';
import '../../domain/usecases/track_prayer.dart';
import '../../domain/usecases/update_prayer_settings.dart';

class PrayerProvider extends ChangeNotifier {
  final GetDailyPrayerTimes getDailyPrayerTimes;
  final GetPrayerSettings getPrayerSettings;
  final UpdatePrayerSettings updatePrayerSettings;
  final TrackPrayer trackPrayer;

  PrayerProvider({
    required this.getDailyPrayerTimes,
    required this.getPrayerSettings,
    required this.updatePrayerSettings,
    required this.trackPrayer,
  }) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<PrayerTimeRecord> _todayPrayers = [];
  List<PrayerTimeRecord> get todayPrayers => _todayPrayers;

  PrayerSettings _settings = const PrayerSettings();
  PrayerSettings get settings => _settings;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await getPrayerSettings(const NoParams());
      await _fetchLocationAndUpdateSettingsIfNeeded();
      await _loadPrayersForSelectedDate();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> retry() async {
    _errorMessage = null;
    await _init();
  }

  Future<void> refreshLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _fetchLocationAndUpdateSettingsIfNeeded(force: true);
    await _loadPrayersForSelectedDate();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchLocationAndUpdateSettingsIfNeeded({
    bool force = false,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (force) _errorMessage = "Location services are disabled.";
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (force) _errorMessage = "Location permissions are denied.";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (force) _errorMessage = "Location permissions are permanently denied.";
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();

      if (force ||
          _settings.latitude != position.latitude ||
          _settings.longitude != position.longitude ||
          _settings.locationName == null) {
        String? locName;
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;

            // Format a nice location string, e.g., "Dubai, United Arab Emirates"
            final city = place.locality?.isNotEmpty == true
                ? place.locality
                : place.subAdministrativeArea;

            if (city != null && place.country != null) {
              locName = '$city, ${place.country}';
            } else if (place.country != null) {
              locName = place.country;
            } else {
              locName =
                  'Lat: ${position.latitude.toStringAsFixed(2)}, Lng: ${position.longitude.toStringAsFixed(2)}';
            }
          }
        } catch (_) {}

        // Fallback if reverse geocoding fails
        locName ??=
            'Lat: ${position.latitude.toStringAsFixed(2)}, Lng: ${position.longitude.toStringAsFixed(2)}';

        _settings = _settings.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: locName,
        );
        await updatePrayerSettings(_settings);
      }
    } catch (_) {
      if (force) _errorMessage = "Failed to get current location.";
      // Handle silently if not forced, fallback to existing setting if any
    }
  }

  Future<void> _loadPrayersForSelectedDate() async {
    if (_settings.latitude == null || _settings.longitude == null) {
      _errorMessage =
          "Location permission is required to calculate accurate prayer times.";
      return;
    }

    _errorMessage = null;
    _todayPrayers = await getDailyPrayerTimes(
      GetDailyPrayerTimesParams(date: _selectedDate, settings: _settings),
    );
  }

  Future<void> togglePrayerStatus(PrayerTimeRecord record) async {
    if (_isLoading) return;

    final updatedRecord = record.copyWith(isPrayed: !record.isPrayed);

    // Optimistic UI update
    final index = _todayPrayers.indexWhere((p) => p.name == record.name);
    if (index != -1) {
      _todayPrayers[index] = updatedRecord;
      notifyListeners();
    }

    try {
      await trackPrayer(updatedRecord);
    } catch (e) {
      // Revert optimism
      if (index != -1) {
        _todayPrayers[index] = record;
        _errorMessage = "Failed to update prayer status";
        notifyListeners();
      }
    }
  }

  Future<void> changeDate(DateTime date) async {
    _selectedDate = date;
    _isLoading = true;
    notifyListeners();
    await _loadPrayersForSelectedDate();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCalculationMethod(CalculationMethodType method) async {
    _settings = _settings.copyWith(calculationMethod: method);
    _isLoading = true;
    notifyListeners();
    await updatePrayerSettings(_settings);
    await _loadPrayersForSelectedDate();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateMadhab(MadhabType madhab) async {
    _settings = _settings.copyWith(madhab: madhab);
    _isLoading = true;
    notifyListeners();
    await updatePrayerSettings(_settings);
    await _loadPrayersForSelectedDate();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLocationManually(String locationName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _settings = _settings.copyWith(
          latitude: loc.latitude,
          longitude: loc.longitude,
          locationName: locationName,
        );
        await updatePrayerSettings(_settings);
        await _loadPrayersForSelectedDate();
      } else {
        _errorMessage = "Could not find coordinates for $locationName.";
      }
    } catch (e) {
      _errorMessage = "Failed to find location: $locationName";
    }

    _isLoading = false;
    notifyListeners();
  }
}
