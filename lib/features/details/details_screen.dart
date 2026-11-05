import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/di/di.dart';
import '../../app/extensions/num_extensions.dart';
import '../../app/theme/theme_colors.dart';
import '../../app/widgets/app_error.dart';
import '../../app/widgets/app_progress_indicator.dart';
import '../../data/models/grand_prix.dart';
import 'bloc/details_bloc.dart';
import 'widgets/podium_widget.dart';

class DetailsScreen extends StatefulWidget {
  final String grandPrixId;

  const DetailsScreen({super.key, required this.grandPrixId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final DetailsBloc _detailsBloc;

  @override
  void initState() {
    super.initState();
    _detailsBloc = getIt<DetailsBloc>();
    _loadDetails();
  }

  void _loadDetails() {
    _detailsBloc.add(DetailsLoad(widget.grandPrixId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkCarbon,
      body: BlocBuilder<DetailsBloc, DetailsState>(
        bloc: _detailsBloc,
        builder: (context, state) {
          return switch (state) {
            DetailsInitial() => const SizedBox.shrink(),
            DetailsLoadInProgress() => const AppProgressIndicator(
                message: 'Загрузка информации о Гран-при...',
              ),
            DetailsLoadSuccess() => _buildDetailsContent(state.grandPrix),
            DetailsLoadFailure() => Scaffold(
                appBar: AppBar(title: const Text('Ошибка')),
                body: AppError(
                  description: state.exception.toString(),
                  onTap: _loadDetails,
                ),
              ),
          };
        },
      ),
    );
  }

  Widget _buildDetailsContent(GrandPrix gp) {
    const accentColor = ThemeColors.racingRed;

    return Scaffold(
      backgroundColor: ThemeColors.darkCarbon,
      appBar: AppBar(
        backgroundColor: ThemeColors.darkCarbon,
        elevation: 0,
        title: Text(
          'ROUND ${gp.round} • ${gp.place}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: ThemeColors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: ThemeColors.cardBorder,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ThemeColors.cardBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ROUND ${gp.round}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeColors.darkCarbon,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ThemeColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: ThemeColors.grey),
                            4.pw,
                            Text(
                              gp.date,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ThemeColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  14.ph,
                  Text(
                    gp.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.white,
                      height: 1.3,
                    ),
                  ),
                  8.ph,
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: ThemeColors.racingRed),
                      6.pw,
                      Expanded(
                        child: Text(
                          gp.place,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      8.pw,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ThemeColors.darkCarbon,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ThemeColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          gp.status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: ThemeColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.ph,

            // Results Section
            if (gp.isCompleted) ...[
              PodiumWidget(grandPrix: gp),
            ] else if (gp.isUnknown) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ThemeColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.help_outline, color: ThemeColors.grey, size: 22),
                    12.pw,
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Результат заезда неизвестен',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Официальные данные о победителях и времени финиша отсутствуют в протоколе.',
                            style: TextStyle(
                              fontSize: 13,
                              color: ThemeColors.grey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: ThemeColors.grey, size: 20),
                    10.pw,
                    Expanded(
                      child: Text(
                        'Этап состоится ${gp.date}. Гонка еще не состоялась.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: ThemeColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
