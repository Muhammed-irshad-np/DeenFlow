import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String revelationType;
  final int numberOfAyahs;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  @override
  List<Object?> get props => [
    number,
    nameArabic,
    nameEnglish,
    revelationType,
    numberOfAyahs,
  ];
}
