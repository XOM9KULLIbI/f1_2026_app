import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../features/home/home_screen.dart';
import '../../features/details/details_screen.dart';
import '../di/di.dart';

final GlobalKey<NavigatorState> _rootNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigationKey,
  initialLocation: '/home',
  debugLogDiagnostics: true,
  observers: [
    TalkerRouteObserver(talker),
  ],
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/details/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MaterialPage(
          key: state.pageKey,
          child: DetailsScreen(grandPrixId: id),
        );
      },
    ),
  ],
);
