import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/repository/category/base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;
  CategoryRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  // TODO: implement categoryList
  Stream<List<CategoryModel>> categoryList() {
    return collection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList());
  }

  @override
  // TODO: implement collection
  CollectionReference<Object> get collection =>
      _firebaseFirestore.collection('categories');
}
