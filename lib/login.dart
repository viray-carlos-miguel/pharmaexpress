import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'menu.dart'; // Import the menu.dart file

void main() => runApp(const CupertinoApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String server = "http://192.168.1.251/api/";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> loginUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("Please enter both username and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(server + "login.php"),
        body: {
          "username": usernameController.text,
          "password": passwordController.text,
        },
      );

      var data = jsonDecode(response.body);
      print("Response Data: $data"); // ✅ Debugging print

      setState(() {
        isLoading = false;
      });

      if (data["success"] == true) { // ✅ Ensure correct response handling
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => MenuScreen()),
        );
      } else {
        showErrorDialog("Invalid username or password.");
      }
    } catch (e) {
      print("Error: $e"); // ✅ Debugging print
      setState(() {
        isLoading = false;
      });
      showErrorDialog("An error occurred. Please try again later.");
    }
  }

  void showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Login to Pharma Express"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login Here",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            CupertinoTextField(
              controller: usernameController,
              placeholder: "Username",
              padding: const EdgeInsets.all(12),
            ),
            const SizedBox(height: 10),

            CupertinoTextField(
              controller: passwordController,
              placeholder: "Password",
              padding: const EdgeInsets.all(12),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            CupertinoButton.filled(
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text("Login"),
              onPressed: loginUser,
            ),
            const SizedBox(height: 10),

            CupertinoButton(
              child: const Text("Don't have an account? Sign Up here"),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const SignupPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
