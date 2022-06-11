import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/no_data_page.dart';
import 'package:food_delivery_app/base/show_custom_snackbar.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app/controllers/user_controller.dart';
import 'package:food_delivery_app/models/place_order_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_icon.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/order_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: Dimensions.width20,
            left: Dimensions.width20,
            top: Dimensions.height20 * 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width20 * 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: AppIcon(
                    icon: Icons.shopping_cart_outlined,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<CartController>(
            builder: (controller) {
              return controller.getItems.isNotEmpty
                  ? Positioned(
                      top: Dimensions.height20 * 5,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height15),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: GetBuilder<CartController>(
                            builder: (cartController) {
                              var _cartList = cartController.getItems;
                              return ListView.builder(
                                itemCount: _cartList.length,
                                itemBuilder: (_, index) {
                                  return SizedBox(
                                    height: Dimensions.height20 * 5,
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var popularIndex = Get.find<
                                                    PopularProductController>()
                                                .popularProductList
                                                .indexOf(
                                                    _cartList[index].product!);
                                            if (popularIndex >= 0) {
                                              Get.toNamed(
                                                  RouteHelper.getPopularFood(
                                                      popularIndex,
                                                      'cartPage'));
                                            } else {
                                              var recommendedIndex = Get.find<
                                                      RecommendedProductController>()
                                                  .recommendedProductList
                                                  .indexOf(_cartList[index]
                                                      .product!);
                                              if (recommendedIndex < 0) {
                                                Get.snackbar(
                                                  'History product',
                                                  "product review is not available for history products",
                                                  backgroundColor:
                                                      AppColors.mainColor,
                                                  colorText: Colors.white,
                                                );
                                              } else {
                                                Get.toNamed(RouteHelper
                                                    .getRecommendedFood(
                                                        recommendedIndex,
                                                        'cartPage'));
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: Dimensions.height20 * 5,
                                            width: Dimensions.height20 * 5,
                                            margin: EdgeInsets.only(
                                                bottom: Dimensions.height10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius20),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(AppConstants
                                                        .BASE_URL +
                                                    AppConstants.UPLOADS_URI +
                                                    cartController
                                                        .getItems[index].img!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: Dimensions.height20 * 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BigTextWidget(
                                                  text: cartController
                                                      .getItems[index].name!,
                                                  color: Colors.black54,
                                                ),
                                                SmallTextWidget(
                                                    text: cartController
                                                        .getItems[index].time!),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    BigTextWidget(
                                                      text:
                                                          '\$${cartController.getItems[index].price!}',
                                                      color: Colors.redAccent,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                        color: Colors.white,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions
                                                              .width10,
                                                          right: Dimensions
                                                              .width10,
                                                          top: Dimensions
                                                              .height10,
                                                          bottom: Dimensions
                                                              .height10),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartController.addItem(
                                                                  _cartList[
                                                                          index]
                                                                      .product!,
                                                                  -1);
                                                            },
                                                            child: const Icon(
                                                              Icons.remove,
                                                              color: AppColors
                                                                  .signColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Dimensions
                                                                    .width10 /
                                                                2,
                                                          ),
                                                          BigTextWidget(
                                                            text: cartController
                                                                .getItems[index]
                                                                .quantity!
                                                                .toString(),
                                                          ),
                                                          SizedBox(
                                                            width: Dimensions
                                                                    .width10 /
                                                                2,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartController.addItem(
                                                                  _cartList[
                                                                          index]
                                                                      .product!,
                                                                  1);
                                                            },
                                                            child: const Icon(
                                                              Icons.add,
                                                              color: AppColors
                                                                  .signColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : const NoDataPage(text: 'Your Cart Is Empty');
            },
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (controller) {
          return Container(
            padding: EdgeInsets.only(
              left: Dimensions.width20,
              right: Dimensions.width20,
              bottom: Dimensions.height30,
              top: Dimensions.height30,
            ),
            height: Dimensions.bottomHeightBar,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius20 * 2),
                topRight: Radius.circular(Dimensions.radius20 * 2),
              ),
              color: AppColors.buttonBackgroundColor,
            ),
            child: controller.getItems.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(
                            left: Dimensions.width10,
                            right: Dimensions.width10,
                            top: Dimensions.height20,
                            bottom: Dimensions.height20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Dimensions.width10 / 2,
                            ),
                            BigTextWidget(
                              text: "\$ ${controller.totalAmount.toString()}",
                            ),
                            SizedBox(
                              width: Dimensions.width10 / 2,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>().userLoggedIn()) {
                            if (Get.find<LocationController>()
                                .getUserAddressFromLocalStorage()
                                .isEmpty) {
                              Get.toNamed(RouteHelper.getAddressPage());
                            } else {
                              var location = Get.find<LocationController>()
                                  .getUserAddress();
                              var cart = Get.find<CartController>().getItems;
                              var user = Get.find<UserController>().userModel;
                              PlaceOrderBody placeOrder = PlaceOrderBody(
                                cart: cart,
                                orderAmount: 100.0,
                                distance: 10.0,
                                scheduleAt: '',
                                orderNote: "Not about the food",
                                address: location.address,
                                latitude: location.latitude,
                                longitude: location.longitude,
                                contactPersonName: user.name,
                                contactPersonNumber: user.phone,
                              );
                              Get.find<OrderController>()
                                  .placeOrder(_callback, placeOrder);
                            }
                            controller.addToHistory();
                          } else {
                            Get.toNamed(RouteHelper.getSignInPage());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
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
                          child: BigTextWidget(
                            text: 'Check out',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          );
        },
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) {
    if (isSuccess) {
      Get.find<CartController>().clear();
      Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
      Get.offNamed(RouteHelper.getPaymentPage('100014', '27'));
      // Get.offNamed(
      //   RouteHelper.getPaymentPage(
      //       orderID, Get.find<UserController>().userModel.id),
      // );
    } else {
      showCustomSnackBar(message);
    }
  }
}
