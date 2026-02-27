import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int number;
  final int surahNumber;
  final String textArabic;
  final String textEnglish;

  const Ayah({
    required this.number,
    required this.surahNumber,
    required this.textArabic,
    required this.textEnglish,
  });

  @override
  List<Object?> get props => [number, surahNumber, textArabic, textEnglish];
}
