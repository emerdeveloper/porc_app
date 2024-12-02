import 'dart:io';

import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/ui/widgets/button_widget.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class PreviewPayment extends StatelessWidget {
  const PreviewPayment(
      {super.key,
      required this.sharedFiles,
      required this.isSelected,
      this.onPressed,
      this.loading = false});

  final List<SharedMediaFile> sharedFiles;
  final bool isSelected;
  final void Function()? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(sharedFiles.first.path),
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Seleccionaste:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                CustomButton(
                  loading: loading,
                  onPressed: onPressed,
                  height: 35,
                  width: 90, 
                  textStyle: const TextStyle(fontSize: 12, color: white),
                  text: "Enviar",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
