import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quran_provider.dart';

import 'package:visibility_detector/visibility_detector.dart';

class QuranReadingScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahArabicName;
  final int? initialAyah; // newly added parameter

  const QuranReadingScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.surahArabicName,
    this.initialAyah,
  });

  @override
  State<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends State<QuranReadingScreen> {
  int _lastVisibleAyah = 1;
  final ScrollController _scrollController = ScrollController();
  late QuranProvider _quranProvider;

  @override
  void initState() {
    super.initState();
    _lastVisibleAyah = widget.initialAyah ?? 1;
    _quranProvider = context.read<QuranProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _quranProvider.loadAyahs(widget.surahNumber);

      if (widget.initialAyah != null && widget.initialAyah! > 1) {
        // Simple approximation for scrolling to ayah
        // A more robust solution might use scrollable_positioned_list
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            final approxHeightPerAyah = 150.h; // rough estimate
            final offset = (widget.initialAyah! - 1) * approxHeightPerAyah;
            _scrollController.animateTo(
              offset,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quranProvider.stopAudio();
    super.dispose();
  }

  void _onAyahVisibilityChanged(int ayahNumber, double visibleFraction) {
    if (visibleFraction > 0.5 && _lastVisibleAyah != ayahNumber) {
      _lastVisibleAyah = ayahNumber;
      context.read<QuranProvider>().saveLastRead(
        widget.surahNumber,
        ayahNumber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.surahName,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Text(widget.surahArabicName, style: TextStyle(fontSize: 14.sp)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined), // Font size/Settings
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<QuranProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingAyahs) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.ayahsErrorMessage != null) {
              return Center(
                child: Text(
                  'Error loading Ayahs: ${provider.ayahsErrorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (provider.currentAyahs.isEmpty) {
              return const Center(
                child: Text('No verses found for this Surah.'),
              );
            }

            final ayahs = provider.currentAyahs;

            return ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              itemCount: ayahs.length,
              separatorBuilder: (context, index) => Divider(height: 32.h),
              itemBuilder: (context, index) {
                final v = ayahs[index];
                return VisibilityDetector(
                  key: Key('ayah_${widget.surahNumber}_${v.number}'),
                  onVisibilityChanged: (info) {
                    _onAyahVisibilityChanged(v.number, info.visibleFraction);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withAlpha((255 * 0.1).toInt()),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              v.number.toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              v.textArabic,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontFamily:
                                    'Amiri', // Adjust font family if needed
                                height: 1.8,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        v.textEnglish,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              provider.currentlyPlayingAyah ==
                                          '${widget.surahNumber}_${v.number}' &&
                                      provider.isAudioPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              final isCurrentlyPlaying =
                                  provider.currentlyPlayingAyah ==
                                      '${widget.surahNumber}_${v.number}' &&
                                  provider.isAudioPlaying;
                              if (isCurrentlyPlaying) {
                                provider.stopAudio();
                              } else {
                                provider.playAudio(
                                  widget.surahNumber,
                                  v.number,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            color: Colors.grey.shade600,
                            onPressed: () {
                              final textToShare =
                                  '${v.textArabic}\n\n${v.textEnglish}\n\n- Quran [${widget.surahNumber}:${v.number}]';
                              Share.share(textToShare);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              provider.isBookmarked(
                                    widget.surahNumber,
                                    v.number,
                                  )
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                            ),
                            color:
                                provider.isBookmarked(
                                  widget.surahNumber,
                                  v.number,
                                )
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade600,
                            onPressed: () {
                              provider.toggleBookmark(
                                widget.surahNumber,
                                v.number,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
