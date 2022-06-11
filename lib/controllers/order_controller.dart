import 'package:food_delivery_app/data/repository/order_repo.dart';
import 'package:food_delivery_app/models/place_order_model.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';

class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;

  OrderController({required this.orderRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late List<OrderModel> _currentOrderList;
  late List<OrderModel> _historyOrderList;

  List<OrderModel> get currentOrderList => _currentOrderList;

  List<OrderModel> get historyOrderList => _historyOrderList;

  Future<void> placeOrder(Function callback, PlaceOrderBody placeOrder) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.placeOrder(placeOrder);
    if (response.statusCode == 200) {
      _isLoading = false;
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
    } else {
      callback(true, response.statusText!, '-1');
    }
  }

  Future<void> getOrderList() async {
    _isLoading = true;
    Response response = await orderRepo.getOrderList();
    if (response.statusCode == 200) {
      _historyOrderList = [];
      _currentOrderList = [];
      response.body.forEach(
        (order) {
          OrderModel orderModel = OrderModel.fromJson(order);
          if (orderModel.orderStatus == 'pending' ||
              orderModel.orderStatus == 'accepted' ||
              orderModel.orderStatus == 'processing' ||
              orderModel.orderStatus == 'handover' ||
              orderModel.orderStatus == 'picked_up' ) {
                _currentOrderList.add(orderModel);
          }else{
            _historyOrderList.add(orderModel);
          }
        },
      );
    } else {
      _historyOrderList = [];
      _currentOrderList = [];
    }
    print("_history Order List "+_historyOrderList.length.toString());
    print("_current Order List "+_currentOrderList.length.toString());

    _isLoading = false;
    update();
  }
}
