import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/utils/upload_media.dart';
import 'package:lobby/utils/utils.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  StreamSubscription _postStreamSubscription;
  final PostRepository postRepository;

  final CategoryModel categoryModel;
  PostsCubit(
      {@required PostRepository postRepository, @required this.categoryModel})
      : postRepository = postRepository ?? PostRepository(),
        super(PostsLoading());

  void loadPosts() {
    _postStreamSubscription?.cancel();
    _postStreamSubscription =
        postRepository.getPosts(categoryModel.categoryId).listen((data) {
      print(data);
      updatePosts(data: data);
    });
  }

  void updatePosts({List<PostModel> data}) {
    print("here");
    emit(PostsLoaded(data: data));
  }

  likePost(
      {@required DocumentReference currentUserRef,
      @required PostModel postModel}) async {
    try {
      postRepository.likePost(currentUserRef, postModel);
    } catch (error) {
      print(error.toString());
    }
  }
}
