import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';
import 'package:video/provider/profile_provider.dart';
import 'package:video/provider/video_picker.dart';
import 'package:video/view/Landing/landing.dart';
import 'package:video/view/Map/map.dart';
import 'package:video/view/videoCall/navigation.dart';
import 'package:video/view/profile/profile.dart';
import 'package:video/view/profile/profile_screen.dart';
import 'package:video/view/videoCall/video_call.dart';
import 'package:video/view/videos/video_detail.dart';
import 'package:video/view_model.dart/location.dart';
import 'provider/auth_provider.dart';
import 'utils/Routes/routenames.dart';
import 'view/Home/home.dart';
import 'view/Login/login_screen.dart';
import 'view/Post/post_screen.dart';

Future<bool> startForegroundService() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon:
        AndroidResource(name: 'background_icon', defType: 'drawable'),
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  startForegroundService();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Map<String, dynamic>>>(
            create: (context) {
              return FirebaseFirestore.instance
                  .collection('videos')
                  .orderBy('date')
                  .snapshots()
                  .map((snapshots) => snapshots.docs
                      .map((doc) => doc.data())
                      .toList()
                      .reversed
                      .toList());
            },
            initialData: const []),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => VideoPickerProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider())
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 187, 135, 196)),
            useMaterial3: true,
          ),
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? RouteNames.loginscreen
              : RouteNames.landingScreen,
          routes: {
            RouteNames.landingScreen: (context) => const LandingScreen(),
            RouteNames.videocallscreen: (context) => const VideoCall(),
            RouteNames.loginscreen: (context) => const LoginScreen(),
            RouteNames.homeScreen: (context) => const HomeScreen(),
            RouteNames.postScreen: (context) => const PostScreen(),
            RouteNames.profileScreen: (context) => const ProfileScreen(),
            RouteNames.profile: (context) => const Profile(),
            RouteNames.videodetials: (context) => const VideoDetails(),
            RouteNames.navigationscreen: (context) => const NavigationScreen(),
            RouteNames.mapscreen: (context) => const MapScreen()
          },
        );
      }),
    );
  }
}
