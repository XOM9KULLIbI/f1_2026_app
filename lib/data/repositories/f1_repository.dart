import 'package:dio/dio.dart';
import '../endpoints.dart';
import '../models/grand_prix.dart';
import 'f1_repository_interface.dart';

class F1Repository implements F1RepositoryInterface {
  final Dio dio;

  const F1Repository({required this.dio});

  @override
  Future<List<GrandPrix>> getCalendar() async {
    final response = await dio.get(Endpoints.calendar);
    final list = response.data as List<dynamic>;
    return list.map((json) => GrandPrix.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<GrandPrix> getGrandPrixById(String id) async {
    final response = await dio.get('${Endpoints.grandPrix}/$id');
    return GrandPrix.fromJson(response.data as Map<String, dynamic>);
  }
}
