import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/ui/screens/home/home_viewmodel.dart';
import 'package:porc_app/ui/screens/inversors/inversors_screen.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_list/pig_lots_screen.dart';
import 'package:porc_app/ui/screens/providers/providers_screen.dart';
import 'package:porc_app/ui/screens/resume/resume_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Widget> getScreens(String role) {
    if (role == "producer") {
      return [
        const InversorsScreen(),
        const ProvidersScreen(),
        const ResumeScreen(),
      ];
    } else if (role == "inversor") {
      return [
        const PigLotsScreen(),
        const ProvidersScreen(),
        const ResumeScreen(),
      ];
    } else {
      return [
        const Center(child: Text("No screens available")),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(),
      child: Consumer<HomeViewmodel>(builder: (context, model, _) {
        if (currentUser == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final screens = getScreens(currentUser.role ?? "");

        return Scaffold(
          body: screens[model.currentIndex],
          bottomNavigationBar: CustomNavBar(
            currentIndex: model.currentIndex,
            onTap: model.setIndex,
          ),
        );
      }),
    );
  }
}


class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed, // Fija el ancho de cada ítem
          backgroundColor: white,
          selectedItemColor: primary, // Color del ítem seleccionado
          unselectedItemColor: grey, // Color de los ítems no seleccionados
          showSelectedLabels: false, // Oculta etiquetas seleccionadas
          showUnselectedLabels: false, // Oculta etiquetas no seleccionadas
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: BottomNavButton(
                iconPath: homeIcon,
                isSelected: currentIndex == 0,
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: BottomNavButton(
                iconPath: profileIcon,
                isSelected: currentIndex == 1,
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: BottomNavButton(
                iconPath: profileIcon,
                isSelected: currentIndex == 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,
    required this.iconPath,
    required this.isSelected,
  });

  final String iconPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(
        iconPath,
        height: 35,
        width: 35,
        color: isSelected ? Theme.of(context).primaryColor : grey, // Resaltar ítem seleccionado
      ),
    );
  }
}
