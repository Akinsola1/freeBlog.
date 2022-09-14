import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/post.dart';
import 'package:free_blog/screens/homeScreen.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/utils/utils.dart';
import 'package:free_blog/widget/customButton.dart';
import 'package:provider/provider.dart';

import '../models/userModel.dart';
import '../resources/provider.dart';
import '../style/appFonts.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var contentController = TextEditingController();
  bool loading = false;

  void postContent(String uid, String username, String profImage) async {
    setState(() {
      loading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await PostMethod().uploadPost(
          titleController.text,
          descriptionController.text,
          contentController.text,
          uid,
          username,
          profImage);
      if (res == "success") {
        setState(() {
          loading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
        showSnackBar(
          context,
          'Content posted 🚀',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        loading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: [
            TextFormField(
              controller: titleController,
              style: AppFonts.header.copyWith(color: AppColors.primaryColor),
              cursorColor: Colors.white,
              decoration: InputDecoration.collapsed(
                  hintText: 'Title',
                  hintStyle: AppFonts.header
                      .copyWith(color: Colors.white.withOpacity(0.5))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 2,
              maxLength: 100,
              style: AppFonts.header.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              cursorColor: Colors.white,
              decoration: InputDecoration.collapsed(
                  hintText: 'Short Description',
                  hintStyle: AppFonts.header.copyWith(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: contentController,
              maxLines: 20,
              style: AppFonts.header.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              cursorColor: Colors.white,
              decoration: InputDecoration.collapsed(
                  hintText: "What's happening",
                  hintStyle: AppFonts.header.copyWith(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            ),
            CustomButton(
                loading: loading,
                onTap: () {
                  postContent(user.uid, user.username, user.photoUrl);
                },
                label: "Post"),
            const SizedBox(
              height: 20,
            ),
            CustomButton(onTap: () {}, label: "Post Anonymously"),
          ],
        ),
      ),
    );
  }
}
