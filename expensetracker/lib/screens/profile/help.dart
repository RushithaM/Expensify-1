import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
          child: Text(
            'Help & Support',
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
                Text("Getting started",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                  "● How to Create Categories:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                      "Navigate to Categories and add a new category with a name and emoji.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Text(
                  "● How to Add Transactions:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                      "Navigate to Add and make a new transaction with a category, amount, and description.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w400,
                      )),
                ),
                SizedBox(height: 20),
                Text("Common issues",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Text(
                  "Categories cannot have same name and an emoji. So make sure to give unique names and emojis.",
                  style: TextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
