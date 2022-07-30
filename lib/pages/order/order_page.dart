import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_app_bar.dart';
import 'package:food_delivery_app/pages/order/view_order.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late TabController _tapController;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (isLoggedIn) {
      _tapController = TabController(length: 2, vsync: this);
      Get.find<OrderController>().getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My orders",

      ),
      body: Column(
        children: [
          SizedBox(
            width: Dimensions.screenWidth,
            child: TabBar(
              controller: _tapController,
              indicatorWeight: 3,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: AppColors.yellowColor,
              tabs: const [
                Tab(
                  text: 'current',
                ),
                Tab(
                  text: 'history',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tapController,
              children: const[
                ViewOrder(isCurrent: true),
                ViewOrder(isCurrent: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
