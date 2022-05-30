import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_details_widget.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';

class PostTile extends StatefulWidget {
  const PostTile({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: .65, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        ),
        child: Padding(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.competitionTitle,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "By ${widget.post.competitionUserName}",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewContestParticipants(
                                            competitionId:
                                                widget.post.competitionId)));
                          },
                          child: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
                widget.post.postImage != null &&
                        widget.post.postImage.isNotEmpty
                    ? InkWell(
                        splashColor: MetaColors.gradientColorOne,
                        onTap: () async {
                          AudioCache cache = new AudioCache();
                          HapticFeedback.heavyImpact();
                          await cache.play(MetaAssets.postClickAudio);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImage(post: widget.post)));
                        },
                        child: CachedNetworkImage(
                          height: 200,
                          width: double.infinity,
                          imageUrl: widget.post.postImage,
                          fit: BoxFit.fill,
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
                              widget.post.postDisplayName,
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
                                    if (!(widget.post.likes.isNotEmpty &&
                                        widget.post.likes.contains(
                                          BlocProvider.of<AuthCubit>(context)
                                              .state
                                              .user!
                                              .documentReference,
                                        )))
                                      BlocProvider.of<PostsCubit>(context)
                                          .likePost(
                                              currentUserRef:
                                                  BlocProvider.of<AuthCubit>(
                                                          context)
                                                      .state
                                                      .user!
                                                      .documentReference!,
                                              postModel: widget.post);
                                  },
                                  child: widget.post.likes.isNotEmpty &&
                                          widget.post.likes.contains(
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .documentReference,
                                          )
                                      ? Image(
                                          image:
                                              AssetImage(MetaAssets.likeIcon))
                                      : Icon(Icons.favorite_border,
                                          color: Colors.black)),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${widget.post.likes.length}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                widget.post.likes.length > 1 ? 'likes' : 'like',
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
                                      image: AssetImage(
                                          MetaAssets.leaderboardIcon))),
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
        ),
      ),
    );
  }
}
