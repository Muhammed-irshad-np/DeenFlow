import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_list_tile.dart';
import 'quran_reading_screen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Consumer<QuranProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingSurahs) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.surahsErrorMessage != null) {
              return Center(
                child: Text(
                  'Error loading Surahs: ${provider.surahsErrorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (provider.surahs.isEmpty) {
              return const Center(child: Text('No Surahs found.'));
            }

            final surahs = provider.surahs;

            return Column(
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
                        number: s.number,
                        nameEnglish: s.nameEnglish,
                        nameArabic: s.nameArabic,
                        translation: s
                            .nameEnglish, // Replace with actual translation later
                        verses: s.numberOfAyahs,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContinueReadingCard(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, provider, child) {
        final lastSurahNum = provider.lastReadSurah ?? 1;
        final lastAyahNum = provider.lastReadAyah ?? 1;

        // Find the surah details from the loaded surahs
        Surah? foundSurah;
        for (final s in provider.surahs) {
          if (s.number == lastSurahNum) {
            foundSurah = s;
            break;
          }
        }
        // Fallback to first surah if not found
        final surah = foundSurah ?? provider.surahs.first;

        final title = provider.lastReadSurah == null
            ? 'Start Reading'
            : 'Continue Reading';
        final subtitle = surah.nameEnglish;
        final trailing = provider.lastReadSurah == null
            ? 'Surah Al-Fatihah'
            : 'Verse $lastAyahNum';

        return GestureDetector(
          onTap: () {
            // Navigate to QuranReadingScreen
            // Note: need to implement scrolling to specific ayah later
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuranReadingScreen(
                  surahNumber: surah.number,
                  surahName: surah.nameEnglish,
                  surahArabicName: surah.nameArabic,
                  initialAyah: lastAyahNum,
                ),
              ),
            );
          },
          child: Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        trailing,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha((255 * 0.8).toInt()),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
          ),
        );
      },
    );
  }
}
