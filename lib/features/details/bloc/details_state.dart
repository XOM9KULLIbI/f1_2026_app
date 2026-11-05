part of 'details_bloc.dart';

sealed class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

final class DetailsInitial extends DetailsState {}

final class DetailsLoadInProgress extends DetailsState {}

final class DetailsLoadSuccess extends DetailsState {
  final GrandPrix grandPrix;

  const DetailsLoadSuccess({required this.grandPrix});

  @override
  List<Object?> get props => [grandPrix];
}

final class DetailsLoadFailure extends DetailsState {
  final Object? exception;

  const DetailsLoadFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
