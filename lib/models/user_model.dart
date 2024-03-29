import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lobby/utils/utils.dart';

class UserModel {
  User user;
  String displayImageUrl;
  String displayName;
  bool isPremium;
  bool isAdmin;
  String email;
  String phoneNumber;
  DateTime createdAt;
  double balance;
  DocumentReference documentReference;

  UserModel({
    @required this.user,
    @required this.displayImageUrl,
    @required this.displayName,
    @required this.isPremium,
    @required this.isAdmin,
    @required this.email,
    @required this.balance,
    @required this.createdAt,
    @required this.phoneNumber,
    @required this.documentReference,
  });
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  UserModel copyWith(
      {User user,
      String displayImageUrl,
      bool isPremium,
      bool isAdmin,
      String email,
      String phoneNumber,
      DocumentReference documentReference}) {
    return UserModel(
        user: user ?? this.user,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        displayName: displayName ?? this.displayName,
        displayImageUrl: displayImageUrl ?? this.displayImageUrl,
        isPremium: isPremium ?? this.isPremium,
        isAdmin: isAdmin ?? this.isAdmin,
        email: email ?? this.email,
        balance: balance ?? this.balance,
        documentReference: documentReference ?? this.documentReference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      // 'user': user,
      'displayImageUrl': displayImageUrl,
      'phoneNumber': phoneNumber,
      'isPremium': isPremium,
      'isAdmin': isAdmin,
      'email': email,
      'balance': balance
    };
  }

  factory UserModel.fromMap(DocumentSnapshot map) {
    return UserModel(
        // user: User.fromMap(map['user']),
        displayImageUrl: map['displayImageUrl'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        isPremium: map['isPremium'] ?? false,
        isAdmin: map['isAdmin'] ?? false,
        email: map['email'] ?? '',
        balance: (map['balance'] ?? 0).toDouble());
  }

  String toJson() => json.encode(toFirestore());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(user: $user, displayImageUrl: $displayImageUrl, isPremium: $isPremium, isAdmin: $isAdmin, email: $email) , phoneNumber: $phoneNumber, balance: $balance, createdAt: $createdAt, documentReference: $documentReference';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.user == user &&
        other.displayImageUrl == displayImageUrl &&
        other.isPremium == isPremium &&
        other.isAdmin == isAdmin &&
        other.email == email &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        displayImageUrl.hashCode ^
        isPremium.hashCode ^
        isAdmin.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode;
  }
}
