import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_utils.dart';
import '../../utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final TextStyle style;
  final double? height;
  final Color color;
  final bool loading;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    required this.color,
    required this.style,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.0.h),
            // border: Border.all(width: .2.w, color: AppColors.kGreyToWhite),
          ),
          child: Center(
            child: loading
                ? Utils().loader()
                : Text(
                    text,
                    style: style,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
          )),
    );
  }
}
