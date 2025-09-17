import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../routes/app_routes.dart';

class AuthMainController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool appleSignInAvailable = false.obs;

  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    _checkAppleSignInAvailability();
    super.onInit();
  }

  Future<void> _checkAppleSignInAvailability() async {
    try {
      final available = await SignInWithApple.isAvailable();
      appleSignInAvailable.value = available;
    } catch (_) {
      appleSignInAvailable.value = false;
    }
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
      Get.snackbar("Error", "Something Went wrong");
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null &&
          (credential.givenName != null || credential.familyName != null)) {
        final buffer = StringBuffer();
        if (credential.givenName != null && credential.givenName!.isNotEmpty) {
          buffer.write(credential.givenName);
        }
        if (credential.familyName != null && credential.familyName!.isNotEmpty) {
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(credential.familyName);
        }
        final displayName = buffer.toString();
        if (displayName.isNotEmpty && user.displayName != displayName) {
          await user.updateDisplayName(displayName);
        }
      }

      await _handleFirstTimeLogin(user);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }
      Get.snackbar('Error', 'Apple sign in failed, please try again.');
    } catch (e) {
      Get.snackbar('Error', 'Something Went wrong');
    }
  }

  Future<void> _handleFirstTimeLogin(User? user) async {
    if (user == null) return;

    final email = user.email;
    if (email == null || email.isEmpty) {
      Get.snackbar(
        'Error',
        'No email associated with this account. Please contact support.',
      );
      await _auth.signOut();
      return;
    }

    final doc = await _firestore.collection('vendors').doc(email).get();
    if (!doc.exists) {
      // Redirect to business details to complete setup
      Get.offAllNamed(Routes.businessDetails);
    } else {
      // Redirect to plan selection if needed
      final isActive = doc['isActive'] ?? false;
      final isArchived = doc['isArchived'] ?? false;
      final isSubscribed = doc['isSubscribed'] ?? false;
      if (!isActive || isArchived) {
        Get.snackbar(
          "Your account is paused",
          "No account activvities can be done",
        );
        Get.offAllNamed(Routes.authMain);
        return;
      }
      if (!isSubscribed) {
        Get.offAllNamed(Routes.plansScreen);
        return;
      } else {
        Get.offAllNamed(Routes.baseScreen);
        return;
      }
    }
  }
}
