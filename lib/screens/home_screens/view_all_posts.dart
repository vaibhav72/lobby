import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/category/category_bloc.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/utils.dart';

class ViewAllPosts extends StatefulWidget {
  const ViewAllPosts({
    Key key,
  }) : super(key: key);

  @override
  _ViewAllPostsState createState() => _ViewAllPostsState();
}

class _ViewAllPostsState extends State<ViewAllPosts> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(
        postRepository: PostRepository(),
      )..loadRandomPosts(),
      child: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            return Scaffold(
              body: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width,
                            child: BlocBuilder<CategoryBloc, CategoryState>(
                              buildWhen: (previous, current) =>
                                  previous != current,
                              builder: (context, state) {
                                if (state is CategoryLoaded)
                                  // ignore: curly_braces_in_flow_control_structures
                                  return ListView.builder(
                                      // padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state?.categoryList?.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewCategoryPosts(
                                                            category: state
                                                                    ?.categoryList[
                                                                index],
                                                          )));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: MetaColors
                                                              .categoryShadow,
                                                          offset: Offset(0, 3),
                                                          blurRadius: 25)
                                                    ],
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(state
                                                            ?.categoryList[
                                                                index]
                                                            .categoryImage))),
                                                child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 2, sigmaY: 2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          state
                                                              ?.categoryList[
                                                                  index]
                                                              .categoryName,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                if (state is CategoryLoading)
                                  return CircularProgressIndicator();
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          PostTile(
                            post: state.data[index],
                          )
                        ],
                      );
                    }
                    return PostTile(
                      post: state.data[index],
                    );
                  }),
            );
          }
          return Container();
        },
      ),
    );
  }
}
