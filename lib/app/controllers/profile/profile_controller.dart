import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxList<bool> notifications = List<bool>.filled(6, false).obs;

  void toggleNotification(int index) {
    notifications[index] = !notifications[index];
  }

  void completeOnboarding() {
    // Logic to mark onboarding as complete
  }
}
