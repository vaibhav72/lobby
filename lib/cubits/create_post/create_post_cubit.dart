import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/utils/upload_media.dart';
import 'package:ntp/ntp.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final String categoryId;
  CreatePostCubit(
      {required PostRepository? postRepository, required this.categoryId})
      : _postRepository = postRepository ?? PostRepository(),
        super(CreatePostLoading());

  addPost({required PostModel post, required SelectedMedia media}) async {
    try {
      emit(CreatePostLoading());
      Stream<TaskSnapshot> result =
          _postRepository.uploadData(media.storagePath, media.bytes);

      result.listen((data) async {
        log((data.bytesTransferred / data.totalBytes).toString());
        if (data.state == TaskState.running) {
          emit(CreatePostMediaUploading(
              data: (data.bytesTransferred / data.totalBytes)));
        }
        if (data.state == TaskState.success) {
          print("success");
          String url = await data.ref.getDownloadURL();
          if (url.isNotEmpty) {
            await _postRepository.addPost(
              postModel: post.copyWith(
                postImage: media.isVideo ? "" : url,
                postVideo: !media.isVideo ? "" : url,
              ),
            );
            emit(CreatePostComplete(post: post));
          }
        }
      });

      // if (url.isNotEmpty) {

      // }
    } catch (error) {
      emit(CreatePostError(message: error.toString()));
    }
  }
}
