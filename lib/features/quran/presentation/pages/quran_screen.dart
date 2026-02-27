import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/surah_list_tile.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Surah List
    final surahs = [
      {
        'number': 1,
        'nameEnglish': 'Al-Fatihah',
        'nameArabic': 'الفاتحة',
        'translation': 'The Opening',
        'verses': 7,
      },
      {
        'number': 2,
        'nameEnglish': 'Al-Baqarah',
        'nameArabic': 'البقرة',
        'translation': 'The Cow',
        'verses': 286,
      },
      {
        'number': 3,
        'nameEnglish': 'Ali \'Imran',
        'nameArabic': 'آل عمران',
        'translation': 'Family of Imran',
        'verses': 200,
      },
      {
        'number': 4,
        'nameEnglish': 'An-Nisa',
        'nameArabic': 'النساء',
        'translation': 'The Women',
        'verses': 176,
      },
      {
        'number': 5,
        'nameEnglish': 'Al-Ma\'idah',
        'nameArabic': 'المائدة',
        'translation': 'The Table Spread',
        'verses': 120,
      },
      {
        'number': 6,
        'nameEnglish': 'Al-An\'am',
        'nameArabic': 'الأنعام',
        'translation': 'The Cattle',
        'verses': 165,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildContinueReadingCard(context),
            Expanded(
              child: ListView.separated(
                itemCount: surahs.length,
                separatorBuilder: (context, index) => Divider(
                  indent: 24.w,
                  endIndent: 24.w,
                  height: 1.h,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final s = surahs[index];
                  return SurahListTile(
                    number: s['number'] as int,
                    nameEnglish: s['nameEnglish'] as String,
                    nameArabic: s['nameArabic'] as String,
                    translation: s['translation'] as String,
                    verses: s['verses'] as int,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueReadingCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).primaryColor.withAlpha((255 * 0.2).toInt()),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, color: Colors.white, size: 20.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Continue Reading',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Al-Baqarah',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Verse 255 (Ayatul Kursi)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha((255 * 0.8).toInt()),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((255 * 0.2).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}
