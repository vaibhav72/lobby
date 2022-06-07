import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';
import 'package:lobby/cubits/counter/counter_cubit.dart';
import 'package:lobby/cubits/create_post/create_post_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/screens/home_screens/contest_screens/join_contest_screen.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contests_screen.dart';
import 'package:lobby/utils/custom_videoplayer.dart';
import 'package:lobby/utils/media_display.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:lobby/utils/upload_media.dart';
import 'package:lobby/utils/utils.dart';
import 'package:ntp/ntp.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ViewContestDetailsScreen extends StatefulWidget {
  final Competition competition;

  const ViewContestDetailsScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<ViewContestDetailsScreen> createState() =>
      _ViewContestDetailsScreenState();
}

class _ViewContestDetailsScreenState extends State<ViewContestDetailsScreen> {
  Duration difference = Duration(seconds: 0);
  @override
  void initState() {
    setData();
  }

  setData() async {
    DateTime updatedTime = await NTP.now();
    setState(() {
      difference = DateTime.now().difference(updatedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.competition.id);
    return BlocProvider(
      create: (context) => CounterCubit(endAt: widget.competition.endDate),
      child: Container(
          child: Scaffold(
        appBar: AppBar(title: Text('Contest Details')),
        body: DefaultTabController(
          length: 2,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContestMetaDataBanner(
              competition: widget.competition,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: MetaColors.gradient,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        text: "Participants",
                      ),
                      Tab(
                        text: "Contest Info",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: MetaColors.postShadowColor,
                            blurRadius: 25,
                            offset: Offset(0, 3))
                      ]
                      // gradient: MetaColors.gradient
                      ),
                  child: TabBarView(
                    children: [
                      Container(
                          child: RefreshIndicator(
                        child: PaginateFirestore(
                          itemBuilderType: PaginateBuilderType.listView,
                          itemBuilder: (context, documentSnapshots, index) {
                            log(documentSnapshots.toString());
                            PostModel data = PostModel.fromSnapshot(
                                documentSnapshots[index]);
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.camera),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.postUserName,
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                          // orderBy is compulsary to enable pagination
                          query: PostRepository.getCategoryPostsListQuery(
                              widget.competition.id!)!,
                          listeners: [
                            BlocProvider.of<AuthCubit>(context)
                                .refreshChangeListener,
                          ],
                        ),
                        onRefresh: () async {
                          BlocProvider.of<AuthCubit>(context)
                              .refreshChangeListener
                              .refreshed = true;
                        },
                      )),
                      Container(
                        child: Center(
                          child: Text("Contest Info"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            (widget.competition.createdAt
                        .isBefore(DateTime.now().add(difference)) &&
                    widget.competition.endDate
                        .isAfter(DateTime.now().add(difference)))
                ? buildButton(
                    title: 'Join Contest \u20b9 ${widget.competition.entryFee}',
                    handler: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinContestScreen(
                                  competition: widget.competition)));
                    })
                : widget.competition.createdAt
                        .isAfter(DateTime.now().add(difference))
                    ? TweenAnimationBuilder(
                        duration: widget.competition.createdAt
                            .difference(DateTime.now().add(difference)),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              splashColor: MetaColors.gradientColorTwo,
                              onTap: () {},
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: MetaColors.gradientColorTwo),
                                  width: double.maxFinite,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        "Starts on ${DateFormat('MMM dd, yyyy').format(widget.competition.createdAt)}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        })
                    : Container()
          ]),
        ),
      )),
    );
  }
}
