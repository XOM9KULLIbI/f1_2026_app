import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di/di.dart';
import '../../../data/models/grand_prix.dart';
import '../../../data/repositories/f1_repository_interface.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final F1RepositoryInterface repository;

  DetailsBloc(this.repository) : super(DetailsInitial()) {
    on<DetailsLoad>(_onLoad);
  }

  Future<void> _onLoad(DetailsLoad event, Emitter<DetailsState> emit) async {
    try {
      emit(DetailsLoadInProgress());
      final gp = await repository.getGrandPrixById(event.id);
      emit(DetailsLoadSuccess(grandPrix: gp));
    } catch (e, st) {
      talker.handle(e, st);
      emit(DetailsLoadFailure(exception: e));
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
