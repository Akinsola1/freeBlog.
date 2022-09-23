import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_blog/resources/user.dart';
import 'package:free_blog/style/appFonts.dart';
import 'package:free_blog/widget/customForm.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/storageMethod.dart';
import '../style/appColors.dart';
import '../utils/utils.dart';

class EditProfileDialogue extends StatefulWidget {
  final userData;
  const EditProfileDialogue({super.key, this.userData});

  @override
  State<EditProfileDialogue> createState() => _EditProfileDialogueState();
}

class _EditProfileDialogueState extends State<EditProfileDialogue> {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  Uint8List? _image;
  bool loading = false;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  editProfile() async {
    setState(() {
      loading = true;
    });

    try {
      String res = await UserMethod().editProfile(
          _image, widget.userData, nameController.text, bioController.text);

      if (res == "success") {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      } else {
        showSnackBar(context, res);
         setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    nameController.text = widget.userData["username"];
    bioController.text = widget.userData["bio"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
                loading
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () {
                          editProfile();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Center(
                                child: Text(
                              "Save",
                              style: AppFonts.bodyBlack
                                  .copyWith(color: Colors.black),
                            )),
                          ),
                        ),
                      )
              ],
            ),
            Stack(
              children: [
                _image != null
                    ? Container(
                        height: size.height / 3.8,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                                DecorationImage(image: MemoryImage(_image!))),
                      )
                    : InkWell(
                        onTap: () {
                          selectImage;
                        },
                        child: Container(
                          height: size.height / 3.8,
                          width: size.width / 3,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      widget.userData["photoUrl"]))),
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: "Username",
              controller: nameController,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              labelText: "Bio",
              controller: bioController,
            ),
          ],
        ),
      ),
    );
  }
}
