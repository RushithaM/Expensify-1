import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/login/login.dart';
import 'package:expensetracker/screens/profile/about.dart';
import 'package:expensetracker/screens/profile/help.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/errorText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  String nameError = "";
  String emailError = "";
  bool enableEdit = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: lightAppColor,
                    child: Icon(Icons.person, size: 60),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: lightAppColor, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                            color: lightAppColor),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  if (nameError.length > 0) {
                                    if (mounted)
                                      setState(() {
                                        nameError = "";
                                      });
                                  }
                                },
                                controller: nameController,
                                focusNode: nameFocus,
                                textCapitalization: TextCapitalization.words,
                                readOnly: !enableEdit,
                                decoration: InputDecoration(
                                  hintText: (enableEdit)
                                      ? "Enter name"
                                      : prefs!.getString('name'),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ErrorText(nameError),
                      SizedBox(height: 16),
                      Text("Email",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: lightAppColor, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                            color: lightAppColor),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  if (emailError.length > 0) {
                                    if (mounted)
                                      setState(() {
                                        emailError = "";
                                      });
                                  }
                                },
                                controller: emailController,
                                focusNode: emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                readOnly: !enableEdit,
                                decoration: InputDecoration(
                                  hintText: (enableEdit)
                                      ? "Enter email"
                                      : prefs!.getString('email'),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ErrorText(emailError),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                enableEdit = !enableEdit;
                                nameError = "";
                                emailError = "";
                              });
                            emailFocus.unfocus();
                            nameFocus.unfocus();
                          },
                          child: Text((enableEdit) ? "Cancel" : "Edit Profile",
                              style: TextStyle(
                                fontSize: 16,
                                color: appColor,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      SizedBox(height: 7),
                      if (enableEdit)
                        (isLoading)
                            ? Center(
                                child:
                                    CircularProgressIndicator(color: appColor))
                            : Center(
                                child: InkWell(
                                    onTap: () async {
                                      emailFocus.unfocus();
                                      nameFocus.unfocus();
                                      if (nameController.text.trim().isEmpty) {
                                        if (mounted)
                                          setState(() {
                                            nameError = "Enter name";
                                          });
                                        return;
                                      }
                                      if (emailController.text.trim().isEmpty) {
                                        if (mounted)
                                          setState(() {
                                            emailError = "Enter email";
                                          });
                                        return;
                                      }
                                      if (!isValidEmail(
                                          emailController.text.trim())) {
                                        if (mounted)
                                          setState(() {
                                            emailError = "Enter valid email";
                                          });
                                        return;
                                      }
                                      if (mounted)
                                        setState(() {
                                          isLoading = true;
                                        });
                                      var resp = await userPro.updateUser(
                                          nameController.text.trim(),
                                          emailController.text.trim(),
                                          prefs!.getString('id')!);
                                      if (mounted)
                                        setState(() {
                                          isLoading = false;
                                        });
                                      if (resp['message'] == 'success') {
                                        prefs!.setString(
                                            'name', nameController.text);
                                        prefs!.setString(
                                            'email', emailController.text);
                                        emailController.text = "";
                                        nameController.text = "";
                                        if (mounted)
                                          setState(() {
                                            enableEdit = false;
                                          });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Profile updated"),
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Error updating profile"),
                                        ));
                                      }
                                    },
                                    child: AppButton("Update"))),
                      SizedBox(height: 20),
                      Container(height: 2, color: lightColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("About",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      Container(height: 2, color: lightColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HelpPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Help",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      Container(height: 2, color: lightColor),
                      InkWell(
                        onTap: () async {
                          await prefs!.setBool('login', false);
                          await prefs!.setString('id', '');
                          await prefs!.setString('email', '');
                          await prefs!.setString('name', '');
                          transPro.categoryMonthlyTransactions = [];
                          transPro.monthlyTransactions = [];
                          transPro.recentTransactions = [];
                          catPro.categories = [];
                          initGlobals();
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Log out",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      Container(height: 2, color: lightColor),
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
