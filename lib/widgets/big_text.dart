
import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/dimensions.dart';

class BigTextWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final TextOverflow textOverflow;

 const BigTextWidget({
    Key? key,
    required this.text,
    this.color = const Color(0xFF332d2b),
    this.size = 0,
    this.textOverflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontSize:size == 0 ? Dimensions.font20 : size,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      overflow: textOverflow,
    );
  }
}
