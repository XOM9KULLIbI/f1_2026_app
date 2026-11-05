part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadInProgress extends HomeState {}

final class HomeLoadSuccess extends HomeState {
  final List<GrandPrix> grandPrixList;

  const HomeLoadSuccess({required this.grandPrixList});

  @override
  List<Object?> get props => [grandPrixList];
}

final class HomeLoadFailure extends HomeState {
  final Object? exception;

  const HomeLoadFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
