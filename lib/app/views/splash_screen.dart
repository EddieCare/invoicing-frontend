import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black,
              // gradient: LinearGradient(
              //   // colors: [
              //   //   Color(0xFF1976D2),
              //   //   Color(0xFF60A5E9),
              //   //   Color(0xFFA7D3FF),
              //   // ],
              //   // begin: Alignment.topCenter,
              //   // end: Alignment.bottomCenter,
              //   colors: [Colors.blue, Colors.deepPurple],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/images/splash_item.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
