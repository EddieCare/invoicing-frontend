import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user == null || !user.emailVerified) {
      Get.offAllNamed(Routes.authMain); // Not logged in
    } else {
      Get.offAllNamed(Routes.baseScreen); // Logged in
    }
  }

  Future<void> signOut() async {
    // Google sign-out if signed in
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}

    await _auth.signOut();
  }

  bool get isLoggedIn => firebaseUser.value != null;
}
