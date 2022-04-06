import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/data/repository/user_repo.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late UserModel _userModel;

  UserModel get userModel => _userModel;


  Future<void> getUserInfoFromFirebase()async{
    _isLoading = true;
    //update();
    _userModel = await userRepo.getUserInfoFromFirebase();
    if(_userModel.id.isNotEmpty){
      _isLoading = false;
      update();
    }
  }


  Future<ResponseModel> getUserInfo() async {

    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
//      responseModel = ResponseModel(true, response.body['token']);
      _userModel = UserModel.fromJson(response.body);
      _isLoading = true;
      //update();
      responseModel = ResponseModel(true, 'successfully');
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }



}