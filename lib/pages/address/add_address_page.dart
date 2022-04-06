import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/location_controller.dart';
import 'package:food_delivery_app/controllers/user_controller.dart';
import 'package:food_delivery_app/models/address_model.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_text_field_widget.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../base/custom_loader.dart';
import '../../controllers/auth_controller.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool isLogged;

  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(31.961275, 35.957942), zoom: 14);

  LatLng _initialPosition = LatLng(31.961275, 35.957942);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogged = Get.find<AuthController>().userLoggedIn();
    if (isLogged && Get.find<UserController>().userModel.id.isEmpty) {
      //Get.find<UserController>().getUserInfo();
      Get.find<UserController>().getUserInfoFromFirebase();
    }
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(
          target: LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Page'),
        backgroundColor: AppColors.mainColor,
      ),
      body: GetBuilder<UserController>(
        builder: (userController) {
          if (userController.userModel.id.isNotEmpty &&
              _contactPersonName.text.isEmpty) {
            _contactPersonName.text = userController.userModel.name;
            _contactPersonNumber.text = userController.userModel.phone;
            if (Get.find<LocationController>().addressList.isNotEmpty) {
              _addressController.text =
                  Get.find<LocationController>().getUserAddress().address;
            }
          }
          return GetBuilder<LocationController>(
            builder: (locationController) {
              _addressController.text =
                  "${locationController.placeMark.name ?? ''}"
                  "${locationController.placeMark.locality ?? ''}"
                  "${locationController.placeMark.postalCode ?? ''}"
                  "${locationController.placeMark.country ?? ''}";
              print('ADDRESS CONTROLLER ' + _addressController.text);
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.screenHeight * 0.22,
                      margin: EdgeInsets.only(
                        left: Dimensions.width10 / 2,
                        right: Dimensions.width10 / 2,
                        top: Dimensions.height10 / 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15 / 3),
                        border: Border.all(
                          width: 2,
                          color: AppColors.mainColor,
                        ),
                      ),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 14),
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            onCameraIdle: () {
                              locationController.updatePosition(
                                  _cameraPosition, true);
                            },
                            onCameraMove: ((position) =>
                                _cameraPosition = position),
                            onMapCreated: (GoogleMapController controller) {
                              locationController.setMapController(controller);
                            },
                            myLocationEnabled: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.width20, top: Dimensions.height20),
                      child: SizedBox(
                        height: Dimensions.height10 * 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                locationController.addressTypeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  locationController.setAddressTypeIndex(index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width20,
                                      vertical: Dimensions.height10),
                                  margin: EdgeInsets.only(
                                      right: Dimensions.width10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20 / 4),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[200]!,
                                            spreadRadius: 1,
                                            blurRadius: 5)
                                      ]),
                                  child: Icon(
                                    index == 0
                                        ? Icons.home_filled
                                        : index == 1
                                            ? Icons.work
                                            : Icons.location_on,
                                    color:
                                        locationController.addressTypeIndex ==
                                                index
                                            ? AppColors.mainColor
                                            : Theme.of(context).disabledColor,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigTextWidget(text: 'Delivery Address'),
                    ),
                    AppTextFieldWidget(
                      controller: _addressController,
                      iconData: Icons.map,
                      hintText: 'Your Address',
                    ),
                    SizedBox(height: Dimensions.height10),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigTextWidget(text: 'Contact name'),
                    ),
                    AppTextFieldWidget(
                      controller: _contactPersonName,
                      iconData: Icons.map,
                      hintText: 'contact name',
                    ),
                    SizedBox(height: Dimensions.height10),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigTextWidget(text: 'Your number'),
                    ),
                    AppTextFieldWidget(
                      controller: _contactPersonNumber,
                      iconData: Icons.map,
                      hintText: 'Your number',
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),


      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (locationController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Dimensions.bottomHeightBar,
                padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30,
                  top: Dimensions.height30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2),
                  ),
                  color: AppColors.buttonBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AddressModel _addressModel = AddressModel(
                          addressType: locationController.addressTypeList[
                              locationController.addressTypeIndex],
                          contactPersonName: _contactPersonName.text,
                          contactPersonNumber: _contactPersonNumber.text,
                          address: _addressController.text,
                          latitude: locationController.position.latitude.toString(),
                          longitude: locationController.position.longitude.toString(),
                          id: Get.find<UserController>().userModel.id
                        );
                        //locationController.addAddress
                        locationController.addAddressOnFirebase(_addressModel).then((response){
                          if(response.isSuccess){
                            Get.toNamed(RouteHelper.getInitial());
                            Get.snackbar('Address','Added Successfully');
                          }else{
                            Get.snackbar("Address","Couldn't save address");
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                        ),
                        padding: EdgeInsets.only(
                            left: Dimensions.width10,
                            right: Dimensions.width10,
                            top: Dimensions.height20,
                            bottom: Dimensions.height20),
                        child: BigTextWidget(
                          text: 'Save Address',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
