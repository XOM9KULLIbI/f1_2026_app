import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    print('Testing cloudDio.get<String>...');
    final res = await dio.get<String>('https://raw.githubusercontent.com/XOM9KULLIbI/f1_2026_app/main/db.json');
    print('res data type: ${res.data.runtimeType}');
  } catch (e) {
    print('Error caught: $e');
  }
}
