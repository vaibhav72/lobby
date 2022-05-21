import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/repository/category/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  StreamSubscription? _categoryStreamSubscription;
  final CategoryRepository categoryRepository;
  CategoryBloc({required CategoryRepository? categoryRepository})
      : categoryRepository = categoryRepository ?? CategoryRepository(),
        super(CategoryLoading()) {
    on<CategoryEvent>((event, emit) async {
      if (event is LoadCategories) {
        _categoryStreamSubscription?.cancel();
        _categoryStreamSubscription =
            categoryRepository?.categoryList().listen((data) {
          add(UpdateCategories(categoryList: data));
        });
      }
      if (event is UpdateCategories)
        emit(CategoryLoaded(categoryList: event.categoryList));

      // TODO: implement event handler
    });
  }
}
