import '../../domain/entities/prayer_time_record.dart';

class PrayerTimeRecordModel extends PrayerTimeRecord {
  const PrayerTimeRecordModel({
    required super.name,
    required super.time,
    required super.endTime,
    super.isPrayed,
  });

  factory PrayerTimeRecordModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeRecordModel(
      name: json['name'],
      time: DateTime.parse(json['time']),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.parse(json['time']).add(const Duration(hours: 2)),
      isPrayed: json['isPrayed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isPrayed': isPrayed ? 1 : 0,
      'date':
          "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
    };
  }

  factory PrayerTimeRecordModel.fromEntity(PrayerTimeRecord entity) {
    return PrayerTimeRecordModel(
      name: entity.name,
      time: entity.time,
      endTime: entity.endTime,
      isPrayed: entity.isPrayed,
    );
  }
}
