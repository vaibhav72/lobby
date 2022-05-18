import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/utils/utils.dart';

class ViewCategoryPosts extends StatefulWidget {
  final CategoryModel category;
  const ViewCategoryPosts({Key key, this.category}) : super(key: key);

  @override
  _ViewCategoryPostsState createState() => _ViewCategoryPostsState();
}

class _ViewCategoryPostsState extends State<ViewCategoryPosts> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(
        postRepository: PostRepository(),
      )..loadSpecificPosts(widget.category.categoryId),
      child: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.category.categoryName),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostCreateWidget(
                                categoryModel: widget.category,
                              )));
                },
              ),
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
