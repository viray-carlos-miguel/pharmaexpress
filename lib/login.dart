import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'menu.dart';

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
  String server = "https://pharmaexpressdelivery.shop//api/";
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
      print("Response Data: $data");

      setState(() {
        isLoading = false;
      });

      if (data["success"] == true) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => MenuScreen()),
        );
      } else {
        showErrorDialog("Invalid username or password.");
      }
    } catch (e) {
      print("Error: $e");
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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // ✅ Logo section
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/pharma_logo.png', // Make sure it's declared in pubspec.yaml
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),

                  // If you want to use a network logo instead, replace with:
                  // Image.network(
                  //   'https://yourdomain.com/logo.png',
                  //   width: 120,
                  //   height: 120,
                  //   fit: BoxFit.contain,
                  // ),
                ),
              ),

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
      ),
    );
  }
}
