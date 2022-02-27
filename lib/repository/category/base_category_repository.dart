import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lobby/models/category_model.dart';

abstract class BaseCategoryRepository {
  CollectionReference get collection;

  Stream<List<CategoryModel>> categoryList();
}
