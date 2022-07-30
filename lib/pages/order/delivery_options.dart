import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/utils/styles.dart';
import 'package:get/get.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final double amount;
  final bool isFree;

  const DeliveryOptions({Key? key, required this.value,
  required this.title,
    required this.amount,
    required this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (controller) {
        return Row(
          children: [
            Radio(
              value: value,
              groupValue:controller.orderType ,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (String? value)=>controller.setDeliveryType(value!),
            ),
            SizedBox(width: Dimensions.width10/2),
            Text(title,style: robotoRegular),
            SizedBox(width: Dimensions.width10/2),
            Text(
              "(${(value== "take away"||isFree)?'free':"\$${amount/10}"})",
              style:robotoMedium
            ),
          ],
        );
      }
    );
  }
}
