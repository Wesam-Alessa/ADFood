import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/order_controller.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class ViewOrder extends StatelessWidget {
  final bool isCurrent;

  const ViewOrder({Key? key, required this.isCurrent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(
        builder: (orderController) {
          if (orderController.isLoading == false) {
            late List<OrderModel> orderList;
            if (orderController.currentOrderList.isNotEmpty) {
              orderList = isCurrent
                  ? orderController.currentOrderList.reversed.toList()
                  : orderController.historyOrderList.reversed.toList();
            }
            return SizedBox(
              width: Dimensions.screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10 / 2,
                    vertical: Dimensions.height10 / 2
                ),
                child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "#order ID      "+orderList[index].id.toString()
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                                        color: AppColors.mainColor
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(Dimensions.height10/2),
                                        child: Text(
                                            orderList[index].orderStatus.toString(),
                                          style: const TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10/2),
                                    InkWell(
                                      onTap: (){},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                                            color: Colors.white,
                                          border: Border.all(width: 1,color: Theme.of(context).primaryColor)
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(Dimensions.height10/2),
                                          child:const Text(
                                              "Track order"
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height10)
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Text("loading");
          }
        },
      ),
    );
  }
}
