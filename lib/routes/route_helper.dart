import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/pages/address/add_address_page.dart';
import 'package:food_delivery_app/pages/address/pick_address_map.dart';
import 'package:food_delivery_app/pages/auth/sign_in_page.dart';
import 'package:food_delivery_app/pages/auth/sign_up_page.dart';
import 'package:food_delivery_app/pages/cart/cart_page.dart';
import 'package:food_delivery_app/pages/food/popular_food_detail.dart';
import 'package:food_delivery_app/pages/food/recommended_food_detail.dart';
import 'package:food_delivery_app/pages/home/home_page.dart';
import 'package:food_delivery_app/pages/payment/payment_page.dart';
import 'package:food_delivery_app/pages/splash/splash_page.dart';
import 'package:get/get.dart';

import '../pages/payment/order_success_page.dart';

class RouteHelper {
  static const String splashPage = '/splash-page';
  static const String initial = '/';
  static const String popularFood = '/popular-food';
  static const String recommendedFood = '/recommended-food';
  static const String cartPage = '/cart-page';
  static const String signInPage = '/sign-in-page';
  static const String signUpPage = '/sign-up-page';
  static const String addAddressPage = '/address-page';
  static const String pickAddressMap = '/pick-address';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-successful';

  static String getInitial() => initial;

  static String getSplashPage() => splashPage;

  static String getPopularFood(int pageId, String page) =>
      "$popularFood?pageId=$pageId&page=$page";

  static String getRecommendedFood(int pageId, String page) =>
      "$recommendedFood?pageId=$pageId&page=$page";

  static String getCartPage() => cartPage;

  static String getSignInPage() => signInPage;

  static String getSignUpPage() => signUpPage;

  static String getAddressPage() => addAddressPage;

  static String getPickMapAddressPage() => pickAddressMap;

  static String getPaymentPage(String id,String userID) => "$payment?id=$id&userID=$userID";

  static String getOrderSuccessPage(String orderID,String status) => "$orderSuccess?id=$orderID&status=$status";

  static List<GetPage> routes = [
    GetPage(
        name: initial,
        page: () => const HomePage(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: splashPage,
        page: () => const SplashScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: popularFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return PopularFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: recommendedFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return RecommendedFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: cartPage,
        page: () {
          return const CartPage();
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: signInPage,
        page: () => const SignInPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: signUpPage,
        page: () => const SignUpPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: addAddressPage,
        page: () => const AddAddressPage(),
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
        name: pickAddressMap,
        page: () {
          PickAddressMap _pickMap = Get.arguments;
          return _pickMap;
        },
        transitionDuration: const Duration(milliseconds: 300),
        transition: Transition.rightToLeft),
    GetPage(
      name: payment,
      page: ()=>PaymentPage(
          orderModel: OrderModel(
            userId:  Get.parameters['userID']!,
            id:  int.parse(Get.parameters['id']!),
          )
      ),
    ),
    GetPage(
      name: orderSuccess,
      page: ()=>OrderSuccessPage(
            orderID:  Get.parameters['id']!,
            status: Get.parameters['status']!.toString().contains('success')?1:0,
      ),
    ),
  ];
}
