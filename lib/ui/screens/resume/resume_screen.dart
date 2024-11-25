import 'dart:io';

import 'package:porc_app/core/services/auth_service.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key, this.sharedFiles});
  final List<SharedMediaFile>? sharedFiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview de Imagen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            50.verticalSpace,
            CustomButton(
              text: "Logout",
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                AuthService().logout();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Archivo compartido:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            sharedFiles != null && sharedFiles!.isNotEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vista previa de la imagen:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(sharedFiles!.first.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Nombre del archivo: ${sharedFiles!.first.thumbnail}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      "No hay datos",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
