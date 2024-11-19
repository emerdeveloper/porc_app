import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/extension/widget_extension.dart';
import 'package:porc_app/core/services/auth_service.dart';
import 'package:porc_app/ui/screens/auth/login/login_viewmodel.dart';
import 'package:porc_app/ui/widgets/button_widget.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewmodel(AuthService()),
      child: Consumer<LoginViewmodel>(builder: (context, model, _) {
        return Scaffold(
          body: Column(
            children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bienvenido",
                          style: TextStyle(
                            color: white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10), // Espacio entre los textos
                        Text(
                          "Inicia sesión para continuar",
                          style: TextStyle(
                            color: grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [                
                40.verticalSpace,
                
                //30.verticalSpace,
                CustomTextfield(
                  titleText: "Correo",
                  hintText: "Tu correo",
                  onChanged: model.setEmail,
                ),
                20.verticalSpace,
                CustomTextfield(
                  titleText: "Contraseña",
                  hintText: "Tu contraseña",
                  onChanged: model.setPassword,
                  isPassword: true,
                ),
                30.verticalSpace,
                CustomButton(
                    loading: model.state == ViewState.loading,
                    onPressed: model.state == ViewState.loading
                        ? null
                        : () async {
                            try {
                              await model.login();
                              context
                                  .showSnackbar("User logged in successfully!");
                                  Navigator.pushReplacementNamed(context, home);
                            } on FirebaseAuthException catch (e) {
                              context.showSnackbar(e.toString());
                            } catch (e) {
                              context.showSnackbar(e.toString());
                            }
                          },
                    text: "Ingresar"),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tienes cuenta? ",
                      style: body.copyWith(color: grey),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, signup);
                        },
                        child: Text("Registrate",
                            style: body.copyWith(fontWeight: FontWeight.bold)))
                  ],
                ),
              ],
            ),
          ),
            ],
          ),
          
        );
      }),
    );
  }
}