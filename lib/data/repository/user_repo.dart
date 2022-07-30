// ignore_for_file: await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/data/api/api_client.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:get/get.dart';

class UserRepo{

  ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo()async{
    return await apiClient.getData(AppConstants.USER_INFO_URI, );
  }

  Future<UserModel> getUserInfoFromFirebase()async{
   User user = await FirebaseAuth.instance.currentUser!;
   late UserModel userModel;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
    });
    return userModel;
  }
}