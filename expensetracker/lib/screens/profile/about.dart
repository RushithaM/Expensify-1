import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
          child: Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About Expensify",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                  "Expensify is a smart and simple expense tracker designed to help you take control of your finances. Whether you're tracking daily spending, managing budgets, or analyzing financial habits, Expensify makes it effortless.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text("Key Features",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                  "1. Log expenses and income easily.\n2. Customize categories with unique emojis.\n3. Analyze your spending across different categories",
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text("Contact Us",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                    "For feedback or questions, contact us at sujan.kommalapati@gmail.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(height: 20),
                Text("Version",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                  "1.0.0",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
