import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    final CollectionReference firestore =
        FirebaseFirestore.instance.collection('users');

    try {
      print("edit profile");

      if (_image == null) {
        firestore.doc(widget.userData["uid"]).update(
            {"username": nameController.text, "bio": bioController.text});
        Navigator.pop(context);
      } else {
        String profImage = _image != null
            ? await StorageMethod().uploadImage('profilePics', _image!, false)
            : "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAHBhMSEBIPDxUQEQ8QFRIODg8QEBAVFREYFhURFRYYHSggGRolHRUTITEiKCkrLi4uFx8zODMsNygtLi0BCgoKDQ0NDw0NDisZFRkrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIAOEA4QMBIgACEQEDEQH/xAAaAAEAAwEBAQAAAAAAAAAAAAAAAwQFAQIH/8QANBABAAEDAgIHBQgDAQAAAAAAAAECAxEEITFxEhNBUWGBsQUicpHwIzIzNFKhwdFC4fEk/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAH/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwD6oAqAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIrmopt8Z37o3kErkzFPGYjnLOvauqvh7seHH5q87yDYiuJ4TE8ph6Yr3TdqpjaqY85BrjNt6yqnj73Nds36b0bce6eIJQAAAAAAAAAAAAAAAAAAAAVdfd6NGI/y9AR6rVZ2pnnP9KYKAAAADtNU0zmNsOANTTXuuo8Y4/2mZWmudVeiezhLVQAAAAAAAAAAAAAAAAAAGXq6+nfnw2+X1LTmejGe7djcQAFAAAAAABrWKulZpnwhktXS/l6eSCUAAAAAAAAAAAAAAAAAEd/azV8M+jJa1/8Cr4Z9GSAAoAAAfX18gAAGno5/wDNHn6yzGnovy0efqgnAAAAAAAAAAAAAAAAABS196aZ6MbZic+PgoQu+0qfepnmp43AyZMGFDJEmDAOTwJnETydwYAmcGcGDAC5obs9Po9mJ8lPCz7Pj7flEg0gEAAAAAAAAAAAAAAAAFbX09Kxnun/AEzmxVTFdMxPbszdTY6iY3zE5BCAoAAAAAAL3s6n3ZnyVdPZ665jhtlp2rcWqMQg9gAAAAAAAAAAAAAAAAAINXb6yxPhunAYon1djqq8xwnh4eCBQAAAABJp7PXXMdnbILmgt9G1n9XpC05EYh1AAAAAAAAAAAAAAAAAAAABBrYzpp8vVmNLXVY08x349WaAAoAAND2fH2M/F/EM9f8AZ9X2cx45/ZBbAAAAAAAAAAAAAAAAAABFc1FNvjPlG8glVNZqJtziNsxnKO5rpn7sY8Z3lVqqmuczMzzAmZqnffm4CgAAAAROABc0moqquRTO+c79vBeYsT0Z225LVvW1U8fe/aUGgILeqouduPCrZOAAAAAAAAAAAPNdUUU5nhDOv6mq7PdHdH8gvXL9NvjMco3lWua79Mec/wBKYCS5fqucZnlwhGCgAAAAAAAAAAAA927tVvhMx6PAC3b10x96M8tlm3qaK+3HhOzLEG0MqzqKrU7bx3TwaVq5F2jMf88AewAAAAAUPaFzNcU9288/r1VEmpnOoq54+WyMABQAAAAAAAAAAAAAAAAAAWNFc6F7HZVt59iu7RPRrie6YkGyAgAAAAyL341XxT6vAKAAAAAAAAAAAAAAAAAAAAAANoBAAB//2Q==";

        firestore.doc(widget.userData["uid"]).update({
          "username": nameController.text,
          "bio": bioController.text,
          "profImage": profImage
        });
      }
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
                              image: DecorationImage(
                                  image: MemoryImage(
                                      _image!))),
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
