import 'package:flutter/material.dart';
// import 'package:pmsn_p3/components/my_button.dart';
import 'package:pmsn_p3/components/my_textfield.dart';
import 'package:pmsn_p3/screens/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMeSatus();
  }

  void _checkRememberMeSatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('isLoggedIn') ?? false;
    if (rememberMe) {
      String savedUsername = prefs.getString('username') ?? '';
      String savedPassword = prefs.getString('password') ?? '';

      usernameController.text = savedUsername;
      passwordController.text = savedPassword;
      setState(() {
        rememberMe = true;
      });
    }
  }

  void _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    bool isAuthenticated = await authenticateUser(username, password);

    if (isAuthenticated) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        prefs.setBool('rememberMe', true);
        prefs.setString('username', username);
        prefs.setString('password', password);
      } else {
        prefs.remove('rememberMe');
        prefs.remove('username');
        prefs.remove('password');
      }
      //Redirigir a la pantalla principal
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePageScreen()));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de inicio de sesion'),
              content: Text('Credenciales incorrectas, intentalo de nuevo'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //para que pueda dimensionarse y no afecte el teclado de la pantalla
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    // color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  textColor: Colors.black,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  textColor: Colors.black,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe, 
                      onChanged: (value){
                        setState(() {
                          rememberMe = value!;
                        });
                      }),
                    Text('Recordarme')
                  ],
                ),
                MaterialButton(
                    color: Colors.black,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: _login)
              ],
            ),
          ),
        ));
  }
}

Future<bool> authenticateUser(String username, String password) async {
  if (username == 'admin' && password == '1234') {
    return true;
  } else {
    return false;
  }
}
