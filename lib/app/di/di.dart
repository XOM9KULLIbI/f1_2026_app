import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/dio/set_up.dart';
import '../../data/repositories/f1_repository.dart';
import '../../data/repositories/f1_repository_interface.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/details/bloc/details_bloc.dart';

final GetIt getIt = GetIt.instance;
final Talker talker = TalkerFlutter.init();
final Dio dio = Dio();

Future<void> setupLocator() async {
  getIt.registerSingleton<Talker>(talker);

  setUpDio();
  getIt.registerSingleton<Dio>(dio);

  // Репозиторий
  getIt.registerLazySingleton<F1RepositoryInterface>(
    () => F1Repository(dio: getIt<Dio>()),
  );

  // BLoC первого экрана (Список Гран-при)
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<F1RepositoryInterface>()),
  );

  // BLoC второго экрана (Детальная информация о Гран-при)
  getIt.registerFactory<DetailsBloc>(
    () => DetailsBloc(getIt<F1RepositoryInterface>()),
  );
}
