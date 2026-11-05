import 'package:flutter/material.dart';
import '../../../app/extensions/num_extensions.dart';
import '../../../app/theme/theme_colors.dart';
import '../../../data/models/grand_prix.dart';

class PodiumWidget extends StatelessWidget {
  final GrandPrix grandPrix;

  const PodiumWidget({super.key, required this.grandPrix});

  @override
  Widget build(BuildContext context) {
    if (!grandPrix.isCompleted) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: ThemeColors.gold, size: 20),
              8.pw,
              const Text(
                'Результаты этапа (Подиум)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.white,
                ),
              ),
            ],
          ),
          14.ph,

          // 1st place
          _buildPodiumRow(
            placeBadge: '1st',
            badgeColor: ThemeColors.gold,
            driver: '${grandPrix.p1Name} (${grandPrix.p1Code})',
            time: grandPrix.p1Time ?? '',
            isWinner: true,
          ),
          10.ph,

          // 2nd place
          _buildPodiumRow(
            placeBadge: '2nd',
            badgeColor: const Color(0xFFC0C0C8),
            driver: '${grandPrix.p2Name} (${grandPrix.p2Code})',
            time: grandPrix.p2Time ?? '',
          ),
          10.ph,

          // 3rd place
          _buildPodiumRow(
            placeBadge: '3rd',
            badgeColor: const Color(0xFFCD7F32),
            driver: '${grandPrix.p3Name} (${grandPrix.p3Code})',
            time: grandPrix.p3Time ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumRow({
    required String placeBadge,
    required Color badgeColor,
    required String driver,
    required String time,
    bool isWinner = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.darkCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWinner ? ThemeColors.gold.withValues(alpha: 0.5) : ThemeColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              placeBadge,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          12.pw,
          Expanded(
            child: Text(
              driver,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
                color: ThemeColors.white,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: isWinner ? ThemeColors.gold : ThemeColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
