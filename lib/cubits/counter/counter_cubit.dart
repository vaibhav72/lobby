import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ntp/ntp.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  DateTime createdAt;
  StreamSubscription<Duration>? counter;
  CounterCubit({required this.createdAt})
      : super(CounterLoading(timeRemaining: Duration(seconds: 0))) {
    getTime();
  }
  getTime() async {
    DateTime serverTime = await NTP.now();
    counter?.cancel();
    counter = Stream<Duration>.periodic(Duration(seconds: 1), (x) {
      // log(x.toString());
      print(createdAt.difference(serverTime.add(Duration(seconds: x))));
      return createdAt.difference(serverTime.add(Duration(seconds: x)));
    }).listen((event) {
      // log(event.toString());
      // if (state is CounterLoading) {
      // emit(CounterLoading(timeRemaining: Duration(seconds: 0)));
      emit(CounterLoaded(timeRemaining: event));
      // } else {
      //   log("emitting new state");
      //   log((state.timeRemaining == event).toString());
      //   state.copyWith(newTimeRemaining: event);
      // }
    });
  }

  @override
  Future<void> close() async {
    counter?.cancel();
    super.close();
  }
}
