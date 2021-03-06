// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';

class AppTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final Color iconColor;
  TextInputType textInputType;
  bool isObscure;
  bool maxLines;

  AppTextFieldWidget({
    Key? key,
    required this.controller,
    required this.iconData,
    required this.hintText,
    this.iconColor = AppColors.yellowColor,
    this.textInputType = TextInputType.text,
    this.isObscure = false,
    this.maxLines=false
  }) : super(key: key);

  @override
  State<AppTextFieldWidget> createState() => _AppTextFieldWidgetState();
}

class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.height20,
        left: Dimensions.width20,
        right: Dimensions.width20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(1, 1),
              color: Colors.grey.withOpacity(0.2),
            )
          ]),
      child: TextField(
        controller: widget.controller,
        obscureText: visible ? !widget.isObscure : widget.isObscure,
        keyboardType: widget.textInputType,
        maxLines:widget.maxLines?3:1 ,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.iconData,
            color: widget.iconColor,
          ),
          suffixIcon:widget.isObscure? GestureDetector(
            onTap: (){
              setState(() {
              visible = !visible;
            });
              },
            child: Icon(
              visible ?
              Icons.visibility_off_outlined:
              Icons.visibility_outlined,
              color: Colors.grey[700],
            ),
          ):null,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: const BorderSide(width: 1, color: Colors.white)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: const BorderSide(width: 1, color: Colors.white)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
        ),
      ),
    );
  }
}
