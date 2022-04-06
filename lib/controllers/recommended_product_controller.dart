import 'package:food_delivery_app/data/repository/recommended_product_repo.dart';
import 'package:food_delivery_app/models/products_model.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;

  RecommendedProductController({required this.recommendedProductRepo});

  List<dynamic> _recommendedProductList = [];

  List<dynamic> get recommendedProductList => _recommendedProductList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getRecommendedProductList() async {
    Response response = await recommendedProductRepo.getRecommendedProductList();
    print('status code '+ response.statusCode.toString());
    //stats code 200 = successfully api client
    if (response.statusCode == 200) {
      print('get recommended products');
      _recommendedProductList = [];
      _recommendedProductList.addAll(Product.fromJson(response.body).products);
      _isLoaded =true;
      update();
    } else {
      print('could not get recommended products');
    }
  }
}
