import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  const AyahModel({
    required super.number,
    required super.surahNumber,
    required super.textArabic,
    required super.textEnglish,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int,
      surahNumber: json['surah_number'] as int,
      textArabic: json['text_arabic'] as String,
      textEnglish: json['text_english'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'surah_number': surahNumber,
      'text_arabic': textArabic,
      'text_english': textEnglish,
    };
  }
}
