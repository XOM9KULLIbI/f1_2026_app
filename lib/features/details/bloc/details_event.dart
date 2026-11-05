part of 'details_bloc.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object?> get props => [];
}

final class DetailsLoad extends DetailsEvent {
  final String id;
  final Completer? completer;

  const DetailsLoad(this.id, {this.completer});

  @override
  List<Object?> get props => [id, completer];
}
