import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:lobby/models/post_model.dart';
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
  uploadData(String path, Uint8List data) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final metadata = SettableMetadata(contentType: mime(path));
      final result = await storageRef.putData(data, metadata);
      return result.state == TaskState.success
          ? result.ref.getDownloadURL()
          : null;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  // TODO: implement collection
  CollectionReference<Object> get collection =>
      _firebaseFirestore.collection('socialPosts');

  @override
  Future<DocumentReference> addPost({PostModel? postModel}) async {
    // TODO: implement addPost
    try {
      DocumentReference documentReference =
          await collection.add(postModel!.toFirestore());
      return documentReference;
    } catch (_) {
      throw Exception(_.toString());
    }
  }

  @override
  likePost(DocumentReference<Object?> reference, PostModel post) async {
    // TODO: implement likePost

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
    // TODO: implement getAllRandomPosts
    try {
      return collection.orderBy("postCreated").snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromSnapshot(doc)).toList());
    } catch (_) {
      throw (_.toString());
    }
  }
}
