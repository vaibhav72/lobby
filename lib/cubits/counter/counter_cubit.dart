import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contests_screen.dart';
import 'package:ntp/ntp.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  DateTime endAt;
  StreamSubscription<DurationFormatClass>? counter;
  Timer? timer;
  CounterCubit({required this.endAt})
      : super(
            CounterLoading(timeRemaining: DurationFormatClass(seconds: '00'))) {
    getTime();
  }
  getTime() async {
    DateTime serverTime = await NTP.now();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {});
    counter?.cancel();
    Duration newDuration = endAt.isAfter(serverTime)
        ? endAt.difference(serverTime.add(Duration(seconds: timer!.tick)))
        : serverTime.add(Duration(seconds: timer!.tick)).difference(endAt);

    emit(CounterLoaded(timeRemaining: formatDuration(newDuration)

        // DurationFormatClass(
        //     days: newDuration.inDays.toString().length > 1
        //         ? newDuration.inDays.toString()
        //         : newDuration.inDays.toString().padLeft(2, '0'),
        //     hours: newDuration.inHours.remainder(24).toString().length > 1
        //         ? newDuration.inHours.remainder(24).toString()
        //         : newDuration.inHours.remainder(24).toString().padLeft(2, '0'),
        //     minutes:
        //         newDuration.inHours.remainder(24 * 60).toString().length > 1
        //             ? newDuration.inHours.remainder(24 * 60).toString()
        //             : newDuration.inHours
        //                 .remainder(24 * 60)
        //                 .toString()
        //                 .padLeft(2, '0'),
        //     seconds: '00')

        ));
    counter = Stream<DurationFormatClass>.periodic(Duration(seconds: 60), (x) {
      log(x.toString());

      Duration newDuration = endAt.isAfter(serverTime)
          ? endAt.difference(serverTime.add(Duration(seconds: timer!.tick)))
          : serverTime.add(Duration(seconds: timer!.tick)).difference(endAt);
      return formatDuration(newDuration);
      // return DurationFormatClass(
      //     days: newDuration.inDays.toString().length > 1
      //         ? newDuration.inDays.toString()
      //         : newDuration.inDays.toString().padLeft(2, '0'),
      //     hours: newDuration.inHours.remainder(24).toString().length > 1
      //         ? newDuration.inHours.remainder(24).toString()
      //         : newDuration.inHours.remainder(24).toString().padLeft(2, '0'),
      //     minutes: newDuration.inHours
      //                 .remainder(24)
      //                 .remainder(60)
      //                 .toString()
      //                 .length >
      //             1
      //         ? newDuration.inHours.remainder(24).remainder(60).toString()
      //         : newDuration.inHours
      //             .remainder(24)
      //             .remainder(60)
      //             .toString()
      //             .padLeft(2, '0'),
      //     seconds: '00');
    }).listen((event) {
      // log(event.toString());
      // if (state is CounterLoading) {
      emit(CounterLoading(
          timeRemaining: DurationFormatClass(
        seconds: '00',
      )));

      emit(CounterLoaded(timeRemaining: event));
      // } else {
      //   log("emitting new state");
      //   log((state.timeRemaining == event).toString());
      //   state.copyWith(newTimeRemaining: event);
      // }
    });
  }

  DurationFormatClass formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;
    DurationFormatClass data = DurationFormatClass();
    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
      data = data.copyWith(
          days: days.toString().length > 1
              ? days.toString()
              : days.toString().padLeft(2, '0'));
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
      data = data.copyWith(
          hours: hours.toString().length > 1
              ? hours.toString()
              : hours.toString().padLeft(2, '0'));
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
      data = data.copyWith(
          minutes: minutes.toString().length > 1
              ? minutes.toString()
              : minutes.toString().padLeft(2, '0'));
    }
    tokens.add('${seconds}s');
    data = data.copyWith(seconds: seconds.toString());
    print(tokens.join(':'));
    print(data.toString());
    return data;
  }

  @override
  Future<void> close() async {
    counter?.cancel();
    timer?.cancel();
    super.close();
  }
}
