import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/post.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/utils/screenDetector.dart';
import 'package:free_blog/widget/editProfileDialogue.dart';
import 'package:free_blog/widget/postWidget.dart';
import 'package:shake/shake.dart';

import '../style/appFonts.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool loading = false;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
    print("shake shake shake");
  });

  @override
  void initState() {
    getData();
    detector.startListening();

    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Center(
            child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ))
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await getData();
              },
              child: Center(
                child: SizedBox(
                  width: screenDetector.isMobile(context)
                      ? size.width
                      : size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.primaryColor,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: size.height / 4.8,
                          width: size.width / 4,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(userData["photoUrl"]),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            userData["username"],
                            style: AppFonts.bodyBlack.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            userData["email"],
                            style: AppFonts.bodyBlack.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            userData["bio"],
                            style: AppFonts.bodyBlack.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$followers followers",
                              style: AppFonts.bodyBlack.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w200),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "$following following",
                              style: AppFonts.bodyBlack.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w200),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditProfileDialogue(
                                      userData: userData,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        "Edit Profile",
                                        style: AppFonts.bodyBlack.copyWith(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: isFollowing
                                    ? () async {
                                        await PostMethod().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      }
                                    : () async {
                                        await PostMethod().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        isFollowing ? "Unfollow" : "Follow",
                                        style: AppFonts.bodyBlack.copyWith(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        // Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Posts",
                          style: AppFonts.header,
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (ctx, index) => PostWidget(
                                    snap: snapshot.data!.docs[index].data(),
                                  ),
                                );
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Tell the world something",
                                    style: AppFonts.bodyBlack,
                                  ),
                                );
                              } else
                                return Text("Error loading content");
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
