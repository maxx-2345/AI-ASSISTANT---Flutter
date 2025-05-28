import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'helper/pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Pref.Initialize();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 5,
          shadowColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: SplashScreen(),
    );
  }
}
