import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';

import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
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
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
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
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.camera),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.competitionTitle,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "By ${widget.post.competitionUserName}",
                                style: const TextStyle(
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
                                            competitionByName:
                                                widget.post.competitionUserName,
                                            competitionImage:
                                                widget.post.competitionImage,
                                            competitionName:
                                                widget.post.competitionTitle,
                                            competitionId:
                                                widget.post.competitionId)));
                          },
                          child: const Icon(Icons.arrow_forward_ios))
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
                    : const Text(''),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Image(
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
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          )),
                      const Spacer(),
                      const Image(
                          image: const AssetImage(MetaAssets.postOptions))
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
                                  offset: const Offset(0, 3))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: (widget.post.likes.isNotEmpty &&
                                      widget.post.likes.contains(
                                        BlocProvider.of<AuthCubit>(context)
                                            .state
                                            .user!
                                            .documentReference,
                                      ) ||
                                  BlocProvider.of<AuthCubit>(context)
                                          .state
                                          .user!
                                          .likedPosts
                                          .isNotEmpty &&
                                      BlocProvider.of<AuthCubit>(context)
                                          .state
                                          .user!
                                          .likedPosts
                                          .contains(widget.post.id))
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Image(
                                            image: const AssetImage(
                                                MetaAssets.likeIcon))),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${(!widget.post.likes.contains(
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .documentReference,
                                          ) && BlocProvider.of<AuthCubit>(context).state.user!.likedPosts.isNotEmpty && BlocProvider.of<AuthCubit>(context).state.user!.likedPosts.contains(widget.post.id)) ? widget.post.likes.length + 1 : widget.post.likes.length}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      widget.post.likes.length > 1
                                          ? 'likes'
                                          : 'like',
                                      style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (!widget.post.likes.contains(
                                              BlocProvider.of<AuthCubit>(
                                                      context)
                                                  .state
                                                  .user!
                                                  .documentReference)) {
                                            print("here");
                                            setState(() {
                                              widget.post.likes.add(
                                                  BlocProvider.of<AuthCubit>(
                                                          context)
                                                      .state
                                                      .user!
                                                      .documentReference!);
                                            });
                                          }

                                          BlocProvider.of<AuthCubit>(context)
                                              .likePost(widget.post);
                                        },
                                        child: const Icon(Icons.favorite_border,
                                            color: Colors.black)),
                                    Text(
                                      "${widget.post.likes.length}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      widget.post.likes.length > 1
                                          ? 'likes'
                                          : 'like',
                                      style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
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
                                  offset: const Offset(0, 3))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: const Image(
                                      image: AssetImage(
                                          MetaAssets.leaderboardIcon))),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "Leaderboard",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Image(
                          image: const AssetImage(MetaAssets.uploadPostIcon))
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
