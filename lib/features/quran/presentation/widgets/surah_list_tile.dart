import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurahListTile extends StatelessWidget {
  final int number;
  final String nameEnglish;
  final String nameArabic;
  final String translation;
  final int verses;

  const SurahListTile({
    super.key,
    required this.number,
    required this.nameEnglish,
    required this.nameArabic,
    required this.translation,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          '/quran/read',
          extra: {'nameEnglish': nameEnglish, 'nameArabic': nameArabic},
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.star_border, // Simple geometric star placeholder
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  number.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameEnglish,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        translation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$verses Verses',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              nameArabic,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontFamily:
                    'Amiri', // Usually good for Quranic text, assuming system fallback if not present
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
