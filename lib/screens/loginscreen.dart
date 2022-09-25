import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/authMethod.dart';
import 'package:free_blog/screens/homeScreen.dart';
import 'package:free_blog/screens/signUpScreen.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/utils/screenDetector.dart';
import 'package:free_blog/widget/customButton.dart';
import 'package:free_blog/widget/customForm.dart';

import '../style/appColors.dart';
import '../utils/utils.dart';
import '../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _loading1 = false;

  void loginUser() async {
    setState(() {
      _loading = true;
    });
    String res = await AuthMethod().loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);

      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      showSnackBar(context, res);
    }
  }

  void googleSignIn() async {
    setState(() {
      _loading1 = true;
    });

    bool res = await AuthMethod().signInWithGoogle(context);

    if (res) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);

      setState(() {
        _loading1 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: loginKey,
        child: Center(
          child: SizedBox(
            width:
                screenDetector.isMobile(context) ? size.width : size.width / 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView(children: [
                const Center(
                  child: Text(
                    "freeBlog.",
                    style: AppFonts.header,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Validators().validateEmail(value!),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                    loading: _loading,
                    onTap: () {
                      if (!loginKey.currentState!.validate()) return;

                      loginUser();
                    },
                    label: "Login"),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: AppFonts.bodyWhite
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    googleSignIn();
                  },
                  child: Container(
                    height: 58,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xff36474f))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _loading1
                          ? Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/googleLogo.png",
                                  height: 40,
                                  width: 40,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Continue with google",
                                  style: AppFonts.bodyWhite,
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

            
                Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("New to freeBlog.? SignUp")),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
