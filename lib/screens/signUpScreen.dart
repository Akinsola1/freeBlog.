import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/authMethod.dart';
import 'package:free_blog/screens/homeScreen.dart';
import 'package:free_blog/screens/loginscreen.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/utils/utils.dart';
import 'package:free_blog/widget/customButton.dart';
import 'package:free_blog/widget/customForm.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _loading = false;
  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _loading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _loading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        _loading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(children: [
          Center(
            child: Text(
              "freeBlog.",
              style: AppFonts.header,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: AppColors.secondaryColor,
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAHBhMSEBIPDxUQEQ8QFRIODg8QEBAVFREYFhURFRYYHSggGRolHRUTITEiKCkrLi4uFx8zODMsNygtLi0BCgoKDQ0NDw0NDisZFRkrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIAOEA4QMBIgACEQEDEQH/xAAaAAEAAwEBAQAAAAAAAAAAAAAAAwQFAQIH/8QANBABAAEDAgIHBQgDAQAAAAAAAAECAxEEITFxEhNBUWGBsQUicpHwIzIzNFKhwdFC4fEk/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAH/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwD6oAqAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIrmopt8Z37o3kErkzFPGYjnLOvauqvh7seHH5q87yDYiuJ4TE8ph6Yr3TdqpjaqY85BrjNt6yqnj73Nds36b0bce6eIJQAAAAAAAAAAAAAAAAAAAAVdfd6NGI/y9AR6rVZ2pnnP9KYKAAAADtNU0zmNsOANTTXuuo8Y4/2mZWmudVeiezhLVQAAAAAAAAAAAAAAAAAAGXq6+nfnw2+X1LTmejGe7djcQAFAAAAAABrWKulZpnwhktXS/l6eSCUAAAAAAAAAAAAAAAAAEd/azV8M+jJa1/8Cr4Z9GSAAoAAAfX18gAAGno5/wDNHn6yzGnovy0efqgnAAAAAAAAAAAAAAAAABS196aZ6MbZic+PgoQu+0qfepnmp43AyZMGFDJEmDAOTwJnETydwYAmcGcGDAC5obs9Po9mJ8lPCz7Pj7flEg0gEAAAAAAAAAAAAAAAAFbX09Kxnun/AEzmxVTFdMxPbszdTY6iY3zE5BCAoAAAAAAL3s6n3ZnyVdPZ665jhtlp2rcWqMQg9gAAAAAAAAAAAAAAAAAINXb6yxPhunAYon1djqq8xwnh4eCBQAAAABJp7PXXMdnbILmgt9G1n9XpC05EYh1AAAAAAAAAAAAAAAAAAAABBrYzpp8vVmNLXVY08x349WaAAoAAND2fH2M/F/EM9f8AZ9X2cx45/ZBbAAAAAAAAAAAAAAAAAABFc1FNvjPlG8glVNZqJtziNsxnKO5rpn7sY8Z3lVqqmuczMzzAmZqnffm4CgAAAAROABc0moqquRTO+c79vBeYsT0Z225LVvW1U8fe/aUGgILeqouduPCrZOAAAAAAAAAAAPNdUUU5nhDOv6mq7PdHdH8gvXL9NvjMco3lWua79Mec/wBKYCS5fqucZnlwhGCgAAAAAAAAAAAA927tVvhMx6PAC3b10x96M8tlm3qaK+3HhOzLEG0MqzqKrU7bx3TwaVq5F2jMf88AewAAAAAUPaFzNcU9288/r1VEmpnOoq54+WyMABQAAAAAAAAAAAAAAAAAAWNFc6F7HZVt59iu7RPRrie6YkGyAgAAAAyL341XxT6vAKAAAAAAAAAAAAAAAAAAAAAANoBAAB//2Q=='),
                        backgroundColor: AppColors.secondaryColor,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            hintText: "Name",
            controller: _usernameController,
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
            controller: _bioController,
            hintText: "Simple about me",
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
                signUpUser();
              },
              label: "Signup"),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
                child: const Text("Already part of us? Login")),
          )
        ]),
      ),
    );
  }
}