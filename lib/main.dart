import 'package:flutter/material.dart';
import 'package:pmsn_p3/assets/global_values.dart';
import 'package:pmsn_p3/assets/styles_app.dart';
import 'package:pmsn_p3/screens/homepage_screen.dart';
import 'package:pmsn_p3/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;
  runApp(MainApp(rememberMe: rememberMe));
}

class MainApp extends StatefulWidget {
  final bool rememberMe;
  const MainApp(
      {super.key, required this.rememberMe});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    GlobalValues().readTheme();
  }
  @override

  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: widget.rememberMe ? HomePageScreen() : LoginScreen(),
            theme: value
                ? StyleApp.darkTheme(context)
                : StyleApp.lightTheme(context),
          );
        });
  }
}
