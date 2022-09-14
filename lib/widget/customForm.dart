// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_blog/style/appColors.dart';

import '../style/appFonts.dart';

class CustomTextField extends StatefulWidget {
  final bool? hasLeading;
  final bool isAmount;
  final bool? isDate;
  final bool? isPassword;
  final bool? readOnly;
  final bool? changePhoneNumber;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final String? hintText;
  final String? labelText;
  final String? trailling;
  final bool? hasBorder;
  final bool? obscureText;
  final IconData? suffixData;
  final Function? onTap;
  final String? imgUri;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;

  ///labelText cannot be used when hintText is used
  CustomTextField({
    Key? key,
    this.hasLeading = false,
    this.isDate = false,
    this.isPassword = false,
    this.isAmount = false,
    this.readOnly = false,
    this.changePhoneNumber = false,
    this.maxLines,
    this.validator,
    this.prefix,
    this.hintText,
    this.labelText,
    this.trailling = '',
    this.hasBorder,
    this.obscureText = false,
    this.suffixData,
    this.onTap,
    this.imgUri,
    this.controller,
    this.textInputAction = TextInputAction.done,
    this.textInputType,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hide = false;
  @override
  void initState() {
    super.initState();
    hide = widget.obscureText!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(widget.labelText!, style: AppFonts.bodyBlack),
                )
              : SizedBox(),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextFormField(
                      // inputFormatters: [
                      //   widget.isAmount ?
                      //   ThousandsFormatter():FilteringTextInputFormatter.deny('')
                      // ],
                      autovalidateMode: widget.autovalidateMode,
                      keyboardType: widget.textInputType,
                      textInputAction: widget.textInputAction,
                      readOnly: widget.readOnly!,
                      controller: widget.controller,
                      // onTap: widget.onTap,
                      obscureText: hide,
                      obscuringCharacter: '•',
                      maxLines: widget.maxLines ?? 1,
                      validator: widget.validator,
                      decoration: InputDecoration(
                        // labelText: widget.labelText,

                        prefixIcon: widget.prefix,
                        isDense: false,
                        fillColor: Color.fromRGBO(38, 38, 38, 1),
                        suffixIcon: widget.obscureText!
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = !hide;
                                  });
                                },
                                icon: !hide
                                    ? Icon(
                                        Icons.visibility_outlined,
                                        color: AppColors.primaryColor,
                                      )
                                    : Icon(
                                        Icons.visibility_off_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                              )
                            : widget.suffixData != null
                                ? Icon(
                                    widget.suffixData,
                                  )
                                : null,
                        filled: true,
                        //labelText: widget.labelTex
                        hintText: widget.hintText,
                        hintStyle: AppFonts.hintText,
                        labelStyle: AppFonts.bodyBlack,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.trailling!,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 11,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
