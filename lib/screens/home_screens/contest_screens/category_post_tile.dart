import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_details_widget.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';

class CategoryPostTile extends StatelessWidget {
  const CategoryPostTile({Key? key, required this.post}) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: MetaColors.postShadowColor,
                  blurRadius: 25,
                  spreadRadius: 8,
                  offset: Offset(0, 3))
            ]),
        child: Column(
          children: [
            post.postImage != null && post.postImage.isNotEmpty
                ? InkWell(
                    splashColor: MetaColors.gradientColorOne,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImage(post: post)));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: CachedNetworkImage(
                        height: 200,
                        width: double.infinity,
                        imageUrl: post.postImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Text(''),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(MetaAssets.dummyProfile),
                    height: 38,
                    width: 38,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post.postDisplayName,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      )),
                  Spacer(),
                  Image(image: AssetImage(MetaAssets.postOptions))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: MetaColors.postShadowColor,
                              blurRadius: 6,
                              spreadRadius: 3,
                              offset: Offset(0, 3))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (!(post.likes.isNotEmpty &&
                                    post.likes.contains(
                                      BlocProvider.of<AuthCubit>(context)
                                          .state
                                          .user!
                                          .documentReference,
                                    )))
                                  BlocProvider.of<PostsCubit>(context).likePost(
                                      currentUserRef:
                                          BlocProvider.of<AuthCubit>(context)
                                              .state
                                              .user!
                                              .documentReference!,
                                      postModel: post);
                              },
                              child: post.likes.isNotEmpty &&
                                      post.likes.contains(
                                        BlocProvider.of<AuthCubit>(context)
                                            .state
                                            .user!
                                            .documentReference,
                                      )
                                  ? Image(
                                      image: AssetImage(MetaAssets.likeIcon))
                                  : Icon(Icons.favorite_border,
                                      color: Colors.black)),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${post.likes.length}",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            post.likes.length > 1 ? 'likes' : 'like',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: MetaColors.postShadowColor,
                              blurRadius: 6,
                              spreadRadius: 3,
                              offset: Offset(0, 3))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: Image(
                                  image:
                                      AssetImage(MetaAssets.leaderboardIcon))),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Leaderboard",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Image(image: AssetImage(MetaAssets.uploadPostIcon))
                ],
              ),
            ),
            // if (post.postCreated != null)
            //   Align(
            //       alignment: Alignment.centerLeft,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(DateFormat('MMM dd, yyyy | hh:mm a')
            //             .format(post.postCreated)),
            //       )),
          ],
        ),
      ),
    );
  }
}

