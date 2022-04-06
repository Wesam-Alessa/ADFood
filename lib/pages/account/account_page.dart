import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_loader.dart';
import 'package:food_delivery_app/base/show_custom_snackbar.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/user_controller.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/account_widget.dart';
import 'package:food_delivery_app/widgets/app_icon.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    var address =Get.find<LocationController>().getUserAddress().address;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        title: BigTextWidget(
          text: 'Profile',
          color: Colors.white,
          size: Dimensions.font26,
        ),
      ),
      body: GetBuilder<UserController>(
        builder: (userController) {
          return _userLoggedIn
              ? (!userController.isLoading
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: Dimensions.height20),
                      child: Column(
                        children: [
                          AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height45 + Dimensions.height30,
                            size: Dimensions.height15 * 10,
                          ),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.person,
                                      backgroundColor: AppColors.mainColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigTextWidget: BigTextWidget(
                                      text: userController.userModel.name,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.phone,
                                      backgroundColor: AppColors.yellowColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigTextWidget: BigTextWidget(
                                      text:
                                          userController.userModel.phone.isEmpty
                                              ? "123456"
                                              : userController.userModel.phone,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.email_outlined,
                                      backgroundColor: AppColors.signColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigTextWidget: BigTextWidget(
                                      text:
                                          userController.userModel.email.isEmpty
                                              ? 'example@gmail.com'
                                              : userController.userModel.email,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Get.toNamed(RouteHelper.getAddressPage());
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.location_on,
                                        backgroundColor: Colors.lightBlueAccent,
                                        iconColor: Colors.red,
                                        iconSize: Dimensions.height10 * 5 / 2,
                                        size: Dimensions.height10 * 5,
                                      ),
                                      bigTextWidget: BigTextWidget(
                                        text: address.isEmpty ?
                                        'Fill your address'
                                        : address ,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.find<AuthController>()
                                          .userLoggedIn()) {
                                        Get.find<AuthController>()
                                            .clearSharedData();
                                        Get.find<CartController>().clear();
                                        Get.find<CartController>()
                                            .clearCartHistory();
                                        Get.find<LocationController>()
                                            .clearAddressList();
                                        FirebaseAuth.instance.signOut();
                                        Get.offNamed(
                                            RouteHelper.getSignInPage());
                                      } else {
                                        showCustomSnackBar(
                                            'Your already logged out',
                                            title: 'Logout');
                                      }
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.logout,
                                        backgroundColor: Colors.redAccent,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 5 / 2,
                                        size: Dimensions.height10 * 5,
                                      ),
                                      bigTextWidget: BigTextWidget(
                                        text: 'Log out',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const CustomLoader())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: Dimensions.height20 * 8,
                        margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            image:const DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets/images/signintocontinue.jpg'))),
                      ),
                      SizedBox(height: Dimensions.height20,),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteHelper.getSignInPage());
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: Dimensions.height20 * 4,
                          margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                              borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                              ),
                          child: Center(child: BigTextWidget(text: 'Sign In',color: Colors.white,size: Dimensions.font26,)),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
