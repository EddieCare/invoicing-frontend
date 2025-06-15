import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../routes/app_routes.dart';

// class AuthMainController extends GetxController {}

class AuthMainController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      await _handleFirstTimeLogin(user);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> _handleFirstTimeLogin(User? user) async {
    if (user == null) return;

    final doc = await _firestore.collection('vendors').doc(user.uid).get();
    if (!doc.exists) {
      // Redirect to business details to complete setup
      Get.offAllNamed(Routes.businessDetails);
    } else {
      // Redirect to plan selection if needed
      final isActive = doc['isActive'] ?? false;
      if (!isActive) {
        Get.offAllNamed(Routes.plansScreen);
      } else {
        Get.offAllNamed(Routes.baseScreen);
      }
    }
  }
}
