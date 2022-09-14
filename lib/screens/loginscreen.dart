import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/authMethod.dart';
import 'package:free_blog/screens/homeScreen.dart';
import 'package:free_blog/screens/signUpScreen.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/widget/customButton.dart';
import 'package:free_blog/widget/customForm.dart';

import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  void loginUser() async {
    setState(() {
      _loading = true;
    });
    String res = await AuthMethod().loginUser(
        email: _emailController.text, password: _passwordController.text);
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
    return Scaffold(
      body: Padding(
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
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: _passwordController,
            hintText: "Password",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomButton(
              loading: _loading,
              onTap: () {
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
    );
  }
}
