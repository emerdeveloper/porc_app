import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, 
      required this.text, 
      this.onPressed, 
      this.height,
      this.width,
      this.textStyle,
      this.loading = false});

  final void Function()? onPressed;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 1.sw,
      height: height ?? 40.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            side: const BorderSide(width: 3.0),
            shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(10)
            ),),
          onPressed: onPressed,
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(text, style: textStyle ?? body.copyWith(color: white))),
    );
  }
}