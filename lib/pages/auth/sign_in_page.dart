import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_loader.dart';
import 'package:food_delivery_app/base/show_custom_snackbar.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:food_delivery_app/models/signup_body_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_text_field_widget.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {


  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void _login(AuthController authController) {
      String password = passwordController.text.trim();
      String email = emailController.text.trim();
      if (email.isEmpty) {
        showCustomSnackBar('Type in your email address', title: 'Email Address');
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('Type in your vaild email address',
            title: 'Valid Email Address');
      } else if (password.isEmpty) {
        showCustomSnackBar('Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar('password can not be less than six characters',
            title: 'Password');
      } else {
        //showCustomSnackBar('All went well', title: 'Perfect');
        SignUpBody signUpBody = SignUpBody(
          name: '',
          password: password,
          email: email,
          phone: '',
        );
        //authController.login(email,password)
           authController.signInWithFirebase(signUpBody).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        },
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return !authController.isLoading ? Column(
            children: [
              SizedBox(
                height: Dimensions.screenHeight * 0.1,
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius20 * 4,
                  backgroundImage: const AssetImage('assets/images/logo6.jpg'),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: Dimensions.width20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                          fontSize: Dimensions.font20 * 3,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      'Sign into your account',
                      style: TextStyle(
                          fontSize: Dimensions.font20, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppTextFieldWidget(
                        controller: emailController,
                        iconData: Icons.email_outlined,
                        hintText: 'Email',
                       // color: AppColors.yellowColor,
                        textInputType: TextInputType.emailAddress,
                      ),
                      AppTextFieldWidget(
                        controller: passwordController,
                        iconData: Icons.password_sharp,
                        hintText: 'Password',
                       // color: AppColors.yellowColor,
                        isObscure: true,
                      ),
                      SizedBox(height: Dimensions.height30),
                      GestureDetector(
                        onTap: () {_login(authController);},
                        child: Container(
                          height: Dimensions.screenHeight / 14,
                          width: Dimensions.screenWidth / 2,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                          ),
                          child: Center(
                            child: BigTextWidget(
                              text: 'Sign in',
                              color: Colors.white,
                              size: Dimensions.font26,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                      RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.font16),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(RouteHelper.getSignUpPage());
                                  },
                                text: ' Create',
                                style: TextStyle(
                                    color: AppColors.mainBlackColor,
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ): const CustomLoader();
        }
      ),
    );
  }
}
