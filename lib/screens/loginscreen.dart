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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: loginKey,
        child: Center(
          child: SizedBox(
            width: screenDetector.isMobile(context) ? size.width : size.width / 2,
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
