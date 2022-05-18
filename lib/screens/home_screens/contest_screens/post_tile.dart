import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/post_model.dart';

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
                    child: CachedNetworkImage(
                      height: 200,
                      width: double.infinity,
                      imageUrl: post.postImage,
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
                                BlocProvider.of<AuthCubit>(context)
                                    .state
                                    .user
                                    .documentReference,
                              )))
                            BlocProvider.of<PostsCubit>(context).likePost(
                                currentUserRef:
                                    BlocProvider.of<AuthCubit>(context)
                                        .state
                                        .user
                                        .documentReference,
                                postModel: post);
                        },
                        icon: Icon(Icons.favorite_border,
                            color: post.likes.isNotEmpty &&
                                    post.likes.contains(
                                      BlocProvider.of<AuthCubit>(context)
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
