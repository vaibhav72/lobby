import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostModel {
  DateTime postCreated;

  String postImage;

  String postVideo;

  String postDescription;

  DocumentReference postUser;

  String postUserName;

  String postDisplayName;

  String postUserImage;
  String categoryId;
  String? id;

  List<DocumentReference> likes;
  PostModel(
      {required this.postCreated,
      required this.postImage,
      required this.postVideo,
      required this.postDescription,
      required this.postUser,
      required this.postDisplayName,
      required this.postUserImage,
      required this.likes,
      required this.categoryId,
      required this.postUserName,
      this.id});

  PostModel copyWith({
    DateTime? postCreated,
    String? postImage,
    String? postVideo,
    String? categoryId,
    String? postDescription,
    DocumentReference? postUser,
    String? postDisplayName,
    String? postUserImage,
    String? postUserName,
    List<DocumentReference>? likes,
  }) {
    return PostModel(
        postCreated: postCreated ?? this.postCreated,
        postImage: postImage ?? this.postImage,
        postVideo: postVideo ?? this.postVideo,
        postDescription: postDescription ?? this.postDescription,
        postUser: postUser ?? this.postUser,
        postDisplayName: postDisplayName ?? this.postDisplayName,
        postUserImage: postUserImage ?? this.postUserImage,
        likes: likes ?? this.likes,
        postUserName: postUserName ?? this.postUserName,
        categoryId: categoryId ?? this.categoryId);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postCreated': Timestamp.fromDate(postCreated),
      'postImage': postImage,
      'postVideo': postVideo,
      'postDescription': postDescription,
      'postUser': postUser,
      'postDisplayName': postDisplayName,
      'postUserImage': postUserImage,
      'categoryId': categoryId,
      'postUserName': postUserName,
      'likes': likes.map((x) => x).toList(),
    };
  }

  factory PostModel.fromSnapshot(DocumentSnapshot doc) {
    return PostModel(
      postCreated: (doc['postCreated'] as Timestamp).toDate(),
      postImage: doc['postImage'] ?? '',
      id: doc.id,
      postUserName: '',
      postVideo: doc['postVideo'] ?? '',
      postDescription: doc['postDescription'] ?? '',
      postUser: (doc['postUser']),
      postDisplayName: doc['postDisplayName'] ?? '',
      postUserImage: doc['postUserImage'] ?? '',
      categoryId: doc["categoryId"] ?? '',
      likes: doc['likes'] != null && doc['likes'].isNotEmpty
          ? List<DocumentReference>.from(doc['likes']?.map((x) => (x)))
          : [],
    );
  }

  @override
  String toString() {
    return 'PostModel(postCreated: $postCreated, postImage: $postImage, postVideo: $postVideo, postDescription: $postDescription, postUser: $postUser, postDisplayName: $postDisplayName, postUserImage: $postUserImage, likes: $likes,categoryId:$categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.postCreated == postCreated &&
        other.postImage == postImage &&
        other.postVideo == postVideo &&
        other.postDescription == postDescription &&
        other.postUser == postUser &&
        other.postDisplayName == postDisplayName &&
        other.postUserImage == postUserImage &&
        other.categoryId == categoryId &&
        listEquals(other.likes, likes);
  }

  @override
  int get hashCode {
    return postCreated.hashCode ^
        postImage.hashCode ^
        postVideo.hashCode ^
        postDescription.hashCode ^
        postUser.hashCode ^
        postDisplayName.hashCode ^
        postUserImage.hashCode ^
        categoryId.hashCode ^
        likes.hashCode;
  }
}
