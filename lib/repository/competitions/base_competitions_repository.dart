import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';

abstract class BaseCompetitionRepository {
  CollectionReference get collection;

  Future<List<Competition>> competitionList({String categoryId});
  addCompetition({Competition competition});
}
