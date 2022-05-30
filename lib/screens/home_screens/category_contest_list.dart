import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/posts/posts_cubit.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';

class CategoryContestList extends StatefulWidget {
  const CategoryContestList({Key? key}) : super(key: key);

  @override
  _CategoryContestListState createState() => _CategoryContestListState();
}

class _CategoryContestListState extends State<CategoryContestList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("contest list"),
          Expanded(child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded)
                // ignore: curly_braces_in_flow_control_structures
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.categoryList?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(state
                                          .categoryList![index]
                                          .categoryImage))),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(state
                                        .categoryList![index].categoryName),
                                  )),
                            ),
                          ),
                        ),
                      );
                    });
              if (state is CategoryLoading) return CircularProgressIndicator();
              return SizedBox.shrink();
            },
          ))
        ],
      ),
    );
  }
}
