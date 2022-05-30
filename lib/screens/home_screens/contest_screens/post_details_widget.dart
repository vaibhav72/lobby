import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';


import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';

class FullScreenImage extends StatefulWidget {
  final PostModel post;
  const FullScreenImage({Key? key, required this.post}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool showDetails = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: GestureDetector(
        onTap: () async {
          AudioCache cache = new AudioCache();
          HapticFeedback.mediumImpact();
          await cache.play(MetaAssets.viewScreenAudio);
          setState(() {
            showDetails = !showDetails;
          });
        },
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Stack(
            children: [
              Image(
                image: CachedNetworkImageProvider(widget.post.postImage),
                fit: BoxFit.fill,
                height: double.maxFinite,
              ),
              Padding(
                padding: MediaQuery.of(context).padding,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              // if (showDetails)

              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedScale(
                    curve: Curves.bounceOut,
                    scale: showDetails ? 1 : 0,
                    duration: Duration(milliseconds: 300),
                    child: PostDetailsWidget(post: widget.post)),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class PostDetailsWidget extends StatelessWidget {
  const PostDetailsWidget({Key? key, required this.post}) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: MetaColors.postShadowColor,
                  blurRadius: 50,
                  spreadRadius: 8,
                  offset: Offset(0, 3))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          ],
        ),
      ),
    );
  }
}
