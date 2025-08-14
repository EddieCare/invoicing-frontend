import 'package:get/get.dart';
import 'package:invoicedaily/app/views/shop/shop_detail.dart';

import '../views/auth/auth_main.dart';
import '../views/auth/business_detail_screen.dart';
import '../views/auth/otp_verification.dart';
import '../views/auth/signup_screen.dart';
import '../views/base/base_screen.dart';
import '../views/invoices/create_invoice_screen.dart';
import '../views/invoices/invoice_preview_screen.dart';
import '../views/invoices/view_invoice.dart';
import '../views/plans/plans_screen.dart';
import '../views/product/add_product.dart';
import '../views/product/add_service.dart';
import '../views/product/edit_product_screen.dart';
import '../views/product/view_product.dart';
import '../views/profile/edit_profile/edit_profile_screen.dart';
import '../views/profile/language_selector/language_screen.dart';
import '../views/profile/notification/notification_screen.dart';
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
    GetPage(name: Routes.baseScreen, page: () => BaseScreen()),
    GetPage(name: Routes.dashboard, page: () => DashboardScreen()),
    GetPage(name: Routes.notificationScreen, page: () => NotificationScreen()),

    // Profile
    GetPage(name: Routes.editProfile, page: () => EditProfileScreen()),
    GetPage(name: Routes.languageScreen, page: () => LanguageSelectorView()),
    GetPage(name: Routes.plansScreen, page: () => SubscriptionPage()),

    // Invoices
    GetPage(name: Routes.createInvoice, page: () => CreateInvoiceScreen()),
    GetPage(name: Routes.invoiceDetails, page: () => InvoiceDetailsScreen()),
    GetPage(
      name: Routes.invoicePreviewScreen,
      page: () => InvoicePreviewScreen(),
    ),

    // Product
    GetPage(name: Routes.addProductScreen, page: () => AddProductScreen()),
    GetPage(name: Routes.addServiceScreen, page: () => AddServiceScreen()),
    GetPage(name: Routes.viewProductScreen, page: () => ViewProductScreen()),
    GetPage(name: Routes.editProductScreen, page: () => EditProductScreen()),

    // Shop
    GetPage(
      name: Routes.shopDetailScreen,
      page: () => ShopDetailScreen(shopData: Get.arguments),
    ),

    // OTP
    GetPage(
      name: Routes.emailOtpVerification,
      page: () => EmailOtpVerificationPage(),
    ),
  ];
}
