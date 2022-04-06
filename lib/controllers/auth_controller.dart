import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/data/repository/auth_repo.dart';
import 'package:food_delivery_app/data/repository/user_repo.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:food_delivery_app/models/signup_body_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;
  AuthController({required this.authRepo,required this.userRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  Future<ResponseModel> signInWithFirebase(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    bool respond = await authRepo.signInWithFirebase(signUpBody);
    late ResponseModel responseModel;
    if (respond) {
      await userRepo.getUserInfoFromFirebase();
      final tokenResult = FirebaseAuth.instance.currentUser!;
      final idToken = await tokenResult.getIdToken();
      final token = idToken;
      authRepo.saveUserToken(token);
      responseModel = ResponseModel(true, token);
    } else {
      responseModel = ResponseModel(false, "Error when signIn account");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registrationWithFirebase(SignUpBody signUpBody) async {
     late ResponseModel responseModel;
    _isLoading = true;
    update();
    bool respond = await authRepo.createNewAccount(signUpBody);
    if (respond) {
      await authRepo.addUserIntoFireStore(signUpBody);
      final tokenResult = FirebaseAuth.instance.currentUser!;
      final idToken = await tokenResult.getIdToken();
      final token = idToken;
      authRepo.saveUserToken(token);
      responseModel = ResponseModel(
          true, token);
    } else {
      responseModel = ResponseModel(false, "Error when registration account");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String password, String number) async {
    authRepo.saveUserNumberAndPassword(password, number);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      responseModel = ResponseModel(true, response.body['token']);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      responseModel = ResponseModel(true, response.body['token']);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
