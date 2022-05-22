import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_icon.dart';
import 'package:food_delivery_app/widgets/big_text.dart';

class AccountWidget extends StatelessWidget {
  final AppIcon appIcon;
  final BigTextWidget bigTextWidget;

  const AccountWidget({Key? key, required this.appIcon, required this.bigTextWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.width20,
        bottom: Dimensions.width10,
        top: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 1,
            color: Colors.grey.withOpacity(0.2),
          )
        ],
      ),
      child: Row(
        children: [
          appIcon,
          SizedBox(
            width: Dimensions.screenWidth-75,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:Dimensions.width15),
              child: bigTextWidget,
            ),
          ),
        ],
      ),
    );
  }
}
