import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_utils.dart';
import '../../utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
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
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(1.0.h)),
          child: Center(
            child: loading
                ? Utils().loader()
                : Text(
                    text,
                    style: AppTextStyles.regWhiteBold12,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
          )),
    );
  }
}
