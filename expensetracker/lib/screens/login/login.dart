import 'package:expensetracker/base.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/providers/user_provider.dart';
import 'package:expensetracker/screens/login/signup.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/errorText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String emailError = "";
  String pwdError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 100, 40, 40),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'Expensify',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Sign in",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Please login to enjoy all Expensify features",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF585858),
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE0E4F5), width: 3),
                  borderRadius: BorderRadius.circular(8.0),
                  color: lightAppColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (emailError.length != 0) {
                          if (mounted)
                            setState(() {
                              emailError = "";
                            });
                        }
                      },
                      controller: emailController,
                      focusNode: emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ErrorText(emailError),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE0E4F5), width: 3),
                  borderRadius: BorderRadius.circular(8.0),
                  color: lightAppColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (pwdError.length != 0) {
                          if (mounted)
                            setState(() {
                              pwdError = "";
                            });
                        }
                      },
                      controller: pwdController,
                      focusNode: pwdFocus,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {
                      if (mounted)
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                    },
                    child: (isPasswordVisible)
                        ? Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF8B8EC4),
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                            color: Color(0xFF8B8EC4),
                          ),
                  )
                ],
              ),
            ),
            ErrorText(pwdError),
            SizedBox(height: 44),
            (isLoading)
                ? CircularProgressIndicator(color: appColor)
                : InkWell(
                    onTap: () async {
                      emailFocus.unfocus();
                      pwdFocus.unfocus();
                      if (emailController.text.isEmpty) {
                        if (mounted)
                          setState(() {
                            emailError = 'Enter Email';
                          });
                        return;
                      }
                      if (!isValidEmail(emailController.text.trim())) {
                        if (mounted)
                          setState(() {
                            emailError = "Enter valid email";
                          });
                        return;
                      }
                      if (pwdController.text.isEmpty) {
                        if (mounted)
                          setState(() {
                            pwdError = 'Enter password';
                          });
                        return;
                      }
                      if (mounted)
                        setState(() {
                          isLoading = true;
                        });
                      var resp = await UserProvider()
                          .loginUser(emailController.text, pwdController.text);
                      if (mounted)
                        setState(() {
                          isLoading = false;
                        });
                      if (resp['message'] == 'success') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BasePage()));
                      } else if (resp['message'] == "User not found" ||
                          resp['message'] == "Invalid credentials") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(resp['message']),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(resp['message']),
                        ));
                      }
                    },
                    child: AppButton("Login")),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Color(0xFF585858),
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    ));
  }
}
