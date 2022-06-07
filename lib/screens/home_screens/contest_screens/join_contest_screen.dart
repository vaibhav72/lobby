import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';
import 'package:lobby/cubits/counter/counter_cubit.dart';
import 'package:lobby/cubits/create_post/create_post_cubit.dart';
import 'package:lobby/models/category_model.dart';
import 'package:lobby/models/competition_model.dart';
import 'package:lobby/models/post_model.dart';
import 'package:lobby/repository/post/post_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/screens/home_screens/contest_screens/contest_joining_success.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contests_screen.dart';
import 'package:lobby/utils/custom_videoplayer.dart';
import 'package:lobby/utils/media_display.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:lobby/utils/upload_media.dart';
import 'package:lobby/utils/utils.dart';
import 'package:ntp/ntp.dart';

import 'dart:math' as math;

class JoinContestScreen extends StatefulWidget {
  final Competition competition;

  const JoinContestScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<JoinContestScreen> createState() => _JoinContestScreenState();
}

class _JoinContestScreenState extends State<JoinContestScreen> {
  Duration difference = Duration(seconds: 0);
  @override
  void initState() {
    setData();
  }

  setData() async {
    DateTime updatedTime = await NTP.now();
    setState(() {
      difference = DateTime.now().difference(updatedTime);
    });
  }

  String uploadedFileUrl1 = '';
  String uploadedFileUrl2 = '';
  TextEditingController textController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double value = 0.1;
  SelectedMedia? selectedMedia;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => CreatePostCubit(
            categoryId: widget.competition.competitionCategory,
            postRepository: PostRepository()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Join Contest'),
            actions: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.error_outline),
              )
            ],
          ),
          body: BlocConsumer<CreatePostCubit, CreatePostState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is CreatePostComplete) {
                BlocProvider.of<AuthCubit>(context)
                    .refreshChangeListener
                    .refreshed = true;
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(const SnackBar(content: Text("Success")));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ContestJoiningSuccess(post: state.post)));
              }
              if (state is CreatePostError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              }
              if (state is CreatePostMediaUploading) {
                setState(() {
                  value = state.data;
                });
              }
            },
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    CounterCubit(endAt: widget.competition.endDate),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContestMetaDataBanner(
                          competition: widget.competition,
                        ),
                        CompetitionDetails(widget: widget),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                selectedMedia =
                                    await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  allowPhoto: true,
                                  allowVideo: true,
                                  pickerFontFamily: 'Cormorant Garamond',
                                );
                                if (selectedMedia != null &&
                                    validateFileFormat(
                                        selectedMedia!.storagePath, context)) {
                                  setState(() {
                                    uploadedFileUrl1 = selectedMedia!.localPath;
                                  });
                                }
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(20),
                                color: MetaColors.subTextColor.withOpacity(0.5),
                                dashPattern: [5],
                                child: MediaDisplay(
                                  path: valueOrDefault<String>(
                                    uploadedFileUrl1,
                                    MetaAssets.addPhotoDummy,
                                  ),
                                  imageBuilder: (path) => Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: uploadedFileUrl1.trim().isNotEmpty
                                          ? Image(
                                              image: FileImage(File(path)),
                                              // width: 300,
                                              // height: 300,
                                              fit: BoxFit.cover,
                                            )
                                          : Center(
                                              child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  child: Column(
                                                children: [
                                                  const Text(
                                                    'Click To Upload',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  const Text(
                                                    'Size should be less than 5MB',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              )),
                                            )),
                                    ),
                                  ),
                                  videoPlayerBuilder: (path) =>
                                      CustomVideoPlayer(
                                    path: path,
                                    width: 300,
                                    autoPlay: false,
                                    looping: true,
                                    showControls: false,
                                    allowFullScreen: true,
                                    allowPlaybackSpeedMenu: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        RulesWidget(
                            title: widget.competition.competitionTitle +
                                "(Contest Creator)",
                            rules: widget.competition.competitionRules),
                        const RulesWidget(
                            title: 'Ezigboe', rules: "Play Responsibly"),
                        state is CreatePostMediaUploading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  splashColor: MetaColors.gradientColorTwo,
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                            colors: MetaColors.gradient.colors,
                                            stops: [0.1, value])),
                                    width: double.maxFinite,
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          "Uploading...",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : buildButton(
                                title:
                                    'Join Contest \u20b9 ${widget.competition.entryFee}',
                                handler: () async {
                                  if (selectedMedia?.storagePath != null) {
                                    PostModel data = PostModel(
                                        postImage: '',
                                        postVideo: '',
                                        postUserImage:
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .displayImageUrl!,
                                        competitionByUrl:
                                            widget.competition.createdBy,
                                        competitionUserImage: widget.competition
                                            .competitionCreatorImage,
                                        competitionUserName: widget
                                            .competition.competitionCreatorName,
                                        competitionId: widget.competition.id!,
                                        competitionImage: '',
                                        competitionTitle:
                                            widget.competition.competitionTitle,
                                        postCreated: (await NTP.now()),
                                        postDescription:
                                            descriptionController.text,
                                        postUser:
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .documentReference!,
                                        postDisplayName: textController.text,
                                        postUserName:
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .displayImageUrl!,
                                        postUserId:
                                            BlocProvider.of<AuthCubit>(context)
                                                .state
                                                .user!
                                                .user!
                                                .uid,
                                        likes: [],
                                        categoryId:
                                            widget.competition.category.id);
                                    BlocProvider.of<CreatePostCubit>(context)
                                        .addPost(
                                            post: data, media: selectedMedia!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: const Text(
                                                "Please select an image")));
                                  }
                                })
                      ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RulesWidget extends StatelessWidget {
  final String title;
  final String rules;
  const RulesWidget({Key? key, required this.title, required this.rules})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: MetaStyles.contestFieldsTitleStyle,
          ),
          Text(
            rules,
            style: MetaStyles.contestFieldRulesStyle,
          ),
        ],
      ),
    );
  }
}

class CompetitionUploadImageContainer extends StatelessWidget {
  const CompetitionUploadImageContainer({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final JoinContestScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          color: MetaColors.subTextColor.withOpacity(0.5),
          dashPattern: [5],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                children: [
                  const Text(
                    'Click To Upload',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Text(
                    'Size should be less than 5MB',
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class CompetitionDetails extends StatelessWidget {
  const CompetitionDetails({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final JoinContestScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contest Details',
            style: MetaStyles.contestFieldsTitleStyle,
          ),
          Text(
            widget.competition.competitionDetails,
            style: MetaStyles.contestFieldsSubTitleStyle,
          ),
        ],
      ),
    );
  }
}

class ContestMetaDataBanner extends StatefulWidget {
  const ContestMetaDataBanner({Key? key, required this.competition})
      : super(key: key);

  final Competition competition;

  @override
  State<ContestMetaDataBanner> createState() => _ContestMetaDataBannerState();
}

class _ContestMetaDataBannerState extends State<ContestMetaDataBanner> {
  Duration difference = Duration(seconds: 0);
  @override
  void initState() {
    setData();
  }

  setData() async {
    DateTime updatedTime = await NTP.now();
    setState(() {
      difference = DateTime.now().difference(updatedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: MetaColors.gradient.colors,
                begin: Alignment.centerLeft,
                end: Alignment.topRight
                // transform: GradientRotation((math.pi / 180) * (230))

                ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: MetaColors.postShadowColor,
                  blurRadius: 25,
                  offset: const Offset(0, 3))
            ]),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Entry Fee \u20b9 ${widget.competition.entryFee}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.competition.competitionTitle,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Contest by ${widget.competition.competitionCreatorName}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                          BlocBuilder<CounterCubit, CounterState>(
                            // buildWhen: ((previous, current) {
                            //   return current.timeRemaining !=
                            //       previous.timeRemaining;
                            // }),
                            builder: (context, state) {
                              log('---------------------building-----------');
                              return CounterRow(
                                timeRemaining: state.timeRemaining,
                              );
                            },
                          )
                        ],
                      )),
                      Column(
                        children: [
                          const Image(image: AssetImage(MetaAssets.giftIcon)),
                          Text(
                            '\u20b9 ${widget.competition.prizeAmount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'First Prize',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '\u20b9 ${(widget.competition.prizeAmount * .5).toInt()}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Second Prize',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '\u20b9 ${(widget.competition.prizeAmount * .3).toInt()}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Third Prize',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '\u20b9 ${(widget.competition.prizeAmount * .15).toInt()}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (widget.competition.createdAt
                    .isBefore(DateTime.now().add(difference)) &&
                widget.competition.endDate
                    .isAfter(DateTime.now().add(difference)))
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "\u2022 LIVE",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
