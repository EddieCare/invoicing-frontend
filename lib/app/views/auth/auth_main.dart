import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
                          const SizedBox(height: 130),
                          Image.asset(
                            "assets/images/logo.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Invoice Daily",
                            style: TextStyle(
                              fontSize: 26 * textScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Create professional invoices in \nseconds",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18 * textScale),
                          ),
                          const SizedBox(height: 20),
                          // Image.asset("assets/images/arc1.png", width: 100),
                        ],
                      ),
                    ),
                  ),

                  Lottie.asset(
                    "assets/lottie/welcome.json",
                    width: 200,
                    height: 200,
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
                        // AnimatedFeatureCarousel(),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.signInWithGoogle,
                            icon: Image.asset(
                              "assets/icons/google.png",
                              height: 24,
                            ),
                            label: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // Text("---------------- Or ----------------"),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.toNamed("login"),
                            icon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            label: Text(
                              "Sign in with Email",
                              style: TextStyle(
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                              fontSize: 14 * textScale,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                text: "By continuing you are agreeing to our\n",
                                style: TextStyle(height: 4),
                              ),
                              TextSpan(
                                text: "Term's of Use",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
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
                                  fontWeight: FontWeight.w700,
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
