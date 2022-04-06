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

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    List<String> signUpImages = [
      'assets/images/t.png',
      'assets/images/g.png',
      'assets/images/f.jpg',
    ];
    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String password = passwordController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      if (name.isEmpty) {
        showCustomSnackBar('Type in your name', title: 'Name');
      } else if (phone.isEmpty) {
        showCustomSnackBar('Type in your phone number', title: 'Phone Number');
      } else if (email.isEmpty) {
        showCustomSnackBar('Type in your email address', title: 'Email Address');
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('Type in your valid email address',
            title: 'Valid Email Address');
      } else if (password.isEmpty) {
        showCustomSnackBar('Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar('password can not be less than six characters',
            title: 'Password');
      } else {
        //showCustomSnackBar('All went well', title: 'Perfect');
        SignUpBody signUpBody = SignUpBody(
          name: name,
          password: password,
          email: email,
          phone: phone,
        );
        //authController.registration
         authController.registrationWithFirebase(signUpBody).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
           }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return !authController.isLoading
              ? Column(
                  children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 0.1,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Dimensions.radius20 * 4,
                        backgroundImage:
                            const AssetImage('assets/images/logo6.jpg'),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AppTextFieldWidget(
                              controller: nameController,
                              iconData: Icons.person,
                              hintText: 'Name',
                             // color: AppColors.yellowColor,
                            ),
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
                              //color: AppColors.yellowColor,
                              isObscure: true,
                            ),
                            AppTextFieldWidget(
                              controller: phoneController,
                              iconData: Icons.phone,
                              hintText: 'Phone',
                              //color: AppColors.yellowColor,
                              textInputType: TextInputType.phone,
                            ),
                            SizedBox(height: Dimensions.height30),
                            GestureDetector(
                              onTap: () {
                                _registration(authController);
                              },
                              child: Container(
                                height: Dimensions.screenHeight / 14,
                                width: Dimensions.screenWidth / 2,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                ),
                                child: Center(
                                    child: BigTextWidget(
                                  text: 'SignUp',
                                  color: Colors.white,
                                  size: Dimensions.font26,
                                )),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            RichText(
                              text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(RouteHelper.getSignInPage());
                                    },
                                  text: 'Have an account already?',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: Dimensions.font16)),
                            ),
                            SizedBox(height: Dimensions.screenHeight * 0.02),
                            RichText(
                              text: TextSpan(
                                  text:
                                      'Sign up using one of the following methods',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: Dimensions.font16)),
                            ),
                            SizedBox(height: Dimensions.screenHeight * 0.02),
                            Wrap(
                              children: List.generate(
                                3,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: Dimensions.radius30,
                                    backgroundImage:
                                        AssetImage(signUpImages[index]),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const CustomLoader();
        },
      ),
    );
  }
}
