import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.nameArabic,
    required super.nameEnglish,
    required super.revelationType,
    required super.numberOfAyahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameArabic: json['name_arabic'] as String,
      nameEnglish: json['name_english'] as String,
      revelationType: json['revelation_type'] as String,
      numberOfAyahs: json['number_of_ayahs'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name_arabic': nameArabic,
      'name_english': nameEnglish,
      'revelation_type': revelationType,
      'number_of_ayahs': numberOfAyahs,
    };
  }
}
