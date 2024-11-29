import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      this.focusNode,
      this.controller,
      this.hintText,
      required this.titleText,
      this.onChanged,
      this.onTap,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.isEnable = true,
      this.isPassword = false,
      this.isChatText = false,
      this.isSearch = false});

  final void Function(String)? onChanged;
  final String? hintText;
  final String? initialValue;
  final String titleText;
  final FocusNode? focusNode;
  final bool isSearch;
  final bool isChatText;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool isPassword;
  final bool isEnable;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isChatText ? 35.h : null,
      child: buildTitle(
        title: titleText,
        child: TextFormField(
          enabled: isEnable,
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isChatText ? 25.r : 10.r)),
            hintText: hintText,
            hintStyle: body.copyWith(color: grey),
            filled: true,
            fillColor: isChatText ? white : grey.withOpacity(0.1),
          ),
        ),
      )
    );
  }


  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}