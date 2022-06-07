import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/repository/competitions/base_competitions_repository.dart';

class CompetitionRepository extends BaseCompetitionRepository {
  final FirebaseFirestore _firebaseFirestore;
  CompetitionRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  // TODO: implement collection
  CollectionReference<Object?> get collection =>
      _firebaseFirestore.collection('competitions');

  static Query? getCompetitionList(categoryId) => CompetitionRepository()
      .collection
      .where('categoryId', isEqualTo: categoryId)
      .orderBy('createdAt');

  @override
  Future<List<Competition>> competitionList({String? categoryId}) async {
    // TODO: implement competitionList
    QuerySnapshot data = await collection
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt')
        .get();
    return data.docs.map((doc) => Competition.fromSnapshot(doc)).toList();
  }

  @override
  addCompetition({Competition? competition}) async {
    // TODO: implement addCompetition

    // TODO: implement addPost
    try {
      DocumentReference documentReference =
          await collection.add(competition!.toFirestore());
      return documentReference;
    } catch (_) {
      throw Exception(_.toString());
    }
  }

  addJoinee(String competitionId, DocumentReference reference) async {
    try {
      await collection.doc(competitionId).update({
        'joineeList': FieldValue.arrayUnion([reference.id])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Competition> getCompetitionById(String id) async {
    return await collection
        .doc(id)
        .get()
        .then((value) => Competition.fromSnapshot(value));
  }
}
