import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/authMethod.dart';
import 'package:free_blog/screens/profileScreen.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:provider/provider.dart';

import '../models/userModel.dart';
import '../resources/provider.dart';
import 'createPostScreen.dart';
import 'loginscreen.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListView(
        children: [
          InkWell(
            onTap: () => print(user.photoUrl),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(user.photoUrl.toString()))),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              user.username,
              style: AppFonts.bodyBlack.copyWith(fontSize: 18),
            ),
          ),
          Center(
            child: Text(
              user.email,
              style: AppFonts.bodyBlack
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w200),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(uid: user.uid,),
                ),
              );
            },
            leading: Icon(Icons.person_outline_outlined),
            title: Text("Profile"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreatePostScreen(),
                ),
              );
            },
            leading: Icon(Icons.draw_outlined),
            title: Text("Create post"),
          ),
          ListTile(
            onTap: () {
              AuthMethod().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false);
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}
