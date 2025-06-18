import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/values/values.dart';
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
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/images/splash_item.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: AppColor.themeColor,
                    ),
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
