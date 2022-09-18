import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/models/userModel.dart';
import 'package:free_blog/resources/provider.dart';
import 'package:free_blog/screens/drawer.dart';
import 'package:free_blog/screens/loginscreen.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/utils/screenDetector.dart';
import 'package:free_blog/widget/postWidget.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchUserInfo();
    });
    super.initState();
  }

  fetchUserInfo() async {
    UserProvider user = await Provider.of<UserProvider>(context, listen: false);
    user.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        child: DrawerItem(),
      ),
      body: Center(
        child: SizedBox(
          width: screenDetector.isMobile(context) ? size.width : size.width / 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                UserProvider user =
                    await Provider.of<UserProvider>(context, listen: false);
                user.refreshUser();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "freeBlog.",
                        style: AppFonts.header,
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: AppColors.primaryColor,
                          ))
                    ],
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) => PostWidget(
                                snap: snapshot.data!.docs[index].data(),
                              ),
                            ),
                          );
                        } else
                          return Text("Error loading content");
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
