import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:intl/intl.dart';

import '../screens/profileScreen.dart';

class IndividualCommentWidget extends StatelessWidget {
  final snap;
  const IndividualCommentWidget({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(uid: snap["uid"])));
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(snap["profImage"]), fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${snap["username"]}•",
                  style: AppFonts.bodyBlack
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                    style: AppFonts.bodyBlack
                        .copyWith(fontSize: 10, fontWeight: FontWeight.w300))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: size.width / 1.5,
              child: Text(
                snap['text'],
                style: AppFonts.bodyBlack
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
