 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;
//AIzaSyDjHSDTbzDmdMba04MgSMb5dfmwVsh2gII
//AIzaSyBwsOen0gIR14UzyWKhq97bClbb36kRcU4
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((User? user) {
    //   if (user == null) {
    //     showCustomSnackBar('User is currently signed out!');
    //   } else {
    //     showCustomSnackBar('User is signed in!');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(
      builder: (_) {
        return GetBuilder<RecommendedProductController>(
          builder: (_) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Food App',
               // home: SignInPage(),
              initialRoute: RouteHelper.getSplashPage(),
              getPages: RouteHelper.routes,
            );
          },
        );
      },
    );
  }
}



//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Homepage(),
//     );
//   }
// }
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   String location = 'Null, Press Button';
//   String Address = 'search';
//
//   Future<Position> _getGeoLocationPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
//
//   Future<void> GetAddressFromLatLong(Position position) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     print(placemarks);
//     Placemark place = placemarks[0];
//     Address =
//         '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Coordinates Points',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               location,
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               'ADDRESS',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text('${Address}'),
//             ElevatedButton(
//               onPressed: () async {
//                 Position position = await _getGeoLocationPosition();
//                 location =
//                     'Lat: ${position.latitude} , Long: ${position.longitude}';
//                 GetAddressFromLatLong(position);
//               },
//               child: Text('Get Location'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
