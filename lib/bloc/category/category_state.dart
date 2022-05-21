part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  final List<CategoryModel>? categoryList;
  const CategoryState({this.categoryList});

  @override
  List<Object> get props => [categoryList!];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  CategoryLoaded({List<CategoryModel>? categoryList})
      : super(categoryList: categoryList);
  @override
  List<Object> get props => [categoryList!];
}
