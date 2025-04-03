import 'package:flutter/cupertino.dart';
import 'main.dart'; // Import your main.dart or home page file

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String loginUser = "Test"; // Replace with login user's name


    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Profile & Settings"),
        backgroundColor: CupertinoColors.systemBlue,
        brightness: Brightness.dark,
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),

          settingsSection(context),
        ],
      ),
    );
  }

  // Profile Section
  Widget profileSection(String loginUser, String loginUserImage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              loginUserImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loginUser,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "View Profile",
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const Spacer(),
          CupertinoButton(
            child: const Icon(CupertinoIcons.gear),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Settings Section
  Widget settingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          settingCard("Account Settings", CupertinoIcons.gear),
          const SizedBox(height: 10),
          settingCard("Notification Settings", CupertinoIcons.bell),
          const SizedBox(height: 10),
          settingCard("Help & Support", CupertinoIcons.question),
          const SizedBox(height: 10),
          settingCard("Log Out", CupertinoIcons.square_split_2x2, onTap: () {
            _logout(context); // Call the logout function
          }),
        ],
      ),
    );
  }

  // Setting Card
  Widget settingCard(String title, IconData icon, {void Function()? onTap}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: CupertinoColors.systemBlue,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(),
        CupertinoButton(
          child: const Icon(CupertinoIcons.chevron_right),
          onPressed: onTap,
        ),
      ],
    );
  }

  // Logout function
  void _logout(BuildContext context) {
    // If you have any logout logic (like clearing user data or authentication), do it here
    // For now, we will just pop the ProfileSettingsPage and go back to the main screen

    // Navigate back to the main screen (home page) using Navigator
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const WelcomePage()), // Replace MyHomePage with your actual home page widget
    );
  }
}
