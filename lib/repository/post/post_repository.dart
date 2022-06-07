import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/models/user_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';
import 'package:lobby/repository/post/base_post_repository.dart';
import 'package:mime_type/mime_type.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;
  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<PostModel>> getSpecificPosts(String competitionId) {
    try {
      return collection
          .where("competitionId", isEqualTo: competitionId)
          .orderBy("postCreated")
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => PostModel.fromSnapshot(doc)).toList());
    } catch (_) {
      throw (_.toString());
    }

    // TODO: implement getPosts
  }

  @override
  Stream<TaskSnapshot> uploadData(String path, Uint8List data) {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final metadata = SettableMetadata(contentType: mime(path));
      final Stream<TaskSnapshot> result =
          storageRef.putData(data, metadata).snapshotEvents;
      return result;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  // TODO: implement collection
  CollectionReference<Object> get collection =>
      _firebaseFirestore.collection('socialPosts');
  static Query? getAllPostsListQuery() =>
      PostRepository().collection.orderBy("postCreated");
  static Query? getCategoryPostsListQuery(String competitionId) =>
      PostRepository()
          .collection
          .where("competitionId", isEqualTo: competitionId)
          .orderBy("postCreated");

  static Query? getUserCategoryPostsQuery(String userId, {String? categoryId}) {
    print(userId);
    return categoryId != null
        ? PostRepository()
            .collection
            .where(
              "postUserId",
              isEqualTo: userId,
            )
            .where('categoryId', isEqualTo: categoryId)
            .orderBy("postCreated")
        : PostRepository()
            .collection
            .where(
              "postUserId",
              isEqualTo: userId,
            )
            .orderBy("postCreated");
  }

  @override
  Future<DocumentReference> addPost({PostModel? postModel}) async {
    // TODO: implement addPost
    try {
      DocumentReference documentReference =
          await collection.add(postModel!.toFirestore());
      await CompetitionRepository()
          .addJoinee(postModel.competitionId, documentReference);
      await postModel.postUser
          .update({'contestEntered': FieldValue.increment(1)});
      return documentReference;
    } catch (_) {
      throw Exception(_.toString());
    }
  }

  @override
  likePost(DocumentReference<Object?> reference, PostModel post) async {
    try {
      await collection.doc(post.id).update({
        'likes': FieldValue.arrayUnion([reference])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Stream<List<PostModel>> getAllRandomPosts() {
    try {
      return collection.orderBy("postCreated").snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromSnapshot(doc)).toList());
    } catch (_) {
      throw (_.toString());
    }
  }
}
