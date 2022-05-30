import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';

part 'competition_state.dart';

class CompetitionCubit extends Cubit<CompetitionState> {
  CompetitionRepository _competitionRepository;
  CategoryModel categoryModel;
  CompetitionCubit(
      {required CompetitionRepository competitionRepository,
      required CategoryModel categoryModel})
      : _competitionRepository = competitionRepository,
        categoryModel = categoryModel,
        super(CompetitionLoading());

  loadCompetitions() async {
    try {
      List<Competition> data = await _competitionRepository.competitionList(
          categoryId: categoryModel.categoryId);

      updateCompetitions(data: data);
    } catch (e) {
      emit(CompetitionsError(message: e.toString()));
    }
  }

  void updateCompetitions({List<Competition>? data}) {
    print("here");
    if (!isClosed) emit(CompetitionLoaded(data: data));
  }
}
