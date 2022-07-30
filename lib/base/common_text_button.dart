import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../widgets/big_text.dart';

class CommonTextButton extends StatelessWidget {
  final String text;
  const CommonTextButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow:const[
          BoxShadow(offset: Offset(0,5),blurRadius: 10,color: AppColors.mainColor)
        ],
        borderRadius:
        BorderRadius.circular(Dimensions.radius20),
        color: AppColors.mainColor,
      ),
      padding: EdgeInsets.only(
        left: Dimensions.width10,
        right: Dimensions.width10,
        top: Dimensions.height20,
        bottom: Dimensions.height20,
      ),

      child: Center(
        child: BigTextWidget(
          text: text,
          color: Colors.white,
        ),
      ),
    );
  }
}
