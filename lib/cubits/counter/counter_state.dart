part of 'counter_cubit.dart';

abstract class CounterState extends Equatable {
  const CounterState({required this.timeRemaining});
  final Duration timeRemaining;
  CounterLoaded copyWith({Duration? newTimeRemaining}) {
    return CounterLoaded(timeRemaining: newTimeRemaining ?? this.timeRemaining);
  }

  @override
  List<Object> get props => [timeRemaining];
}

class CounterLoaded extends CounterState {
  const CounterLoaded({required Duration timeRemaining})
      : super(timeRemaining: timeRemaining);
}

class CounterLoading extends CounterState {
  CounterLoading({required Duration timeRemaining})
      : super(timeRemaining: timeRemaining);
}
