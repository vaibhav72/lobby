import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/auth/auth_bloc.dart';
import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/create_post.dart';
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
          postRepository: PostRepository(), categoryModel: widget.category)
        ..loadPosts(),
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

class PostTile extends StatelessWidget {
  const PostTile({Key key, this.post}) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            post.postImage != null && post.postImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image(
                      height: 200,
                      width: double.infinity,
                      image: NetworkImage(post.postImage),
                      fit: BoxFit.fill,
                    ))
                : Text(''),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(post.postDisplayName),
                    )),
                Row(
                  children: [
                    Text("Likes ${post.likes?.length}"),
                    IconButton(
                        onPressed: () {
                          if (!(post.likes.isNotEmpty &&
                              post.likes.contains(
                                BlocProvider.of<AuthBloc>(context)
                                    .state
                                    .user
                                    .documentReference,
                              )))
                            BlocProvider.of<PostsCubit>(context).likePost(
                                currentUserRef:
                                    BlocProvider.of<AuthBloc>(context)
                                        .state
                                        .user
                                        .documentReference,
                                postModel: post);
                        },
                        icon: Icon(Icons.favorite_border,
                            color: post.likes.isNotEmpty &&
                                    post.likes.contains(
                                      BlocProvider.of<AuthBloc>(context)
                                          .state
                                          .user
                                          .documentReference,
                                    )
                                ? Colors.red
                                : Colors.black)),
                  ],
                )
              ],
            ),
            if (post.postCreated != null)
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(DateFormat('MMM dd, yyyy | hh:mm a')
                        .format(post.postCreated)),
                  )),
          ],
        ),
      ),
    );
  }
}
