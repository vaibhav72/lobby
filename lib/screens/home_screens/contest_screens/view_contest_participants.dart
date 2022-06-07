import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/screens/home_screens/contest_screens/competition_post_tile.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_details.dart';
import 'package:lobby/utils/utils.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ViewContestParticipants extends StatefulWidget {
  final String competitionId;
  final String competitionName;

  final String competitionImage;
  final String competitionByName;

  const ViewContestParticipants(
      {Key? key,
      required this.competitionId,
      required this.competitionName,
      required this.competitionImage,
      required this.competitionByName})
      : super(key: key);

  @override
  State<ViewContestParticipants> createState() =>
      _ViewContestParticipantsState();
}

class _ViewContestParticipantsState extends State<ViewContestParticipants> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(
        postRepository: PostRepository(),
      )..loadSpecificPosts(widget.competitionId),
      child: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.competitionName,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "By ${widget.competitionByName}",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          Competition data = await context
                              .read<CompetitionRepository>()
                              .getCompetitionById(widget.competitionId);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewContestDetailsScreen(
                                          competition: data)));
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Icon(Icons.error_outline)),
                  )
                ],
              ),
              body: loading
                  ? Loader(
                      message: "Fetching contest",
                    )
                  : Column(
                      children: [
                        // Padding(padding: MediaQuery.of(context).padding),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     children: [
                        //       InkWell(
                        //           onTap: () {
                        //             Navigator.pop(context);
                        //           },
                        //           child: Icon(Icons.arrow_back)),
                        //       Expanded(
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Icon(Icons.camera),
                        //             Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     widget.competitionName,
                        //                     style: TextStyle(
                        //                         fontSize: 12,
                        //                         fontWeight: FontWeight.w500),
                        //                   ),
                        //                   Text(
                        //                     "By ${widget.competitionByName}",
                        //                     style: TextStyle(
                        //                         fontSize: 10,
                        //                         fontWeight: FontWeight.w300),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       InkWell(
                        //           onTap: () async {
                        //             setState(() {
                        //               loading = true;
                        //             });
                        //             Competition data = await context
                        //                 .read<CompetitionRepository>()
                        //                 .getCompetitionById(
                        //                     widget.competitionId);
                        //             await Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         ViewContestDetailsScreen(
                        //                             competition: data)));
                        //             setState(() {
                        //               loading = false;
                        //             });
                        //           },
                        //           child: Icon(Icons.error_outline))
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                            child: Container(
                                child: RefreshIndicator(
                          child: PaginateFirestore(
                            itemBuilderType: PaginateBuilderType.listView,
                            itemBuilder: (context, documentSnapshots, index) {
                              PostModel data = PostModel.fromSnapshot(
                                  documentSnapshots[index]);
                              return CompetitionPostTile(post: data);
                            },
                            // orderBy is compulsary to enable pagination
                            query: PostRepository.getCategoryPostsListQuery(
                                widget.competitionId)!,
                            listeners: [
                              refreshChangeListener,
                            ],
                          ),
                          onRefresh: () async {
                            refreshChangeListener.refreshed = true;
                          },
                        ))),
                      ],
                    ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
