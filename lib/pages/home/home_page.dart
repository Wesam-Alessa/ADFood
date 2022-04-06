import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/account/account_page.dart';
import 'package:food_delivery_app/pages/auth/sign_up_page.dart';
import 'package:food_delivery_app/pages/cart/cart_history.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';
 import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import 'main_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PersistentTabController _controller;
  List<Widget> _buildScreens() {
    return const[
       MainFoodPage(),
       SignUpPage(),
       CartHistory(),
       AccountPage(),
    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary:Colors.amberAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.archivebox),
        title: ("Archive"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.amberAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.shopping_cart),
        title: ("Cart"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.amberAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Me"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.amberAccent,
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    var _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    print("LOGGED IN "+ _userLoggedIn.toString());
    if (_userLoggedIn) {
      // Get.find<UserController>().getUserInfo();
      Get.find<UserController>().getUserInfoFromFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
