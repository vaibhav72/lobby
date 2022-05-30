import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';

import 'package:lobby/cubits/navigation/navigation_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/screens/home_screens/contest.dart';
import 'package:lobby/screens/home_screens/category_contest_list.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contests_screen.dart';
import 'package:lobby/screens/home_screens/settings.dart';
import 'package:lobby/screens/home_screens/view_all_posts.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Settings(),
        body: Builder(builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(padding: MediaQuery.of(context).padding),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Scaffold.of(context).openDrawer();
                        },
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(
                                MetaAssets.dummyProfile,
                              ),
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: TextStyle(fontSize: 10),
                                ),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthLoggedIn) {
                                      return Text(
                                        state.user!.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      );
                                    } else {
                                      return Shimmer.fromColors(
                                        period: Duration(milliseconds: 100),
                                        enabled: true,
                                        baseColor: Colors.white,
                                        highlightColor:
                                            MetaColors.postShadowColor,
                                        child: Container(
                                          height: 20,
                                          width: 100,
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Image(image: AssetImage(MetaAssets.searchIcon)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                                image: AssetImage(MetaAssets.notificationIcon)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(boxShadow: [
                  //   BoxShadow(color: MetaColors.categoryShadow, blurRadius: 5)
                  // ]),
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (context, state) {
                      if (state is CategoryLoaded)
                        // ignore: curly_braces_in_flow_control_structures
                        return ListView.builder(
                            // padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categoryList!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewContestScreen(
                                                  category:
                                                      state.categoryList![index],
                                                )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    MetaColors.categoryShadow,
                                                offset: Offset(0, 3),
                                                blurRadius: 25)
                                          ],
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(state
                                                  .categoryList![index]
                                                  .categoryImage))),
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                state.categoryList![index]
                                                    .categoryName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            });
                      if (state is CategoryLoading) {
                        return CircularProgressIndicator();
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: MetaColors.postShadowColor, blurRadius: 25)
                        ]),
                        child: ViewAllPosts())),
              ],
            ),
          );
        }));
  }
}
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:lobby/bloc/category/category_bloc.dart';
// import 'package:lobby/cubits/cubit/auth_cubit.dart';
// import 'package:lobby/cubits/navigation/navigation_cubit.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lobby/screens/home_screens/contest.dart';
// import 'package:lobby/screens/home_screens/category_contest_list.dart';
// import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
// import 'package:lobby/screens/home_screens/settings.dart';
// import 'package:lobby/screens/home_screens/view_all_posts.dart';
// import 'package:lobby/utils/meta_assets.dart';
// import 'package:lobby/utils/meta_colors.dart';
// import 'package:shimmer/shimmer.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: Settings(),
//         body: Builder(builder: (context) {
//           return Container(
//               child: NestedScrollView(
//                   body: ViewAllPosts(),
//                   headerSliverBuilder: ((context, innerBoxIsScrolled) => [
//                         // SliverPadding(padding: MediaQuery.of(context).padding),
//                         SliverAppBar(
//                           titleSpacing: 0,
//                           leadingWidth: 0,
//                           pinned: true,
//                           title: Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     HapticFeedback.selectionClick();
//                                     Scaffold.of(context).openDrawer();
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Image(
//                                         image: AssetImage(
//                                           MetaAssets.dummyProfile,
//                                         ),
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 .05,
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Welcome",
//                                             style: TextStyle(fontSize: 10),
//                                           ),
//                                           BlocBuilder<AuthCubit, AuthState>(
//                                             builder: (context, state) {
//                                               if (state is AuthLoggedIn) {
//                                                 return Text(
//                                                   state.user!.name,
//                                                   style: TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 );
//                                               } else {
//                                                 return Shimmer.fromColors(
//                                                   period: Duration(
//                                                       milliseconds: 100),
//                                                   enabled: true,
//                                                   baseColor: Colors.white,
//                                                   highlightColor: MetaColors
//                                                       .postShadowColor,
//                                                   child: Container(
//                                                     height: 20,
//                                                     width: 100,
//                                                   ),
//                                                 );
//                                               }
//                                             },
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: const [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Image(
//                                           image: AssetImage(
//                                               MetaAssets.searchIcon)),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Image(
//                                           image: AssetImage(
//                                               MetaAssets.notificationIcon)),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),

//                         SliverPersistentHeader(
//                             floating: true,
//                             delegate: Delegate(
//                                 expandedHeight:
//                                     MediaQuery.of(context).size.height * .1)),

//                         // SliverPadding(
//                         //   padding: const EdgeInsets.all(8.0),
//                         //   sliver: Row(
//                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //     children: [
//                         //       GestureDetector(
//                         //         onTap: () {
//                         //           HapticFeedback.selectionClick();
//                         //           Scaffold.of(context).openDrawer();
//                         //         },
//                         //         child: Row(
//                         //           children: [
//                         //             Image(
//                         //               image: AssetImage(
//                         //                 MetaAssets.dummyProfile,
//                         //               ),
//                         //               height: MediaQuery.of(context).size.height * .05,
//                         //             ),
//                         //             SizedBox(
//                         //               width: 10,
//                         //             ),
//                         //             Column(
//                         //               crossAxisAlignment: CrossAxisAlignment.start,
//                         //               children: [
//                         //                 Text(
//                         //                   "Welcome",
//                         //                   style: TextStyle(fontSize: 10),
//                         //                 ),
//                         //                 BlocBuilder<AuthCubit, AuthState>(
//                         //                   builder: (context, state) {
//                         //                     if (state is AuthLoggedIn) {
//                         //                       return Text(
//                         //                         state.user!.name,
//                         //                         style: TextStyle(
//                         //                             fontSize: 16,
//                         //                             fontWeight: FontWeight.w500),
//                         //                       );
//                         //                     } else {
//                         //                       return Shimmer.fromColors(
//                         //                         period: Duration(milliseconds: 100),
//                         //                         enabled: true,
//                         //                         baseColor: Colors.white,
//                         //                         highlightColor:
//                         //                             MetaColors.postShadowColor,
//                         //                         child: Container(
//                         //                           height: 20,
//                         //                           width: 100,
//                         //                         ),
//                         //                       );
//                         //                     }
//                         //                   },
//                         //                 )
//                         //               ],
//                         //             )
//                         //           ],
//                         //         ),
//                         //       ),
//                         //       Row(
//                         //         children: const [
//                         //           Padding(
//                         //             padding: EdgeInsets.all(8.0),
//                         //             child:
//                         //                 Image(image: AssetImage(MetaAssets.searchIcon)),
//                         //           ),
//                         //           Padding(
//                         //             padding: EdgeInsets.all(8.0),
//                         //             child: Image(
//                         //                 image: AssetImage(MetaAssets.notificationIcon)),
//                         //           ),
//                         //         ],
//                         //       )
//                         //     ],
//                         //   ),
//                         // ),

//                         // Expanded(
//                         //     child: Container(
//                         //         decoration: BoxDecoration(boxShadow: [
//                         //           BoxShadow(
//                         //               color: MetaColors.postShadowColor, blurRadius: 25)
//                         //         ]),
//                         //         child: ViewAllPosts())),
//                       ])));
//         }));
//   }
// }

// class Delegate extends SliverPersistentHeaderDelegate {
//   double expandedHeight;
//   Delegate({required this.expandedHeight});
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     // TODO: implement build
//     return Container(
//       // decoration: BoxDecoration(boxShadow: [
//       //   BoxShadow(color: MetaColors.categoryShadow, blurRadius: 5)
//       // ]),
//       height: expandedHeight,
//       width: MediaQuery.of(context).size.width,
//       child: BlocBuilder<CategoryBloc, CategoryState>(
//         buildWhen: (previous, current) => previous != current,
//         builder: (context, state) {
//           if (state is CategoryLoaded)
//             // ignore: curly_braces_in_flow_control_structures
//             return ListView.builder(
//                 // padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: state.categoryList!.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ViewCategoryPosts(
//                                       category: state.categoryList![index],
//                                     )));
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * .45,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: MetaColors.categoryShadow,
//                                     offset: Offset(0, 3),
//                                     blurRadius: 25)
//                               ],
//                               image: DecorationImage(
//                                   fit: BoxFit.fill,
//                                   image: NetworkImage(state
//                                       .categoryList![index].categoryImage))),
//                           child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(
//                                   child: Text(
//                                     state.categoryList![index].categoryName,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//           if (state is CategoryLoading) {
//             return CircularProgressIndicator();
//           }
//           return SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   @override
//   // TODO: implement maxExtent
//   double get maxExtent => expandedHeight;
//   @override
//   // TODO: implement minExtent
//   double get minExtent => 0;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     return true;
//   }
// }
