import 'package:flutter/material.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';

buildButton(
    {@required String title,
    @required Function() handler,
    Color color,
    TextStyle titleStyle}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      splashColor: MetaColors.gradientColorTwo,
      onTap: handler ?? () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: MetaColors.gradient),
        width: double.maxFinite,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title ?? "",
              style: titleStyle ?? TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
      ),
    ),
  );
}

class SubTextWidget extends StatelessWidget {
  const SubTextWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: MetaColors.subTextColor, fontSize: 12),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}

SnackBar banner(BuildContext context, @required message,
    {bool isError = false}) {
  return SnackBar(
    elevation: 0,
    padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 2 * kToolbarHeight,
        top: kToolbarHeight),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    content: MessageWidget(
      message: message,
      isError: isError,
    ),
    onVisible: () {
      Future.delayed(Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      });
    },
  );
}

class Loader extends StatefulWidget {
  final String message;
  const Loader({Key key, this.message}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: MetaColors.postShadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                      spreadRadius: 5)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.message ?? "",
                    style: TextStyle(color: MetaColors.textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  MessageWidget({Key key, this.message, this.isError = false})
      : super(key: key);
  String message;
  bool isError;
  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: (CurvedAnimation(
                parent: AnimationController(
                    vsync: this, duration: Duration(milliseconds: 500))
                  ..forward(),
                curve: Curves.easeIn)
            .drive(Tween(begin: Offset(0, -1), end: Offset(0.0, 0.5)))),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              gradient: widget.isError ? null : MetaColors.gradient,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ));
  }
}
