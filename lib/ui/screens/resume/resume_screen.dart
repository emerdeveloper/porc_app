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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
        child: Column(
          children: [
            50.verticalSpace,
            CustomButton(
              text: "Logout",
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                AuthService().logout();
              },
            ),
            Text("Shared files:", style: TextStyle(fontWeight: FontWeight.bold)),
              sharedFiles != null && !sharedFiles!.isEmpty ? Text(
                sharedFiles!.map((f) => f.toMap()).join(",\n****************\n"),
              ) : Text("No hay datos")
          ],
        ),
      ),
    );
  }
}