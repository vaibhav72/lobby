// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_details_widget.dart';
import 'package:lobby/screens/home_screens/contest_screens/post_tile.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  TextStyle profileStats =
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
  TextStyle profileStatsTitle = TextStyle(
    fontSize: 10,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(BlocProvider.of<AuthCubit>(context).state.user!.name),
        ),
        body: DefaultTabController(
          length: BlocProvider.of<CategoryBloc>(context)
                  .state
                  .categoryList!
                  .length +
              1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileTileStats(
                    profileStats: profileStats,
                    profileStatsTitle: profileStatsTitle),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: MetaColors.gradient,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.construction_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                "Achievements",
                                style: profileStats,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBar(
                          isScrollable: true,
                          labelColor: MetaColors.textColor,
                          // indicatorWeight: 1,
                          // indicatorPadding: EdgeInsets.all(1),
                          labelPadding: EdgeInsets.zero,
                          indicatorWeight: 3,
                          indicator: ShapeDecoration(
                              // color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              gradient: MetaColors.gradient),
                          unselectedLabelColor:
                              MetaColors.textColor.withOpacity(0.5),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                          tabs: List.generate(
                              BlocProvider.of<CategoryBloc>(context)
                                      .state
                                      .categoryList!
                                      .length +
                                  1,
                              (index) => index == 0
                                  ? Container(
                                      // width: double.maxFinite,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        child: Center(
                                          child: Text(
                                            "All Posts",
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      // width: double.maxFinite,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        child: Center(
                                          child: Text(
                                            BlocProvider.of<CategoryBloc>(
                                                    context)
                                                .state
                                                .categoryList![index - 1]
                                                .categoryName,
                                          ),
                                        ),
                                      ),
                                    )))),
                ),
                Expanded(
                    child: TabBarView(
                        children: List.generate(
                            BlocProvider.of<CategoryBloc>(context)
                                    .state
                                    .categoryList!
                                    .length +
                                1,
                            (index) => index == 0
                                ? UserAllPosts()
                                : UserAllPosts(
                                    categoryId:
                                        BlocProvider.of<CategoryBloc>(context)
                                            .state
                                            .categoryList![index - 1]
                                            .categoryId,
                                  ))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserAllPosts extends StatelessWidget {
  const UserAllPosts({Key? key, this.categoryId}) : super(key: key);
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    print(categoryId);
    return Container(
        child: PaginateFirestore(
            itemBuilderType: PaginateBuilderType.gridView,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, documentSnapshots, index) {
              // print(documentSnapshots[index].data);
              PostModel data = PostModel.fromSnapshot(documentSnapshots[index]);
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreenImage(post: data)));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        imageUrl: data.postImage, fit: BoxFit.fill),
                  ),
                ),
              );
            },
            // orderBy is compulsary to enable pagination
            query: PostRepository.getUserCategoryPostsQuery(
                BlocProvider.of<AuthCubit>(context).state.user!.user!.uid,
                categoryId: categoryId)!));
  }
}

class ProfileTileStats extends StatelessWidget {
  const ProfileTileStats({
    Key? key,
    required this.profileStats,
    required this.profileStatsTitle,
  }) : super(key: key);

  final TextStyle profileStats;
  final TextStyle profileStatsTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.topLeft,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Container(
              decoration: BoxDecoration(
                  gradient: MetaColors.gradient,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.1,
                          width: 85,
                          height: 43,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BlocProvider.of<AuthCubit>(context)
                                  .state
                                  .user!
                                  .name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              BlocProvider.of<AuthCubit>(context)
                                  .state
                                  .user!
                                  .email,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        BlocProvider.of<AuthCubit>(context).state.user!.bio!,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  BlocProvider.of<AuthCubit>(context)
                                      .state
                                      .user!
                                      .contestEntered!
                                      .toString(),
                                  style: profileStats,
                                ),
                                Text(
                                  "Contests Entered",
                                  style: profileStatsTitle,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            width: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '\u20b9 ${BlocProvider.of<AuthCubit>(context).state.user!.cashPrizeWon}',
                                  style: profileStats,
                                ),
                                Text(
                                  "Cash Prize Won",
                                  style: profileStatsTitle,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            width: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  BlocProvider.of<AuthCubit>(context)
                                      .state
                                      .user!
                                      .contestWins!
                                      .toString(),
                                  style: profileStats,
                                ),
                                Text(
                                  "Contests Wins",
                                  style: profileStatsTitle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              // image: AssetImage(
              //   MetaAssets.dummyProfile,
              // ),
              // color: Colors.white,
              child: Image(
                image: AssetImage(MetaAssets.dummyProfile),
                fit: BoxFit.fill,
              ),
              height: 80,
              width: 80,
            ),
          )
        ],
      ),
    );
  }
}
