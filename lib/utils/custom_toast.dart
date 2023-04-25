import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IconToastWidget extends StatelessWidget {
  final Key? key;
  final Color? backgroundColor;
  final String? message;
  final Widget? textWidget;
  final double? height;
  final double? width;
  final String? assetName;
  final EdgeInsetsGeometry? padding;

  IconToastWidget({
    this.key,
    this.backgroundColor,
    this.textWidget,
    this.message,
    this.height,
    this.width,
    @required this.assetName,
    this.padding,
  }) : super(key: key);

  factory IconToastWidget.fail({String? msg}) => IconToastWidget(
        message: msg,
        assetName: 'assets/images/ic_fail.png',
      );

  factory IconToastWidget.success({String? msg}) => IconToastWidget(
        message: msg,
        assetName: 'assets/images/ic_success.png',
      );

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: Colors.transparent,
      child: Container(
          height: 6.h,
          width: 40.w,
          // margin: EdgeInsets.symmetric(horizontal: 50.0),
          padding: padding ?? EdgeInsets.only(top: .5.h),
          decoration: ShapeDecoration(
            color: backgroundColor ?? const Color(0x9F000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  assetName!,
                  fit: BoxFit.fill,
                  width: 30,
                  height: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: textWidget ??
                    Text(
                      message ?? '',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize,
                          color: Colors.white),
                      softWrap: true,
                      maxLines: 200,
                    ),
              ),
            ],
          )),
    );

    return content;
  }
}
