import 'package:expensetracker/base.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/providers/user_provider.dart';
import 'package:expensetracker/screens/login/login.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/errorText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController rePwdController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  FocusNode rePwdFocus = FocusNode();
  String emailError = "";
  String nameError = "";
  String pwdError = "";
  String rePwdError = "";
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
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
            SizedBox(height: 20),
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Please sign up to enjoy all Expensify features",
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
                        if (nameError.length != 0) {
                          if (mounted)
                            setState(() {
                              nameError = "";
                            });
                        }
                      },
                      controller: nameController,
                      focusNode: nameFocus,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ErrorText(nameError),
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
                        if (rePwdError.length != 0) {
                          if (mounted)
                            setState(() {
                              rePwdError = "";
                            });
                        }
                      },
                      controller: rePwdController,
                      focusNode: rePwdFocus,
                      obscureText: !isRePasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {
                      if (mounted)
                        setState(() {
                          isRePasswordVisible = !isRePasswordVisible;
                        });
                    },
                    child: (isRePasswordVisible)
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
            ErrorText(rePwdError),
            SizedBox(height: 32),
            (isLoading)
                ? CircularProgressIndicator(color: appColor)
                : InkWell(
                    onTap: () async {
                      emailFocus.unfocus();
                      nameFocus.unfocus();
                      pwdFocus.unfocus();
                      rePwdFocus.unfocus();
                      if (emailController.text.trim().isEmpty) {
                        if (mounted)
                          setState(() {
                            emailError = "Enter email";
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
                      if (nameController.text.trim().isEmpty) {
                        if (mounted)
                          setState(() {
                            nameError = "Enter name";
                          });
                        return;
                      }
                      if (pwdController.text.contains(" ")) {
                        if (mounted)
                          setState(() {
                            pwdError = "Remove Space";
                          });
                        return;
                      }
                      if (pwdController.text.isEmpty) {
                        if (mounted)
                          setState(() {
                            pwdError = "Enter password";
                          });
                        return;
                      }
                      if (pwdController.text.length < 8) {
                        if (mounted)
                          setState(() {
                            pwdError = "Atleast 8 characters";
                          });
                        return;
                      }
                      if (rePwdController.text.isEmpty) {
                        if (mounted)
                          setState(() {
                            rePwdError = "Enter confirm password";
                          });
                        return;
                      }
                      if (pwdController.text != rePwdController.text) {
                        if (mounted)
                          setState(() {
                            rePwdError = "Password didn't match";
                          });
                        return;
                      }

                      if (mounted)
                        setState(() {
                          isLoading = true;
                        });
                      var resp = await UserProvider().signupUser(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          pwdController.text.trim());
                      if (mounted)
                        setState(() {
                          isLoading = false;
                        });
                      if (resp['message'] == 'success') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BasePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Sometihng went wrong"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: AppButton("Sign up")),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Color(0xFF585858),
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Login",
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
