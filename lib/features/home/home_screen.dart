import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/di/di.dart';
import '../../app/extensions/num_extensions.dart';
import '../../app/theme/theme_colors.dart';
import '../../app/widgets/app_error.dart';
import '../../app/widgets/app_progress_indicator.dart';
import '../../data/models/grand_prix.dart';
import 'bloc/home_bloc.dart';
import 'widgets/gp_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>();
    _loadCalendar();
  }

  void _loadCalendar() {
    _homeBloc.add(const HomeLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkCarbon,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: ThemeColors.darkCarbon,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ThemeColors.racingRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'F1',
                      style: TextStyle(
                        fontFamily: 'Formula1',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  8.pw,
                  const Text(
                    'SEASON 2026',
                    style: TextStyle(
                      fontFamily: 'Formula1',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: ThemeColors.white),
                tooltip: 'Обновить календарь',
                onPressed: _loadCalendar,
              ),
            ],
          ),
        ],
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            return switch (state) {
              HomeInitial() => const SizedBox.shrink(),
              HomeLoadInProgress() => const AppProgressIndicator(
                  message: 'Загрузка официального календаря F1 2026...',
                ),
              HomeLoadSuccess() => _buildCalendarList(state.grandPrixList),
              HomeLoadFailure() => AppError(
                  description: state.exception.toString(),
                  onTap: _loadCalendar,
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildCalendarList(List<GrandPrix> races) {
    final totalRaces = races.length;
    final completed = races.where((r) => r.isCompleted).length;
    final unknown = races.where((r) => r.isUnknown).length;
    final upcoming = races.where((r) => r.isUpcoming).length;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: totalRaces + 1,
      separatorBuilder: (_, __) => 12.ph,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeaderInfo(totalRaces, completed, unknown, upcoming);
        }
        final gp = races[index - 1];
        return GpCard(grandPrix: gp);
      },
    );
  }

  Widget _buildHeaderInfo(int totalRaces, int completed, int unknown, int upcoming) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: ThemeColors.racingRed, size: 16),
              8.pw,
              const Text(
                'ОФИЦИАЛЬНЫЙ КАЛЕНДАРЬ И РЕЗУЛЬТАТЫ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: ThemeColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          6.ph,
          Text(
            'Всего этапов в сезоне: $totalRaces ($completed завершено, $unknown неизвестен, $upcoming предстоящих)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ThemeColors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
