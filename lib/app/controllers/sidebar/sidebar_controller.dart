import 'package:get/get.dart';

class SidebarController extends GetxController {
  RxBool isSidebarOpen = false.obs;

  void toggleSidebar() {
    print("Here I am");
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  void closeSidebar() {
    isSidebarOpen.value = false;
  }
}
