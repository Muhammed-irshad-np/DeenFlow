enum CalculationMethodType {
  auto,
  mwl,
  isna,
  egypt,
  makkah,
  karachi,
  tehran,
  singapore,
  gulf,
  kuwait,
  qatar,
  turkey,
  morocco,
  custom,
}

enum MadhabType { shafi, hanafi }

class PrayerSettings {
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final CalculationMethodType calculationMethod;
  final MadhabType madhab;

  const PrayerSettings({
    this.latitude,
    this.longitude,
    this.locationName,
    this.calculationMethod = CalculationMethodType.auto,
    this.madhab = MadhabType.shafi,
  });

  PrayerSettings copyWith({
    double? latitude,
    double? longitude,
    String? locationName,
    CalculationMethodType? calculationMethod,
    MadhabType? madhab,
  }) {
    return PrayerSettings(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrayerSettings &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.locationName == locationName &&
        other.calculationMethod == calculationMethod &&
        other.madhab == madhab;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        locationName.hashCode ^
        calculationMethod.hashCode ^
        madhab.hashCode;
  }
}
