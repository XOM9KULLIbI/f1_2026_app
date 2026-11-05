import 'dart:convert';
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

  // Smart 3-tier networking:
  // 1. Local REST API (http://127.0.0.1:8080) for PC / emulator
  // 2. Real Cloud GitHub API (https://raw.githubusercontent.com/...) for smartphone
  // 3. Resilient Offline Dataset if airplane mode / no internet
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        final path = error.requestOptions.path;
        talker.warning('Local API unreachable (${error.message}). Querying Cloud REST API...');

        // Tier 2: Real Cloud REST API over Internet
        try {
          final cloudDio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );
          final cloudResponse = await cloudDio.get<String>(
            'https://raw.githubusercontent.com/XOM9KULLIbI/f1_2026_app/main/db.json',
          );

          if (cloudResponse.statusCode == 200 && cloudResponse.data != null) {
            final Map<String, dynamic> db = jsonDecode(cloudResponse.data!) as Map<String, dynamic>;
            final calendarList = db['calendar'] as List<dynamic>;

            if (path.contains(Endpoints.calendar)) {
              talker.info('Cloud API Success: Fetched ${calendarList.length} rounds from GitHub cloud!');
              return handler.resolve(
                Response(
                  requestOptions: error.requestOptions,
                  data: calendarList,
                  statusCode: 200,
                ),
              );
            } else if (path.contains(Endpoints.grandPrix)) {
              final parts = path.split('/');
              final id = parts.isNotEmpty ? parts.last : '';
              final match = calendarList.cast<Map<String, dynamic>>().firstWhere(
                    (e) => e['id'] == id,
                    orElse: () => calendarList.first as Map<String, dynamic>,
                  );
              talker.info('Cloud API Success: Fetched $id from GitHub cloud!');
              return handler.resolve(
                Response(
                  requestOptions: error.requestOptions,
                  data: match,
                  statusCode: 200,
                ),
              );
            }
          }
        } catch (cloudErr) {
          talker.warning('Cloud API unavailable ($cloudErr), using offline fallback dataset.');
        }

        // Tier 3: Offline fallback
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
