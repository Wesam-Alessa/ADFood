import 'dart:convert';

import 'package:food_delivery_app/data/repository/location_repo.dart';
import 'package:food_delivery_app/models/address_model.dart';
import 'package:food_delivery_app/models/response_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../base/show_custom_snackbar.dart';

class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;

  LocationController({required this.locationRepo});

  bool _loading = false;

  bool get loading => _loading;

  Position get position => _position;
  late Position _position;

  late Position _pickPosition;

  Position get pickPosition => _pickPosition;

  Placemark _placamark = Placemark();

  Placemark get placeMark => _placamark;

  Placemark _pickPlacamark = Placemark();

  Placemark get pickPlaceMark => _pickPlacamark;

  List<AddressModel> _addressList = [];

  late List<AddressModel> _allAddressList;

  List<AddressModel> get allAddressList => _allAddressList;

  List<String> _addressTypeList = ['home', 'office', 'other'];

  List<String> get addressTypeList => _addressTypeList;

  int _addressTypeIndex = 0;

  int get addressTypeIndex => _addressTypeIndex;

  List<AddressModel> get addressList => _addressList;

  late GoogleMapController _mapController;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  bool _updateAddressData = true;
  bool _changeAddress = true;

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
    }
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
      if (_changeAddress) {
        String _address = await getAddressFromGeocode(
            LatLng(position.target.latitude, position.target.longitude));
        fromAddress
            ? _placamark = Placemark(name: _address)
            : _pickPlacamark = Placemark(name: _address);
      }
      update();
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "UnKnown Location Found";
    _address = await locationRepo.getAddressFromLatLong(_position);
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

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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
    } else {
      print("couldn't save the address");
      responseModel = ResponseModel(false, "field :couldn't save the address");
    }
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

  saveUserAddress(AddressModel addressModel)async{
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList(){
    _addressList = [];
    _allAddressList = [];
    update();
  }
}
