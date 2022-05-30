import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/repository/competitions/competition_repository.dart';

part 'create_competition_state.dart';

class CreateCompetitionCubit extends Cubit<CreateCompetitionState> {
  final CompetitionRepository _competitionRepository;
  final CategoryModel categoryModel;
  CreateCompetitionCubit(
      {required CompetitionRepository? competitionRepository,
      required this.categoryModel})
      : _competitionRepository =
            competitionRepository ?? CompetitionRepository(),
        super(CreateCompetitionInitial());
}
