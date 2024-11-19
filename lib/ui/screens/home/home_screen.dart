import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/ui/screens/home/home_viewmodel.dart';
import 'package:porc_app/ui/screens/inversors/inversors_screen.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/ui/screens/resume/resume_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Widget> _screens = [
    const InversorsScreen(),
    const ResumeScreen(),
    const Center(child: Text("Home Screen"))
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    const items = [
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: homeIcon)),
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: profileIcon)),
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: profileIcon)),
    ];
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(),
      child: Consumer<HomeViewmodel>(builder: (context, model, _) {
        //return currentUser == null
        return currentUser != null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                body: HomeScreen._screens[model.currentIndex],
                bottomNavigationBar: CustomNavBar(
                  onTap: model.setIndex,
                  items: items,
                ));
      }),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key, this.onTap, required this.items});

  final void Function(int)? onTap;
  final List<BottomNavigationBarItem> items;

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
            onTap: onTap,
            items: items,
          ),
        ));
  }
}

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({super.key, required this.iconPath});
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Image.asset(
        iconPath,
        height: 35,
        width: 35,
      ),
    );
  }
}