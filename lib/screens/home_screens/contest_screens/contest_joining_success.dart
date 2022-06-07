import 'package:flutter/material.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lottie/lottie.dart';

class ContestJoiningSuccess extends StatefulWidget {
  final PostModel post;

  const ContestJoiningSuccess({Key? key, required this.post}) : super(key: key);

  @override
  State<ContestJoiningSuccess> createState() => _ContestJoiningSuccessState();
}

class _ContestJoiningSuccessState extends State<ContestJoiningSuccess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Successful")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                // flex: 2,
                child:
                    Lottie.asset(MetaAssets.contestJoiningSuccessIllustration)),
            Expanded(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.competitionTitle,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "By ${widget.post.competitionUserName}",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You have successfully joined the contest',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                InkWell(
                  child: Column(
                    children: [
                      Text('View More',
                          style: TextStyle(
                              fontSize: 12, color: MetaColors.subTextColor)),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: MetaColors.subTextColor,
                      )
                    ],
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
