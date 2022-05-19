import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Container(
          child: Column(
            children: [
              ProfileTIleWidget(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                child: ListView(
                  children: [
                    ProfileOptionsTile(
                      title: 'Submit Contest Request',
                      asset: MetaAssets.submitContestRequest,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Audio Settings',
                      asset: MetaAssets.audioSettingsIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Appearance',
                      asset: MetaAssets.appearanceIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Notifications',
                      asset: MetaAssets.notificationIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Privacy Policy',
                      asset: MetaAssets.privacyPolicyIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Feedback',
                      asset: MetaAssets.feedbackIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'Rate Us',
                      asset: MetaAssets.rateUsIcon,
                      onTap: () {},
                    ),
                    ProfileOptionsTile(
                      title: 'About Us',
                      asset: MetaAssets.aboutUsIcon,
                      onTap: () {},
                    )
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage(MetaAssets.copyrightIcon)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Ezigboe 2022',
                      style:
                          TextStyle(color: MetaColors.textColor, fontSize: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class ProfileOptionsTile extends StatelessWidget {
  const ProfileOptionsTile({
    this.asset,
    this.onTap,
    this.title,
    Key key,
  }) : super(key: key);
  final String title;
  final String asset;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(top: 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: MetaColors.subTextColor.withOpacity(0.2)))),
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Image(
            image: AssetImage(asset),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

class ProfileTIleWidget extends StatelessWidget {
  const ProfileTIleWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: MetaColors.gradient),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(MetaAssets.dummyProfile),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            ),
                            Text(
                              "Tony Stark",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "tevdmarre@ezigboe.com",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image(
                          image: AssetImage(MetaAssets.profileArrowRight)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
