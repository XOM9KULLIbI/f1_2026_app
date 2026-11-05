import 'package:flutter_test/flutter_test.dart';
import 'package:f1_2026_app/features/home/bloc/home_bloc.dart';
import 'package:f1_2026_app/data/repositories/f1_repository_interface.dart';
import 'package:f1_2026_app/data/models/grand_prix.dart';
import 'package:f1_2026_app/data/mock/mock_f1_data.dart';

class FakeF1Repository implements F1RepositoryInterface {
  @override
  Future<List<GrandPrix>> getCalendar() async {
    return MockF1Data.grandPrixList;
  }

  @override
  Future<GrandPrix> getGrandPrixById(String id) async {
    return MockF1Data.grandPrixList.firstWhere((e) => e.id == id);
  }
}

void main() {
  group('HomeBloc Tests', () {
    late HomeBloc homeBloc;
    late FakeF1Repository repository;

    setUp(() {
      repository = FakeF1Repository();
      homeBloc = HomeBloc(repository);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('Initial state is HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    test('HomeLoad emits [HomeLoadInProgress, HomeLoadSuccess]', () async {
      final expectedStates = [
        isA<HomeLoadInProgress>(),
        isA<HomeLoadSuccess>(),
      ];

      expectLater(homeBloc.stream, emitsInOrder(expectedStates));
      homeBloc.add(const HomeLoad());
    });
  });
}
