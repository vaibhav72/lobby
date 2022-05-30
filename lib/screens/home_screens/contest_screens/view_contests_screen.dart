import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/cubits/competition/competition_cubit.dart';
import 'package:lobby/cubits/counter/counter_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

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
                                  CounterCubit(createdAt: data.createdAt),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.competitionTitle,
                                                      style: TextStyle(
                                                          color: MetaColors
                                                              .textColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      'Contest by ${data.competitionCreatorName}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            BlocBuilder<CounterCubit,
                                                CounterState>(
                                              builder: (context, state) {
                                                log('---------------------building-----------');
                                                return Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            TimerValueWidget(
                                                              value: (state
                                                                      .timeRemaining
                                                                      .inDays)
                                                                  .toString(),
                                                            ),
                                                            TimerValueWidget(
                                                              value: (state
                                                                          .timeRemaining
                                                                          .inSeconds ~/
                                                                      state
                                                                          .timeRemaining
                                                                          .inDays)
                                                                  .remainder(
                                                                      3600)
                                                                  .toString(),
                                                            ),
                                                            TimerValueWidget(
                                                              value: ((state
                                                                          .timeRemaining
                                                                          .inSeconds %
                                                                      10)
                                                                  .toString()),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
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
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        )
                                      ],
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

class TimerValueWidget extends StatelessWidget {
  const TimerValueWidget({
    required this.value,
    Key? key,
  }) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: MetaColors.categoryShadow,
                  blurRadius: 6,
                  offset: Offset(0, 3))
            ],
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '${value}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
