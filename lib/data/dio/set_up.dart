import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../../app/di/di.dart';
import '../endpoints.dart';
import '../mock/mock_f1_data.dart';

void setUpDio({String? baseUrl}) {
  dio.options.baseUrl = baseUrl ?? 'http://127.0.0.1:8080/v1';
  dio.options.connectTimeout = const Duration(seconds: 3);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  dio.options.headers = {
    'Accept': 'application/json',
    'X-Client': 'F1_Flutter_2026',
  };

  // Resilient fallback interceptor:
  // Tries local REST server first; if server is offline, transparently returns official mock data
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        talker.warning('Local API unreachable (${error.message}), falling back to local dataset');
        final path = error.requestOptions.path;
        if (path.contains(Endpoints.calendar)) {
          final data = MockF1Data.grandPrixList.map((e) => e.toJson()).toList();
          return handler.resolve(
            Response(
              requestOptions: error.requestOptions,
              data: data,
              statusCode: 200,
            ),
          );
        } else if (path.contains(Endpoints.grandPrix)) {
          final parts = path.split('/');
          final id = parts.isNotEmpty ? parts.last : '';
          final match = MockF1Data.grandPrixList.firstWhere(
            (e) => e.id == id,
            orElse: () => MockF1Data.grandPrixList.first,
          );
          return handler.resolve(
            Response(
              requestOptions: error.requestOptions,
              data: match.toJson(),
              statusCode: 200,
            ),
          );
        }
        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
        printResponseData: true,
      ),
    ),
  );
}
