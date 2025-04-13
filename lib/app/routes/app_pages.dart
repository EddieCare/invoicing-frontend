import 'package:get/get.dart';
import 'package:invoicing_fe/app/views/auth/auth_main.dart';
import '../views/auth/business_detail_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/splash_screen.dart';
import '../views/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.onboarding, page: () => OnboardingScreen()),
    GetPage(name: Routes.authMain, page: () => AuthMainScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.signup, page: () => SignupScreen()),
    GetPage(name: Routes.businessDetails, page: () => BusinessDetailScreen()),
    GetPage(name: Routes.dashboard, page: () => DashboardScreen()),
  ];
}
