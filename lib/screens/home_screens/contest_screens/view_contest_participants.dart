import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/category_post_tile.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/utils/utils.dart';

class ViewCategoryPosts extends StatefulWidget {
  final CategoryModel category;
  const ViewCategoryPosts({Key? key, required this.category}) : super(key: key);

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
              body: Column(
                children: [
                  Padding(padding: MediaQuery.of(context).padding),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Photography",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "By tevd",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.error_outline)
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return CategoryPostTile(
                            post: state.data![index],
                          );
                        }),
                  ),
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
