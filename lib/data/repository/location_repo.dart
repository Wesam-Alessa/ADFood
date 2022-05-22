import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/data/api/api_client.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/address_model.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({required this.apiClient, required this.sharedPreferences});

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? '';
  }

  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    return await apiClient.getData('${AppConstants.GEOCODE_URI}'
        '?lat=${latLng.latitude}&lng=${latLng.longitude}');
  }

  String address = 'search';

  Future<String> getAddressFromLatLang(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return address;
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(
        AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<bool> addAddressOnFirebase(AddressModel addressModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('address')
          .doc()
          .set(addressModel.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<List<AddressModel>> getAllAddressFromFirebase() async {
    List<AddressModel> allAddress = [];
    try {
      await FirebaseFirestore.instance
          .collection('address')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          allAddress.add(AddressModel.fromJson(doc.data() as Map<String,dynamic>));
        });
      });
      return allAddress;
    } catch (e) {
      print(e.toString());
    }
    return allAddress;
  }

  Future<bool> saveUserAddress(String userAddress) async {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(
        AppConstants.USER_ADDRESS, userAddress);
  }

  Future<Response> getZone(String lat, String lng) async{
    return await apiClient.getData("${AppConstants.ZONE_URI}?lat=$lat&lng=$lng");
  }

}
