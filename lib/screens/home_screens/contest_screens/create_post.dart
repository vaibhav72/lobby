import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/cubits/create_post/create_post_cubit.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';
import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/utils/custom_videoplayer.dart';
import 'package:lobby/utils/media_display.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/upload_media.dart';
import 'package:lobby/utils/utils.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostCreateWidget extends StatefulWidget {
  CategoryModel categoryModel;
  PostCreateWidget({Key? key, required this.categoryModel}) : super(key: key);

  @override
  _PostCreateWidgetState createState() => _PostCreateWidgetState();
}

class _PostCreateWidgetState extends State<PostCreateWidget>
    with TickerProviderStateMixin {
  String uploadedFileUrl1 = '';
  String uploadedFileUrl2 = '';
  TextEditingController textController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  SelectedMedia? selectedMedia;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CreatePostCubit(
            categoryModel: widget.categoryModel,
            postRepository: PostRepository()),
        child: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is CreatePostComplete) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Success")));

              Navigator.of(context).pop();
            }
            if (state is CreatePostError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Post',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: InkWell(
                      onTap: () async {
                        selectedMedia = await selectMediaWithSourceBottomSheet(
                          context: context,
                          allowPhoto: true,
                          allowVideo: true,
                          pickerFontFamily: 'Cormorant Garamond',
                        );
                        if (selectedMedia != null &&
                            validateFileFormat(
                                selectedMedia!.storagePath, context)) {
                          setState(() {
                            uploadedFileUrl1 = selectedMedia!.localPath;
                          });

                          // final downloadUrl = await uploadData(
                          //     selectedMedia.storagePath, selectedMedia.bytes);
                          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // if (downloadUrl != null) {
                          //   setState(() => uploadedFileUrl1 = downloadUrl);
                          //   showUploadMessage(
                          //     context,
                          //     'Success!',
                          //   );
                          // } else {
                          //   showUploadMessage(
                          //     context,
                          //     'Failed to upload media',
                          //   );
                          //   return;
                          // }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 370,
                        child: MediaDisplay(
                          path: valueOrDefault<String>(
                            uploadedFileUrl1,
                            MetaAssets.addPhotoDummy,
                          ),
                          imageBuilder: (path) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: uploadedFileUrl1.trim().isNotEmpty
                                ? Image(
                                    image: FileImage(File(path)),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: AssetImage(path),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          videoPlayerBuilder: (path) => CustomVideoPlayer(
                            path: path,
                            width: 300,
                            autoPlay: false,
                            looping: true,
                            showControls: false,
                            allowFullScreen: true,
                            allowPlaybackSpeedMenu: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                            child: TextFormField(
                              controller: textController,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Display Name',
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20, 24, 20, 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: TextFormField(
                            controller: descriptionController,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20, 24, 20, 24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      if (selectedMedia?.storagePath != null) {
                        BlocProvider.of<CreatePostCubit>(context).addPost(
                            title: textController.text,
                            description: descriptionController.text,
                            currentUserImage:
                                BlocProvider.of<AuthCubit>(context)
                                    .state
                                    .user!
                                    .displayImageUrl!,
                            postUserName: BlocProvider.of<AuthCubit>(context)
                                .state
                                .user!
                                .user!
                                .displayName!,
                            currentUserRef: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid),
                            media: selectedMedia!);
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select an image")));
                    },
                    child: Text("Post"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
