import '../models/grand_prix.dart';

abstract interface class F1RepositoryInterface {
  /// Получение календаря всех Гран-при сезона 2026
  Future<List<GrandPrix>> getCalendar();

  /// Получение детальной информации о Гран-при по его ID
  Future<GrandPrix> getGrandPrixById(String id);
}
