import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di/di.dart';
import '../../../data/models/grand_prix.dart';
import '../../../data/repositories/f1_repository_interface.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final F1RepositoryInterface repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<HomeLoad>(_onLoad);
    on<HomeRefresh>(_onRefresh);
  }

  Future<void> _onLoad(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      if (state is! HomeLoadSuccess) {
        emit(HomeLoadInProgress());
      }
      final list = await repository.getCalendar();
      emit(HomeLoadSuccess(grandPrixList: list));
    } catch (e, st) {
      talker.handle(e, st);
      emit(HomeLoadFailure(exception: e));
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    try {
      final list = await repository.getCalendar();
      emit(HomeLoadSuccess(grandPrixList: list));
    } catch (e, st) {
      talker.handle(e, st);
      emit(HomeLoadFailure(exception: e));
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
