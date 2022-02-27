import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  String categoryName;
  DateTime categoryDeadline;
  String categoryImage;
  int categoryContestants;
  String categoryId;
  CategoryModel({
    @required this.categoryName,
    @required this.categoryDeadline,
    @required this.categoryImage,
    @required this.categoryContestants,
    @required this.categoryId,
  });

  CategoryModel copyWith({
    String categoryName,
    DateTime categoryDeadline,
    String categoryImage,
    int categoryContestants,
    String categoryId,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      categoryDeadline: categoryDeadline ?? this.categoryDeadline,
      categoryImage: categoryImage ?? this.categoryImage,
      categoryContestants: categoryContestants ?? this.categoryContestants,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryDeadline': categoryDeadline.millisecondsSinceEpoch,
      'categoryImage': categoryImage,
      'categoryContestants': categoryContestants,
      'categoryId': categoryId,
    };
  }

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryModel(
      categoryName: snapshot['categoryName'] ?? '',
      categoryDeadline: snapshot['categoryDeadline'].toDate(),
      categoryImage: snapshot['categoryImage'] ?? '',
      categoryContestants: snapshot['categoryContestants']?.toInt() ?? 0,
      categoryId: snapshot.id ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CategoryModel(categoryName: $categoryName, categoryDeadline: $categoryDeadline, categoryImage: $categoryImage, categoryContestants: $categoryContestants, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.categoryName == categoryName &&
        other.categoryDeadline == categoryDeadline &&
        other.categoryImage == categoryImage &&
        other.categoryContestants == categoryContestants &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return categoryName.hashCode ^
        categoryDeadline.hashCode ^
        categoryImage.hashCode ^
        categoryContestants.hashCode ^
        categoryId.hashCode;
  }
}
