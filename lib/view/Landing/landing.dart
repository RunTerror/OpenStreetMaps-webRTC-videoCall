import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:video/view/Home/home.dart';
import 'package:video/view/Map/map.dart';
import 'package:video/view/videoCall/navigation.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int selectedIndex=0;
  List<Widget> screens=const [ HomeScreen(), NavigationScreen(), MapScreen()];
  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Scaffold(
      body: screens[selectedIndex],
     bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              30,
            ),
          ),
        ),
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GNav(
            onTabChange: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            selectedIndex: selectedIndex,
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            backgroundColor:theme.primaryColor,
            activeColor:theme.primaryColor,
            tabBackgroundColor: Colors.white,
            curve: Curves.easeInExpo,
            tabBorderRadius: 50,
            tabs: const [
              GButton(
                icon: Icons.video_settings,
                text: "Videos",
              ),
              GButton(
                icon: Icons.video_call,
                text: "VideoCall",
              ),
              GButton(
                icon: Icons.map,
                text: "Maps",
              ),
            ],
          ),
        ),
      ),
    );
  }
}