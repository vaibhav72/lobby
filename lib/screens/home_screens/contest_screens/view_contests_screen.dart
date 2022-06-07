import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/screens/home_screens/contest_screens/join_contest_screen.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_details.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:lobby/cubits/competition/competition_cubit.dart';
import 'package:lobby/cubits/counter/counter_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';

class ViewContestScreen extends StatefulWidget {
  final CategoryModel? category;
  const ViewContestScreen({Key? key, this.category}) : super(key: key);

  @override
  State<ViewContestScreen> createState() => _ViewContestScreenState();
}

class _ViewContestScreenState extends State<ViewContestScreen> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.category!.categoryName} Contests"),
        ),
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: MetaColors.gradient,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TabBar(
                        indicatorColor: Colors.white,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            text: "All Contests",
                          ),
                          Tab(
                            text: "Create Contests",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(
                          child: RefreshIndicator(
                        child: PaginateFirestore(
                          itemBuilderType: PaginateBuilderType.listView,
                          itemBuilder: (context, documentSnapshots, index) {
                            Competition data = Competition.fromSnapshot(
                                documentSnapshots[index]);
                            return BlocProvider(
                              create: (context) =>
                                  CounterCubit(endAt: data.endDate),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewContestDetailsScreen(
                                                competition: data,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              color: MetaColors.postShadowColor,
                                              blurRadius: 25,
                                              offset: Offset(0, 3))
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    child: Icon(Icons.camera),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.competitionTitle,
                                                        style: TextStyle(
                                                            color: MetaColors
                                                                .textColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        'Contest by ${data.competitionCreatorName}',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              BlocBuilder<CounterCubit,
                                                  CounterState>(
                                                // buildWhen: ((previous, current) {
                                                //   return current.timeRemaining !=
                                                //       previous.timeRemaining;
                                                // }),
                                                builder: (context, state) {
                                                  log('---------------------building-----------');
                                                  return CounterRow(
                                                    timeRemaining:
                                                        state.timeRemaining,
                                                  );
                                                },
                                              )
                                            ],
                                          )),
                                          Column(
                                            children: [
                                              Image(
                                                  image: AssetImage(
                                                      MetaAssets.giftIcon)),
                                              Text(
                                                '\u20b9 ${data.prizeAmount}',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: MetaColors.textColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          // orderBy is compulsary to enable pagination
                          query: CompetitionRepository.getCompetitionList(
                              widget.category!.categoryId)!,
                          listeners: [
                            refreshChangeListener,
                          ],
                        ),
                        onRefresh: () async {
                          refreshChangeListener.refreshed = true;
                        },
                      )),
                      Container(
                        child: Center(
                          child: Text("Past"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class CounterRow extends StatelessWidget {
  const CounterRow({
    Key? key,
    required this.timeRemaining,
  }) : super(key: key);
  final DurationFormatClass timeRemaining;

  @override
  Widget build(BuildContext context) {
    log('building here');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // TimerValueWidget(
                  //   value: (timeRemaining.inDays).toString(),
                  // ),
                  // TimerValueWidget(value: (timeRemaining.inSeconds).toString()),
                  TimerValueWidget(
                    value: ((timeRemaining.days[0]).toString()),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TimerValueWidget(
                    value: ((timeRemaining.days[1]).toString()),
                  )
                ],
              ),
              Text('Days', style: MetaStyles.timerTitleStyle)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // TimerValueWidget(
                  //   value: (timeRemaining.inDays).toString(),
                  // ),
                  // TimerValueWidget(value: (timeRemaining.inSeconds).toString()),
                  TimerValueWidget(
                    value: ((timeRemaining.hours[0]).toString()),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TimerValueWidget(
                    value: ((timeRemaining.hours[1]).toString()),
                  )
                ],
              ),
              Text('Hours', style: MetaStyles.timerTitleStyle)
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(':',
                    style: MetaStyles.timerTitleStyle
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // TimerValueWidget(
                //   value: (timeRemaining.inDays).toString(),
                // ),
                // TimerValueWidget(value: (timeRemaining.inSeconds).toString()),
                TimerValueWidget(
                  value: ((timeRemaining.minutes[0]).toString()),
                ),
                SizedBox(
                  width: 5,
                ),
                TimerValueWidget(
                  value: ((timeRemaining.minutes[1]).toString()),
                )
              ],
            ),
            Text('Minutes', style: MetaStyles.timerTitleStyle)
          ],
        )
      ],
    );
  }
}

class TimerValueWidget extends StatefulWidget {
  const TimerValueWidget({
    required this.value,
    Key? key,
  }) : super(key: key);
  final String value;

  @override
  State<TimerValueWidget> createState() => _TimerValueWidgetState();
}

class _TimerValueWidgetState extends State<TimerValueWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  double begin = 0;
  double end = 1;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void didUpdateWidget(covariant TimerValueWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    log('Updated tyesss da');
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    log('dispose');
    super.dispose();
  }

  @override
  void initState() {
    log('here');
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900))
          ..forward();
    _animation = Tween(
      end: math.pi,
      begin: math.pi * 2,
    ).animate(_animationController)
      ..addStatusListener((status) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,

      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //           color: MetaColors.categoryShadow,
      //           blurRadius: 6,
      //           offset: Offset(0, 3))
      //     ],
      //     borderRadius: BorderRadius.circular(8)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8))),
                  child: Center(
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned(
                        top: 6,
                        child: Text(
                          '${widget.value}',
                          textScaleFactor: 1,
                          style: TextStyle(
                              //  height: 15,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
                  )),
              // Divider(
              //   height: 1,
              //   color: Colors.black,
              // ),
              Stack(alignment: Alignment.center, children: [
                Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Color.fromARGB(255, 171, 170, 170),
                      boxShadow: [
                        BoxShadow(
                            color: MetaColors.categoryShadow,
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8))),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 6,
                        child: Text(
                          '${widget.value}',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(_animation.value),
                          child: Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // color: Color.fromARGB(255, 171, 170, 170),
                                boxShadow: [
                                  BoxShadow(
                                      color: MetaColors.categoryShadow,
                                      blurRadius: 6,
                                      offset: Offset(0, 3))
                                ],
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _animation.value > 4.71
                                      ? Positioned(
                                          bottom: 6,
                                          child: Text(
                                            widget.value,
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : Positioned(
                                          top: 9,
                                          child: Transform(
                                            transform:
                                                Matrix4.rotationX(math.pi),
                                            child: Text(
                                              widget.value,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ));
                    }),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class DurationFormatClass {
  String days;
  String hours;
  String minutes;
  String seconds;
  DurationFormatClass({
    this.days = '00',
    this.hours = '00',
    this.minutes = '00',
    this.seconds = '00',
  });

  DurationFormatClass copyWith({
    String? days,
    String? hours,
    String? minutes,
    String? seconds,
  }) {
    return DurationFormatClass(
      days: days ?? this.days,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  factory DurationFormatClass.fromMap(Map<String, dynamic> map) {
    return DurationFormatClass(
      days: map['days'] ?? '',
      hours: map['hours'] ?? '',
      minutes: map['minutes'] ?? '',
      seconds: map['seconds'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DurationFormatClass.fromJson(String source) =>
      DurationFormatClass.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DurationFormatClass(days: $days, hours: $hours, minutes: $minutes, seconds: $seconds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DurationFormatClass &&
        other.days == days &&
        other.hours == hours &&
        other.minutes == minutes &&
        other.seconds == seconds;
  }

  @override
  int get hashCode {
    return days.hashCode ^ hours.hashCode ^ minutes.hashCode ^ seconds.hashCode;
  }
}
