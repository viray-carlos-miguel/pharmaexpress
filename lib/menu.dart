import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'medicines.dart';
import 'order_history_page.dart';
import 'health_tips_page.dart';
import 'profile_settings_page.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Pharma Express Menu"),
        backgroundColor: CupertinoColors.systemBlue,
        brightness: Brightness.dark,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(context, "Medicines", CupertinoIcons.shopping_cart, const MedicinesPage()),
                  _buildMenuItem(context, "Order History", CupertinoIcons.time, const OrderHistoryPage()),
                  _buildMenuItem(context, "Health Tips & Advice", CupertinoIcons.heart, const HealthTipsPage()),
                  _buildMenuItem(context, "Profile & Settings", CupertinoIcons.person, const ProfileSettingsPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: CupertinoColors.systemBlue, size: 28),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.forward, color: CupertinoColors.systemGrey),
            ],
          ),
        ),
      ),
    );
  }
}