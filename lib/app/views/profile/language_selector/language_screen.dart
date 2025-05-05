import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/top_bar.dart';
import '../../../../values/values.dart';
import '../../../controllers/profile/language_selector/language_controller.dart';

class LanguageSelectorView extends StatelessWidget {
  LanguageSelectorView({super.key});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      // appBar: AppBar(
      //   backgroundColor: AppColor.pageColor,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: const Text("Language", style: TextStyle(color: Colors.black)),
      //   centerTitle: true,
      //   actions: [
      //     TextButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       child: const Text("Save", style: TextStyle(color: Colors.black)),
      //     ),
      //   ],
      // ),
      appBar: TopBar(
        title: "Language",
        showBackButton: true,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Save", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.languages.length,
          itemBuilder: (context, index) {
            final lang = controller.languages[index];
            // return _buildLanguageTile(lang, controller);
            return Obx(() => _buildLanguageTile(lang, controller));
          },
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String language, LanguageController controller) {
    final isSelected = controller.selectedLanguage.value == language;

    return GestureDetector(
      onTap: () => controller.selectLanguage(language),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(language, style: const TextStyle(fontSize: 16)),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
