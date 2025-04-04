import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Import your login page

void main() => runApp(const CupertinoApp(
  debugShowCheckedModeBanner: false,
  home: WelcomePage(),
));

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/pharma_logo.png",
                      height: 120,
                    ),
                  ),
                ),

                // App Name
                const Text(
                  "Pharma Express",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                ),

                const SizedBox(height: 10),

                // Introductory Text
                const Text(
                  "Your trusted online pharmacy for quick and reliable medicine delivery.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),

                const SizedBox(height: 30),

                // Get Started Button
                CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
