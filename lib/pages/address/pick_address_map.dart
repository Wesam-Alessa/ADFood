import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_button.dart';
import 'package:food_delivery_app/controllers/location_controller.dart';
import 'package:food_delivery_app/pages/address/widgets/search_location_dialogue_page.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../routes/route_helper.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController? googleMapController;

  const PickAddressMap({
    Key? key,
    required this.fromSignUp,
    required this.fromAddress,
    required this.canRoute,
    required this.route,
    this.googleMapController,
  }) : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  LatLng _initialPosition = LatLng(31.961275, 35.957942);
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (Get.find<LocationController>().addressList.isEmpty) {
    // _initialPosition = LatLng(31.961275, 35.957942);
    //  _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    // } else {
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else if (Get.find<LocationController>()
        .getUserAddressFromLocalStorage()
        .isNotEmpty) {
      setState(() {
        _cameraPosition = CameraPosition(
            target: LatLng(
                double.parse(
                    Get.find<LocationController>().getAddress['latitude']),
                double.parse(
                    Get.find<LocationController>().getAddress['longitude'])),
            zoom: 17);
        _initialPosition = LatLng(
            double.parse(Get.find<LocationController>().getAddress['latitude']),
            double.parse(
                Get.find<LocationController>().getAddress['longitude']));
      });
    } else {
      Get.find<LocationController>().getGeoLocationPosition().then((value) {
        setState(() {
          _cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 17);
          _initialPosition = LatLng(value.latitude, value.longitude);
        });
      });
    }

    //}
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: double.maxFinite,
                child: Stack(
                  children: [
                    _initialPosition.latitude == 31.961275
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ))
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 17),
                            zoomControlsEnabled: false,
                            onCameraMove: ((position) =>
                                _cameraPosition = position),
                            onCameraIdle: () {
                              Get.find<LocationController>()
                                  .updatePosition(_cameraPosition, false);
                            },
                            onMapCreated: (GoogleMapController mapController){
                              _mapController = mapController;
                            },

                          ),
                    Center(
                      child: !locationController.loading
                          ? Icon(
                              Icons.person_pin_circle,
                              size: Dimensions.iconSize24 * 2.5,
                              color: Colors.blue,
                            )
                          : const CircularProgressIndicator(),
                    ),
                    Positioned(
                      top: Dimensions.height45,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child:InkWell(
                        onTap: ()=>Get.dialog(LocationDialogue(mapController: _mapController)),
                        child: Container(
                          height: Dimensions.height10 * 5,
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20 / 2),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: Dimensions.iconSize24,
                                color: AppColors.yellowColor,
                              ),
                              Expanded(
                                child: Text(
                                  "${locationController.pickPlaceMark.name ?? ''}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimensions.font16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: Dimensions.width10),
                                Icon(
                                  Icons.search,
                                  size: Dimensions.iconSize24,
                                  color: AppColors.yellowColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: Dimensions.screenHeight / 10,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child:  locationController.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              //width: Dimensions.screenWidth / 2,
                              buttonText: locationController.inZone
                                  ? widget.fromAddress
                                      ? 'Pick Address'
                                      : "Pick Location"
                                  : "Service is not available in your area",
                              onPressed: (locationController.buttonDisabled || locationController.loading)
                                  ? null
                                  : () {
                                      if (locationController
                                                  .pickPosition.latitude !=
                                              0 &&
                                          locationController
                                                  .pickPlaceMark.name !=
                                              null) {
                                        if (widget.fromAddress) {
                                          if (widget.googleMapController !=
                                              null) {
                                            widget.googleMapController!.moveCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                        target: LatLng(
                                                            locationController
                                                                .pickPosition
                                                                .latitude,
                                                            locationController
                                                                .pickPosition
                                                                .longitude))));
                                            locationController
                                                .setAddAddressData();
                                          }
                                          Get.toNamed(
                                              RouteHelper.getAddressPage());
                                        }
                                      }
                                    },
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
