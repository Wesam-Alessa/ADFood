import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/base/show_custom_snackbar.dart';
import 'package:food_delivery_app/data/api/api_client.dart';
import 'package:food_delivery_app/models/signup_body_model.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  late UserCredential _userCredential;

  UserCredential get getUserCredential => _userCredential;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Response> registration(SignUpBody body) async {
    return await apiClient.postData(
        AppConstants.REGISTRATION_URI, body.tojson());
  }

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(
        AppConstants.LOGIN_URI, {'email': email, 'password': password});
  }

  Future<bool> createNewAccount(SignUpBody body) async {
    try {
      _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: body.email, password: body.password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomSnackBar('The password provided is too weak.',
            title: 'weak-password');
      } else if (e.code == 'email-already-in-use') {
        showCustomSnackBar(
          'The account already exists for that email.',
          title: 'email-already-in-use',
        );
      }
      return false;
    } catch (e) {
      showCustomSnackBar(
        'error when creating account catch',
      );
      return false;
    }
  }

  Future<bool> signInWithFirebase(SignUpBody body) async {
    try {
      _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: body.email,
        password: body.password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomSnackBar('No user found for that email.',
            title: 'user-not-found');
      } else if (e.code == 'wrong-password') {
        showCustomSnackBar('Wrong password provided for that user.',
            title: 'wrong-password');
      }
      return false;
    }
  }

  Future<void> addUserIntoFireStore(SignUpBody body)async{
    final user = FirebaseAuth.instance.currentUser!;
    await _firebaseFirestore.collection('users').doc(user.uid).set(UserModel(
      id: user.uid,
      name: body.name,
      email: body.email,
      phone: body.phone,
      orderCount: 0,
    ).toJson()).then((value) =>
        showCustomSnackBar('User Added',
            title: 'Successfully'))
        .catchError((error) =>
        showCustomSnackBar('Failed to add user',
            title: 'Failed to add user: $error'));
  }

  Future<String> getUserToken() async {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? 'None';
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<void> saveUserNumberAndPassword(String password, String number) async {
    try {
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
      await sharedPreferences.setString(AppConstants.PHONE, number);
    } catch (e) {
      throw e.toString();
    }
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PASSWORD);
    sharedPreferences.remove(AppConstants.PHONE);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
}
