import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/utils.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ViewAllPosts extends StatefulWidget {
  const ViewAllPosts({
    Key? key,
  }) : super(key: key);

  @override
  _ViewAllPostsState createState() => _ViewAllPostsState();
}

class _ViewAllPostsState extends State<ViewAllPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
      child: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (context, documentSnapshots, index) {
          log("building all Posts");
          PostModel data = PostModel.fromSnapshot(documentSnapshots[index]);
          return PostTile(post: data);
        },
        // orderBy is compulsary to enable pagination
        query: PostRepository.getAllPostsListQuery()!,
        listeners: [
          BlocProvider.of<AuthCubit>(context).refreshChangeListener,
        ],
      ),
      onRefresh: () async {
        BlocProvider.of<AuthCubit>(context).refreshChangeListener.refreshed =
            true;
      },
    ));
  }
}
