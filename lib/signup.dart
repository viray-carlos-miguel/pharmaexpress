import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String server = "https://pharmaexpressdelivery.shop/api/";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // Function to sign up user
  Future<void> signupUser() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Input validation
    if (username.isEmpty || password.isEmpty) {
      showErrorDialog("Username and password are required.");
      return;
    }

    if (password.length < 6) {
      showErrorDialog("Password must be at least 6 characters.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(server + "signup.php"),
        body: {
          "username": username,
          "password": password,
        },
      );

      var data = jsonDecode(response.body);
      setState(() {
        isLoading = false;
      });

      if (data["success"]) {
        showSuccessDialog();
      } else {
        showErrorDialog("Signup failed. Username may be taken.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog("An error occurred. Please try again.");
    }
  }

  // Show error alert
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

  // Show success alert
  void showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Success"),
        content: const Text("Account created successfully!"),
        actions: [
          CupertinoButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Navigate back to login page
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Sign Up for Pharma Express"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    "assets/pharma_logo.png", // Replace with your asset path
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Username Field
                CupertinoTextField(
                  controller: usernameController,
                  placeholder: "Username",
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 10),

                // Password Field
                CupertinoTextField(
                  controller: passwordController,
                  placeholder: "Password",
                  padding: const EdgeInsets.all(12),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Signup Button
                CupertinoButton.filled(
                  child: isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text("Sign Up"),
                  onPressed: signupUser,
                ),

                const SizedBox(height: 10),

                // Go back to login
                CupertinoButton(
                  child: const Text("Already have an account? Login"),
                  onPressed: () {
                    Navigator.pop(context); // Go back to login page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
