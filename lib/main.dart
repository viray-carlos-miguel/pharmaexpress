import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Import the Login Page

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/pharma_logo.png", // Add your logo in assets
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Your trusted online pharmacy for quick and reliable medicine delivery.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),

            const SizedBox(height: 31),

            // Get Started Button
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(30),
              onPressed: () {
                // Navigate to Login Page
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
