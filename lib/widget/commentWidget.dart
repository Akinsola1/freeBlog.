import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/authMethod.dart';
import 'package:free_blog/resources/post.dart';
import 'package:free_blog/resources/provider.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/widget/individualCommentWidget.dart';
import 'package:provider/provider.dart';
import 'package:free_blog/models/userModel.dart' as model;

import '../utils/utils.dart';

class CommentWidget extends StatefulWidget {
  final snap;
  const CommentWidget({super.key, required this.snap});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  var commentController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Comments",
                style: AppFonts.bodyBlack,
              ),
            ),
             Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(user.photoUrl),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    maxLines: 2,
                    style: AppFonts.bodyBlack.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    cursorColor: Colors.white,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Add comment',
                        hintStyle: AppFonts.header.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });
                    String res = await PostMethod().postComment(
                        widget.snap["postId"].toString(),
                        commentController.text,
                        user.uid,
                        user.username,
                        user.photoUrl);
                    if (res == 'success') {
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      setState(() {
                        _loading = false;
                      });
                      showSnackBar(context, res);
                    }
                  },
                  child: _loading
                      ? Text(
                          "Posting..",
                          style:
                              AppFonts.bodyBlack.copyWith(color: Colors.blue),
                        )
                      : Text(
                          "Post",
                          style:
                              AppFonts.bodyBlack.copyWith(color: Colors.blue),
                        ),
                ),
              ],
            ),

            Divider(),
            // ListView.builder(itemBuilder: itemBuilder)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.snap["postId"])
                    .collection("comments")
                    .orderBy("datePublished", descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: IndividualCommentWidget(
                              snap: snapshot.data!.docs.elementAt(index).data(),
                            ),
                          );
                        });
                  }
                  // if (snapshot.data!.docs.isEmpty) {
                  //   Center(
                  //     child: Text(
                  //       "Be the first to comment 🫵 ",
                  //       style: AppFonts.bodyBlack,
                  //     ),
                  //   );
                  // }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else
                    return Text("Error loading comment");
                }),
          ],
        ),
      ),
    );
  }
}
