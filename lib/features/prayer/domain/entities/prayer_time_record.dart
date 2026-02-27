class PrayerTimeRecord {
  final String name; // e.g., Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
  final DateTime time;
  final DateTime endTime;
  final bool isPrayed;

  const PrayerTimeRecord({
    required this.name,
    required this.time,
    required this.endTime,
    this.isPrayed = false,
  });

  PrayerTimeRecord copyWith({
    String? name,
    DateTime? time,
    DateTime? endTime,
    bool? isPrayed,
  }) {
    return PrayerTimeRecord(
      name: name ?? this.name,
      time: time ?? this.time,
      endTime: endTime ?? this.endTime,
      isPrayed: isPrayed ?? this.isPrayed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrayerTimeRecord &&
        other.name == name &&
        other.time == time &&
        other.endTime == endTime &&
        other.isPrayed == isPrayed;
  }

  @override
  int get hashCode =>
      name.hashCode ^ time.hashCode ^ endTime.hashCode ^ isPrayed.hashCode;
}
