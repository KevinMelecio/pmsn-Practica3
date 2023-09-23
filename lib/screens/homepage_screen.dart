import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn_p3/assets/global_values.dart';
import 'package:pmsn_p3/assets/styles_app.dart';
// import 'package:pmsn_p3/assets/theme_maneger.dart';
import 'package:pmsn_p3/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _disableRememberMe(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('rememberMe');
  prefs.remove('username');
  prefs.remove('password');

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  bool isDarkModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Scaffold(
            drawer: createDrawer(),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              iconTheme: value
                  ? StyleApp.darkIcon(context)
                  : StyleApp.lightIcon(context),
              leading: Builder(
                  builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.settings),
                      )),
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a la pagina principal',
                  style: TextStyle(
                    // color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 248, 3, 3)),
                  onPressed: () {
                    _disableRememberMe(context);
                  },
                  icon: Icon(Icons.logout),
                  label: Text(
                    'Logout',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            )),
          );
        });
  }

  Widget createDrawer() {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Drawer(
            child: ListView(
              children: [
                const UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage('http://i.pravatar.cc/300'),
                    ),
                    accountName: Text('Kevin Melecio'),
                    accountEmail: Text('Administrador')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: DayNightSwitcher(
                      isDarkModeEnabled: GlobalValues.flagTheme.value,
                      onStateChanged: ((isDarkModeEnabled) {
                        GlobalValues().getTheme(isDarkModeEnabled);
                        GlobalValues.flagTheme.value = isDarkModeEnabled;
                      })),
                ),
                ListTile(
                  iconColor: value
                  ? StyleApp.darkIconDrawer(context)
                  : StyleApp.lightIconDrawer(context),
                  leading: Icon(Icons.logout),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('LogOut'),
                  onTap: () {
                    _disableRememberMe(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
