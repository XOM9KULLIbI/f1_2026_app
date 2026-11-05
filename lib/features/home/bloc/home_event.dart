part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeLoad extends HomeEvent {
  final Completer? completer;

  const HomeLoad({this.completer});

  @override
  List<Object?> get props => [completer];
}

final class HomeRefresh extends HomeEvent {
  final Completer? completer;

  const HomeRefresh({this.completer});

  @override
  List<Object?> get props => [completer];
}
