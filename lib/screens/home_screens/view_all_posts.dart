import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/auth/auth_bloc.dart';
import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
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
                  itemCount: state.data?.length ?? 0,
                  itemBuilder: (context, index) {
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
