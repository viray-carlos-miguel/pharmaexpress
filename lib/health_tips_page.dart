// health_tips_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthTipsPage extends StatelessWidget {
  const HealthTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Health Tips & Advice"),
        backgroundColor: CupertinoColors.systemBlue,
        brightness: Brightness.dark,
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Health Tips",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemBlue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              String title = "Tip ${index + 1}";
              String subtitle = getHealthTip(index);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(subtitle),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String getHealthTip(int index) {
    String healthTip = "";
    switch (index) {
      case 0:
        healthTip = "Drink at least 8 glasses of water a day to stay hydrated.";
        break;
      case 1:
        healthTip = "Get at least 7 hours of sleep each night to help your body rest and recover.";
        break;
      case 2:
        healthTip = "Exercise for at least 30 minutes a day to help maintain a healthy weight and reduce the risk of chronic diseases.";
        break;
      case 3:
        healthTip = "Eat a balanced diet that includes a variety of fruits, vegetables, whole grains, and lean proteins.";
        break;
      case 4:
        healthTip = "Limit your intake of sugary drinks and foods high in saturated and trans fats.";
        break;
      case 5:
        healthTip = "Practice good hygiene, such as washing your hands frequently and covering your mouth when you cough or sneeze.";
        break;
      case 6:
        healthTip = "Don't smoke or use tobacco products, as they can increase your risk of heart disease, lung cancer, and other health problems.";
        break;
      case 7:
        healthTip = "Get regular check-ups and screenings to help detect and prevent health problems early.";
        break;
      case 8:
        healthTip = "Manage stress through techniques such as meditation, deep breathing, or yoga.";
        break;
      case 9:
        healthTip = "Limit your screen time and take breaks to rest your eyes and stretch.";
        break;
      case 10:
        healthTip = "Get enough vitamin D through sun exposure, supplements, or fortified foods.";
        break;
      case 11:
        healthTip = "Eat foods that are rich in omega-3 fatty acids, such as salmon and walnuts, to help reduce inflammation.";
        break;
      case 12:
        healthTip = "Stay active and engaged with activities you enjoy, such as hobbies or spending time with friends and family.";
        break;
      case 13:
        healthTip = "Practice good dental hygiene, such as brushing and flossing your teeth regularly and visiting your dentist for regular check-ups.";
        break;
      case 14:
        healthTip = "Get enough potassium through foods such as bananas, leafy greens, and sweet potatoes to help lower blood pressure.";
        break;
      case 15:
        healthTip = "Limit your intake of processed and packaged foods, and opt for whole, nutrient-dense foods instead.";
        break;
      case 16:
        healthTip = "Stay up-to-date on recommended vaccinations to help prevent illnesses and infections.";
        break;
      case 17:
        healthTip = "Get enough calcium through foods such as dairy products, leafy greens, and fortified plant-based milk to help maintain strong bones.";
        break;
      case 18:
        healthTip = "Practice good mental health by seeking help when you need it, and taking care of your emotional well-being.";
        break;
      case 19:
        healthTip = "Get enough fiber through foods such as fruits, vegetables, whole grains, and legumes to help regulate digestion and support healthy blood sugar levels.";
        break;
      default:
        healthTip = "Stay informed and educated about health and wellness by reading reputable sources and talking to healthcare professionals.";
        break;
    }
    return healthTip;
  }
}