import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lobby/models/post_model.dart';

abstract class BasePostRepository {
  CollectionReference get collection;

  Stream<List<PostModel>> getSpecificPosts(@required String categoryId);
  Stream<List<PostModel>> getAllRandomPosts();
  Future<String> uploadData(String path, Uint8List data);
  addPost({PostModel postModel});

  likePost(DocumentReference reference, PostModel post);
}
