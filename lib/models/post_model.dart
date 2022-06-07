import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostModel {
  DateTime postCreated;

  String postImage;

  String competitionId;
  String postVideo;
  String competitionTitle;
  DocumentReference competitionByUrl;
  String competitionImage;
  String postDescription;

  DocumentReference postUser;

  String postUserName;

  String postDisplayName;

  String postUserImage;
  String categoryId;
  String? id;
  String competitionUserImage;
  String competitionUserName;
  String postUserId;

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
      required this.competitionByUrl,
      required this.competitionImage,
      required this.competitionTitle,
      required this.postUserName,
      required this.competitionId,
      required this.competitionUserImage,
      required this.competitionUserName,
      required this.postUserId,
      this.id});
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('socialPosts');
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
    DocumentReference? competitionByUrl,
    String? competitionImage,
    String? competitionTitle,
    List<DocumentReference>? likes,
    String? competitionId,
    String? competitionUserImage,
    String? competitionUserName,
  }) {
    return PostModel(
        competitionId: competitionId ?? this.competitionId,
        postCreated: postCreated ?? this.postCreated,
        postImage: postImage ?? this.postImage,
        postVideo: postVideo ?? this.postVideo,
        postDescription: postDescription ?? this.postDescription,
        postUser: postUser ?? this.postUser,
        postDisplayName: postDisplayName ?? this.postDisplayName,
        postUserImage: postUserImage ?? this.postUserImage,
        likes: likes ?? this.likes,
        postUserName: postUserName ?? this.postUserName,
        categoryId: categoryId ?? this.categoryId,
        competitionByUrl: competitionByUrl ?? this.competitionByUrl,
        competitionImage: competitionImage ?? this.competitionImage,
        competitionTitle: competitionTitle ?? this.competitionTitle,
        competitionUserImage: competitionUserImage ?? this.competitionUserImage,
        competitionUserName: competitionUserName ?? this.competitionUserName,
        postUserId: postUserId);
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
      'competitionByUrl': competitionByUrl,
      'competitionImage': competitionImage,
      'competitionTitle': competitionTitle,
      'competitionId': competitionId,
      'likes': likes.map((x) => x).toList(),
      'competitionUserImage': competitionUserImage,
      'competitionUserName': competitionUserName,
      'postUserId': postUserId
    };
  }

  factory PostModel.fromSnapshot(DocumentSnapshot doc) {
    try {
      return PostModel(
        competitionByUrl: doc['competitionByUrl'] ?? '',
        competitionImage: doc['competitionImage'] ?? '',
        competitionTitle: doc['competitionTitle'] ?? '',
        postCreated: (doc['postCreated'] as Timestamp).toDate(),
        postImage: doc['postImage'] ?? '',
        competitionId: doc['competitionId'] ?? '',
        id: doc.id,
        postUserId: doc['postUserId'] ?? '',
        postVideo: doc['postVideo'] ?? '',
        postDescription: doc['postDescription'] ?? '',
        postUser: (doc['postUser']),
        postDisplayName: doc['postDisplayName'] ?? '',
        postUserImage: doc['postUserImage'] ?? '',
        postUserName: doc['postUserName'] ?? '',
        categoryId: doc["categoryId"] ?? '',
        likes: doc['likes'] != null && doc['likes'].isNotEmpty
            ? List<DocumentReference>.from(doc['likes']?.map((x) => (x)))
            : [],
        competitionUserImage: doc['competitionUserImage'] ?? '',
        competitionUserName: doc['competitionUserName'] ?? '',
      );
    } catch (e) {
      print(e);
      throw e;
    }
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
        other.likes == likes &&
        other.competitionId == competitionId &&
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
