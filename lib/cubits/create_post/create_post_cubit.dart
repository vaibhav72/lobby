import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/utils/upload_media.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final CategoryModel categoryModel;
  CreatePostCubit(
      {required PostRepository? postRepository, required this.categoryModel})
      : _postRepository = postRepository ?? PostRepository(),
        super(CreatePostLoading());

  addPost(
      {required String title,
      required String description,
      required String currentUserImage,
      required DocumentReference currentUserRef,
      required String postUserName,
      required SelectedMedia media}) async {
    try {
      emit(CreatePostLoading());
      String url =
          await _postRepository.uploadData(media.storagePath, media.bytes);
      if (url != null) {
        DocumentReference documentReference = await _postRepository.addPost(
            postModel: PostModel(
                postCreated: DateTime.now(),
                postImage: media.isVideo ? "" : url,
                postVideo: !media.isVideo ? "" : url,
                postDescription: description,
                postUser: currentUserRef,
                postDisplayName: title,
                postUserName: postUserName,
                postUserImage: currentUserImage,
                likes: [],
                categoryId: categoryModel.categoryId));
        if (documentReference != null) emit(CreatePostComplete());
      }
    } catch (error) {
      emit(CreatePostError(message: error.toString()));
    }
  }
}
