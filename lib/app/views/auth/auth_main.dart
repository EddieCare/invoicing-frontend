import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../values/values.dart';
import '../../controllers/auth/auth_main_controller.dart';
import '../../routes/app_routes.dart';

class AuthMainScreen extends StatelessWidget {
  final AuthMainController controller = Get.put(AuthMainController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScale = mediaQuery.textScaleFactor;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Scrollable Content (Top + Middle)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          Image.asset(
                            "assets/images/logo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Atlas Invoice",
                            style: TextStyle(
                              fontSize: 26 * textScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Create professional invoices in seconds",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18 * textScale),
                          ),
                          const SizedBox(height: 20),
                          Image.asset("assets/images/arc1.png", width: 100),
                          // const SizedBox(height: 30),
                          // Flexible(child: AnimatedFeatureCarousel()),
                          // const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Bottom - Terms & Privacy
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        AnimatedFeatureCarousel(),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.toNamed("login"),
                            icon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            label: Text(
                              "Login with email",
                              style: TextStyle(
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.signup),
                          child: Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(
                              fontSize: 16 * textScale,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12 * textScale,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                text: "By continuing you are agreeing to our ",
                              ),
                              TextSpan(
                                text: "Term's of Use",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        // Dummy link
                                        launchDummyLink(
                                          "https://example.com/terms",
                                        );
                                      },
                              ),
                              const TextSpan(text: " & "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        // Dummy link
                                        launchDummyLink(
                                          "https://example.com/privacy",
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void launchDummyLink(String url) {
    // For now, use print statement. Replace with url_launcher if needed.
    print("Open link: $url");
  }
}

// class AnimatedFeatureCarousel extends StatefulWidget {
//   const AnimatedFeatureCarousel({Key? key}) : super(key: key);

//   @override
//   State<AnimatedFeatureCarousel> createState() =>
//       _AnimatedFeatureCarouselState();
// }

// class _AnimatedFeatureCarouselState extends State<AnimatedFeatureCarousel> {
//   final List<String> features = [
//     "https://s3u.tmimgcdn.com/800x0/2307735-1605599531781_TM-03.jpg",
//     "https://cdn.shopify.com/s/files/1/1246/6441/articles/Design_for_Small_Store.png?v=1727354596",
//     "https://cdni.iconscout.com/illustration/premium/thumb/pharmacy-store-billing-counter-illustration-download-in-svg-png-gif-file-formats--bill-chemist-storefront-outlet-pack-medical-professionals-illustrations-4440163.png",
//     "https://static.vecteezy.com/system/resources/previews/002/035/092/non_2x/supermarket-grocery-store-interior-flat-illustration-vector.jpg",
//   ];

//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 3));
//       if (!mounted) return false;
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % features.length;
//       });
//       return true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textScale = MediaQuery.of(context).textScaleFactor;
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 600),
//       transitionBuilder:
//           (child, animation) =>
//               FadeTransition(opacity: animation, child: child),
//       child: Container(
//         height: 300,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         width: MediaQuery.of(context).size.width * 0.95,
//         key: ValueKey(_currentIndex),
//         child: ClipRect(
//           child: Image.network(
//             features[_currentIndex],
//             key: ValueKey(_currentIndex),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

class AnimatedFeatureCarousel extends StatefulWidget {
  const AnimatedFeatureCarousel({Key? key}) : super(key: key);

  @override
  State<AnimatedFeatureCarousel> createState() =>
      _AnimatedFeatureCarouselState();
}

class _AnimatedFeatureCarouselState extends State<AnimatedFeatureCarousel> {
  final List<String> features = [
    "https://s3u.tmimgcdn.com/800x0/2307735-1605599531781_TM-03.jpg",
    "https://cdn.shopify.com/s/files/1/1246/6441/articles/Design_for_Small_Store.png?v=1727354596",
    "https://cdni.iconscout.com/illustration/premium/thumb/pharmacy-store-billing-counter-illustration-download-in-svg-png-gif-file-formats--bill-chemist-storefront-outlet-pack-medical-professionals-illustrations-4440163.png",
    "https://static.vecteezy.com/system/resources/previews/002/035/092/non_2x/supermarket-grocery-store-interior-flat-illustration-vector.jpg",
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        _currentIndex = (_currentIndex + 1) % features.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width * 0.6; // Maintain a consistent aspect ratio

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: Container(
            key: ValueKey(_currentIndex),
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(features[_currentIndex], fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
