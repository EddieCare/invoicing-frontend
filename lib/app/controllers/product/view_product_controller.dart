import 'package:get/get.dart';
import 'package:invoicing_fe/app/routes/app_routes.dart';
import '../../models/product_model.dart';

class ProductsViewController extends GetxController {
  // All products (you can load from API/db)
  final RxList<Product> _products = <Product>[].obs;

  // Currently selected product
  final Rxn<Product> selectedProduct = Rxn<Product>();

  List<Product> get products => _products;

  // Set the current product (called before navigating to ViewProductScreen)
  void selectProduct(Product product) {
    selectedProduct.value = product;
  }

  // Edit logic - navigate to edit screen with selected product
  void editProduct() {
    // Assuming you navigate to a screen that uses the selectedProduct
    // selectedProduct.value = product;
    Get.toNamed(Routes.editProductScreen);
  }

  // Delete logic - remove product from list
  void deleteProduct() {
    if (selectedProduct.value != null) {
      _products.removeWhere((p) => p.id == selectedProduct.value!.id);
      Get.back(); // Close the View screen
      Get.snackbar('Deleted', 'Product has been deleted');
    }
  }

  // Optional: Add a product (used elsewhere)
  void addProduct(Product product) {
    _products.add(product);
  }

  // Optional: Update a product (used in edit)
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
  }
}
