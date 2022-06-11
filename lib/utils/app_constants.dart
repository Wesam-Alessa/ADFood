// ignore_for_file: constant_identifier_names

class AppConstants {
  //mvs.bslmeiyu.com
  static const String APP_NAME = 'ADFood';
  static const int APP_VERSION = 1;
  static const String BASE_URL = 'http://mvs.bslmeiyu.com';
  static const String POPULAR_PRODUCT_URI = '/api/v1/products/popular';
  static const String RECOMMENDED_PRODUCT_URI = '/api/v1/products/recommended';
  static const String UPLOADS_URI = '/uploads/';

  static const String CART_LIST = 'Cart-List';
  static const String CART_HISTORY_LIST = 'Cart-History-List';
  static const String REGISTRATION_URI = '/api/v1/auth/register';

  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String TOKEN = '';
  static const String PASSWORD = '';
  static const String PHONE = '';

  static const String USER_INFO_URI = '/api/v1/customer/info';
  static const String USER_ADDRESS = 'user_address';
  static const String ADD_USER_ADDRESS = 'add_user_address';
  static const String ADDRESS_LIST_URI = 'address_list_url';

  // config
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String SEARCH_LOCATION_URI = '/api/v1/config/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';

  // order
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';


}
