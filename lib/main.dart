import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/src/constants/theme/dark_theme.dart';
import 'package:movie_app/src/controller/movie_controller.dart';
import 'package:movie_app/src/view/screens/home_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MovieController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pop Movie',
      theme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
