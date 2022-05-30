part of 'competition_cubit.dart';

abstract class CompetitionState extends Equatable {
  final List<Competition>? data;
  const CompetitionState({this.data});

  @override
  List<Object> get props => [data!];

  CompetitionLoaded copyWith({List<Competition>? newData}) {
    return CompetitionLoaded(data: newData ?? this.data);
  }
}

class CompetitionLoading extends CompetitionState {}

class CompetitionLoaded extends CompetitionState {
  CompetitionLoaded({List<Competition>? data}) : super(data: data);
}

class CompetitionsError extends CompetitionState {
  String? message;
  CompetitionsError({this.message});
}
