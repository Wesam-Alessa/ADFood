// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/api/api_checker.dart';
import 'package:food_delivery_app/data/repository/location_repo.dart';
import 'package:food_delivery_app/models/address_model.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: implementation_imports
import 'package:google_maps_webservice/src/places.dart';
import '../base/show_custom_snackbar.dart';

class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;

  LocationController({required this.locationRepo});

  bool _loading = false;

  bool get loading => _loading;

  late Position _position;

  Position get position => _position;

  late Position _pickPosition;

  Position get pickPosition => _pickPosition;

  Placemark _placamark = Placemark();

  Placemark get placeMark => _placamark;

  Placemark _pickPlacamark = Placemark();

  Placemark get pickPlaceMark => _pickPlacamark;

  List<AddressModel> _addressList = [];

  late List<AddressModel> _allAddressList;

  List<AddressModel> get allAddressList => _allAddressList;

  final List<String> _addressTypeList = ['home', 'office', 'other'];

  List<String> get addressTypeList => _addressTypeList;

  int _addressTypeIndex = 0;

  int get addressTypeIndex => _addressTypeIndex;

  List<AddressModel> get addressList => _addressList;

  late GoogleMapController _mapController;

  GoogleMapController get mapController => _mapController;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  bool _updateAddressData = true;
  bool _changeAddress = true;

  /*
  for service zone
  */
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /*
  whether the user is in service zone or not
  */
  bool _inZone = false;

  bool get inZone => _inZone;

  /*
  showing and hiding the button as the map loads
  */
  bool _buttonDisabled = true;

  bool get buttonDisabled => _buttonDisabled;

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();

      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }
        ResponseModel _responseModel = await getZone(
            position.target.latitude.toString(),
            position.target.longitude.toString(),
            false);

        _buttonDisabled = !_responseModel.isSuccess;

        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
            LatLng(position.target.latitude, position.target.longitude),
          );
          if (fromAddress) {
            _placamark = Placemark(name: _address);
          } else {
            _pickPlacamark = Placemark(name: _address);
          }
        }else {
          _changeAddress = true;
        }
      } catch (e) {
        showCustomSnackBar(e.toString());
      }
      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _placamark = _pickPlacamark;
    _updateAddressData = false;
    update();
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "UnKnown Location Found";
    _address = await locationRepo.getAddressFromLatLang(latLng);
    // Response response = await locationRepo.getAddressFromGeocode(latLng);
    // if (response.body['status'] == 'OK') {
    //   print('RESPONSE ---------------------------------'+response.body);
    //   _address = response.body['results'][0]['formatted_address'].toString();
    // } else {
    //   print('ERROR THE GETTING GOOGLE API');
    // }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;

  Map get getAddress => _getAddress;

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAllAddress();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      saveUserAddress(addressModel);
    } else {
      print("couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> addAddressOnFirebase(AddressModel addressModel) async {
    _loading = true;
    update();
    bool response = await locationRepo.addAddressOnFirebase(addressModel);
    late ResponseModel responseModel;
    if (response) {
      await getAllAddressFromFirebase();
      String message = 'successfully';
      responseModel = ResponseModel(true, message);
      saveUserAddress(addressModel);
    } else {
      print("couldn't save the address");
      responseModel = ResponseModel(false, "field :couldn't save the address");
    }
    _loading = false;
    update();
    return responseModel;
  }

  Future<void> getAllAddress() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<void> getAllAddressFromFirebase() async {
    List<AddressModel> response =
        await locationRepo.getAllAddressFromFirebase();
    if (response.isNotEmpty) {
      _addressList = [];
      _allAddressList = [];
      _addressList = response;
      _allAddressList = response;
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    if (markerLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();
    Response response = await locationRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      //if(response.body["zone_id"] != 2){
      // _responseModel = ResponseModel(false, response.body['zone_id'].toString());
      // _inZone = false;
      //}else{
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
      _inZone = true;
      //}
    } else {
      _inZone = false;
      _responseModel = ResponseModel(true, response.statusText!);
    }
    // print(
    //     "///////////////////////////////////////////////////////////ZOE RESPONSE CODE IS " +
    //         response.statusCode.toString()); // 200  //404  //500  //403
    // await Future.delayed(const Duration(seconds: 2), () {
    //   _responseModel = ResponseModel(true, "success");
    if (markerLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    //   _inZone = true;
    // });
    update();
    return _responseModel;
  }

  /*
   save the google map suggestions for address
  */
  List<Prediction> _predictionList = [];

  List<Prediction> get predictionList => _predictionList;

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == "OK") {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  setLocation(
      String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.setLocation(placeID);
    detail = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lat,
      latitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
    );
    _pickPlacamark = Placemark(name: address);
    _changeAddress = false;
    if (!mapController.isNull) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 17)));
    }
    _loading = false;
    update();
  }
}
