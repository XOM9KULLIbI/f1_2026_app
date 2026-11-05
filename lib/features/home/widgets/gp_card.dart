import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/extensions/num_extensions.dart';
import '../../../app/theme/theme_colors.dart';
import '../../../data/models/grand_prix.dart';

class GpCard extends StatelessWidget {
  final GrandPrix grandPrix;

  const GpCard({
    super.key,
    required this.grandPrix,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = ThemeColors.racingRed;

    return InkWell(
      onTap: () => context.push('/details/${grandPrix.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ThemeColors.cardBorder,
            width: 1.0,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Accent Stripe
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Round badge, status & date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ROUND ${grandPrix.round}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            grandPrix.date,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ThemeColors.grey,
                            ),
                          ),
                        ],
                      ),
                      8.ph,

                      // Place & Title
                      Text(
                        grandPrix.place,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.white,
                        ),
                      ),
                      2.ph,
                      Text(
                        grandPrix.title,
                        style: const TextStyle(
                          fontSize: 11,
                          color: ThemeColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      10.ph,

                      // Results row
                      if (grandPrix.isCompleted) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThemeColors.darkCarbon,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ThemeColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Text('🥇 ', style: TextStyle(fontSize: 12)),
                              Text(
                                '${grandPrix.p1Name} (${grandPrix.p1Code})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.gold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                grandPrix.p1Time ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: ThemeColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (grandPrix.isUnknown) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThemeColors.darkCarbon,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ThemeColors.cardBorder),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.help_outline, size: 14, color: ThemeColors.grey),
                              SizedBox(width: 6),
                              Text(
                                'Результат неизвестен',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text(
                          '📅 Предстоящий этап',
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
