import 'package:flutter/material.dart';

class QuranReadingScreen extends StatelessWidget {
  final String surahName;
  final String surahArabicName;

  const QuranReadingScreen({
    super.key,
    required this.surahName,
    required this.surahArabicName,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy verses
    final verses = [
      {
        'number': 1,
        'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'translation':
            'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      },
      {
        'number': 2,
        'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'translation': '[All] praise is [due] to Allah, Lord of the worlds -',
      },
      {
        'number': 3,
        'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
        'translation': 'The Entirely Merciful, the Especially Merciful,',
      },
      {
        'number': 4,
        'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
        'translation': 'Sovereign of the Day of Recompense.',
      },
      {
        'number': 5,
        'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'translation': 'It is You we worship and You we ask for help.',
      },
      {
        'number': 6,
        'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'translation': 'Guide us to the straight path -',
      },
      {
        'number': 7,
        'arabic':
            'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        'translation':
            'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              surahName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(surahArabicName, style: const TextStyle(fontSize: 14)),
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
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          itemCount: verses.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            final v = verses[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withAlpha((255 * 0.1).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        v['number'].toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        v['arabic'] as String,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 28,
                          fontFamily: 'Amiri',
                          height: 1.8,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  v['translation'] as String,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      color: Colors.grey.shade600,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline),
                      color: Colors.grey.shade600,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
