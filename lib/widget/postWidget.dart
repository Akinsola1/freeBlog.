import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/post.dart';
import 'package:free_blog/resources/provider.dart';
import 'package:free_blog/screens/profileScreen.dart';
import 'package:free_blog/style/appColors.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/widget/commentWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:free_blog/models/userModel.dart' as model;

class PostWidget extends StatefulWidget {
  final snap;
  const PostWidget({super.key, required this.snap});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int commentsLenght = 0;
  @override
  void initState() {
    getCommentLeght();
    super.initState();
  }

  getCommentLeght() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap["postId"])
        .collection("comments")
        .get();

    setState(() {
      commentsLenght = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: widget.snap["uid"])));
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              "${widget.snap["profImage"].toString()}",
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.snap["username"].toString()}",
                      style: AppFonts.bodyBlack
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: AppFonts.bodyBlack.copyWith(
                            fontSize: 10, fontWeight: FontWeight.w300))
                  ],
                ),
                Spacer(),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                                onTap: () {}),
                                          )
                                          .toList()),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColors.primaryColor,
                        ))
                    : Container()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.snap["postTitle"].toString()}",
              style: AppFonts.bodyBlack.copyWith(
                fontSize: 16,
              ),
            ),
            Text(
              "${widget.snap["postDescription"].toString()}",
              style: AppFonts.bodyBlack
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            Text(
              "${widget.snap["postContent"].toString()}",
              style: AppFonts.bodyBlack
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      PostMethod().likePost(
                          "${widget.snap["postId"].toString()}",
                          user.uid,
                          widget.snap["likes"]);
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.thumb_up_alt,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.thumb_up_outlined,
                            color: AppColors.primaryColor,
                          )),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: AppColors.primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return CommentWidget(
                          snap: widget.snap,
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.chat,
                    color: AppColors.primaryColor,
                  ),
                )
              ],
            ),
            Text(
              '${widget.snap['likes'].length} likes',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'read all $commentsLenght comments',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
