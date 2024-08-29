import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:music_players/firebase_options.dart';
import 'package:music_players/screen/home_view.dart';
import 'package:music_players/screen/play_song.dart';
import 'package:music_players/screen/upload_music.dart';
import 'package:music_players/screen/view_all_music.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: false,
        child: OverlaySupport.global(
          child: GetMaterialApp(
            title: "Music",
            debugShowCheckedModeBanner: false,
            getPages: [
              GetPage(
                name: "/",
                page: () => const HomeView(),
              ),
              GetPage(
                name: "/upload",
                page: () => const UploadMusicView(),
              ),
              GetPage(
                name: "/play",
                page: () => const SongScreen(),
              ),
              GetPage(
                name: "/all",
                page: () => const ViewAllMusic(),
              ),
            ],
          ),
        ));
  }
}
