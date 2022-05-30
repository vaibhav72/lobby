import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:lobby/utils/utils.dart';

class Competition {
  final String competitionTitle;
  final String competitionImage;
  final String competitionCategory;
  final String competitionCreatorName;
  final DocumentReference category;
  final List<DocumentReference> joineeList;
  final DateTime createdAt;
  final DocumentReference createdBy;
  final int entryFee;
  final int prizeAmount;
  final DateTime endDate;
  final String competitionCreatorImage;

  Competition({
    required this.competitionTitle,
    required this.competitionImage,
    required this.category,
    required this.joineeList,
    required this.createdAt,
    required this.competitionCategory,
    required this.endDate,
    required this.createdBy,
    required this.entryFee,
    required this.prizeAmount,
    required this.competitionCreatorName,
    required this.competitionCreatorImage,
  });
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('competitions');
  Competition copyWith({
    String? competitionTitle,
    String? competitionImage,
    DocumentReference? categoryReference,
    List<DocumentReference>? joineeList,
    DateTime? createdAt,
    String? competitionCategory,
    DateTime? endDate,
    DocumentReference? createdBy,
    int? entryFee,
    int? prizeAmount,
    String? competitionCreatorName,
    String? competitionCreatorImage,
  }) {
    return Competition(
      competitionTitle: competitionTitle ?? this.competitionTitle,
      competitionImage: competitionImage ?? this.competitionImage,
      category: categoryReference ?? this.category,
      joineeList: joineeList ?? this.joineeList,
      createdAt: createdAt ?? this.createdAt,
      competitionCategory: competitionCategory ?? this.competitionCategory,
      endDate: endDate ?? this.endDate,
      createdBy: createdBy ?? this.createdBy,
      entryFee: entryFee ?? this.entryFee,
      prizeAmount: prizeAmount ?? this.prizeAmount,
      competitionCreatorName:
          competitionCreatorName ?? this.competitionCreatorName,
      competitionCreatorImage:
          competitionCreatorImage ?? this.competitionCreatorImage,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'competitionTitle': competitionTitle,
      'competitionImage': competitionImage,
      'category': category,
      'createdAt': (Timestamp.fromDate(createdAt)),
      'joineeList': joineeList.map((x) => x).toList(),
      'competitionCategory': competitionCategory,
      'endDate': (Timestamp.fromDate(endDate)),
      'createdBy': createdBy,
      'entryFee': entryFee,
      'prizeAmount': prizeAmount,
      'competitionCreatorName': competitionCreatorName,
      'competitionCreatorImage': competitionCreatorImage,
    };
  }

  factory Competition.fromSnapshot(DocumentSnapshot map) {
    return Competition(
      competitionTitle: map['competitionTitle'] ?? '',
      competitionImage: map['competitionImageUrl'] ?? '',
      category: collection.doc(map['categoryId']),
      createdAt: map['createdAt'].toDate(),
      joineeList: List<DocumentReference>.from(
          map['joineeList']?.map((x) => collection.doc(x))),
      competitionCategory: map['competitionCategory'] ?? '',
      endDate: map['endDate'].toDate(),
      createdBy: map['createdBy'],
      entryFee: map['entryFee'] ?? 0,
      prizeAmount: map['prizeAmount'] ?? 0,
      competitionCreatorName: map['competitionCreatorName'] ?? '',
      competitionCreatorImage: map['competitionCreatorImage'] ?? '',
    );
  }

  String toJson() => json.encode(toFirestore());

  factory Competition.fromJson(String source) =>
      Competition.fromSnapshot(json.decode(source));

  @override
  String toString() {
    return 'Competition(competitionTitle: $competitionTitle, competitionImage: $competitionImage, category: $category, joineeList: $joineeList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Competition &&
        other.competitionTitle == competitionTitle &&
        other.competitionImage == competitionImage &&
        other.category == category &&
        listEquals(other.joineeList, joineeList);
  }

  @override
  int get hashCode {
    return competitionTitle.hashCode ^
        competitionImage.hashCode ^
        category.hashCode ^
        joineeList.hashCode;
  }
}
