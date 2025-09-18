import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/buttons.dart';
import '../../../components/input_fld.dart';
import '../../../values/values.dart';
import '../../controllers/shop/shop_controller.dart';

void showCreateShopBottomSheet(BuildContext context) {
  _showShopFormBottomSheet(context: context);
}

void showEditShopBottomSheet(
  BuildContext context,
  Map<String, dynamic> shopData,
) {
  _showShopFormBottomSheet(context: context, existingShop: shopData);
}

void _showShopFormBottomSheet({
  required BuildContext context,
  Map<String, dynamic>? existingShop,
}) {
  final isEdit = existingShop != null;
  final controller = Get.find<ShopController>();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(
    text: _readString(existingShop?['shop_name']),
  );
  final taxController = TextEditingController(
    text: _readString(existingShop?['tax_number']),
  );
  final typeController = TextEditingController(
    text: _readString(existingShop?['shop_type']),
  );
  final categoryController = TextEditingController(
    text: _readString(existingShop?['shop_category']),
  );
  final emailController = TextEditingController(
    text: _readString(existingShop?['shop_email']),
  );
  final phoneController = TextEditingController(
    text: _readString(existingShop?['shop_phone']),
  );

  final existingAddress = _readAddress(existingShop?['shop_address']);
  final addressController = TextEditingController(
    text: _readString(
      existingAddress['street'] ?? existingShop?['shop_address'],
    ),
  );

  Uint8List? selectedLogoBytes;
  int? selectedLogoSize;
  int? originalLogoSize;
  String? selectedLogoName;

  final imagePicker = ImagePicker();
  String? activeLogoUrl =
      _readOptionalString(existingShop?['shopLogo']) ??
      _readOptionalString(existingShop?['shop_image_link']);
  final previousLogoUrl = activeLogoUrl;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.pageColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> pickLogo() async {
            try {
              final XFile? file = await imagePicker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 2000,
                maxHeight: 2000,
              );
              if (file == null) return;

              final originalBytes = await file.readAsBytes();
              final optimised = await controller.optimiseLogo(originalBytes);
              if (optimised == null) return;

              setModalState(() {
                selectedLogoBytes = optimised;
                originalLogoSize = originalBytes.lengthInBytes;
                selectedLogoSize = optimised.lengthInBytes;
                selectedLogoName = file.name;
                activeLogoUrl = null;
              });
            } catch (e) {
              Get.snackbar('Logo Error', 'Failed to pick logo: $e');
            }
          }

          String sizeLabel(int? bytes) {
            if (bytes == null) return '';
            final value = (bytes / 1024).toStringAsFixed(1);
            return '$value KB';
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 15,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColor.textColorPrimary.withAlpha(80),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        isEdit ? 'Edit Shop' : 'Create Shop',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    buildInputField(
                      nameController,
                      'Shop Name',
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Shop Logo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: pickLogo,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black12),
                        ),
                        child:
                            selectedLogoBytes != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.memory(
                                    selectedLogoBytes!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                                : activeLogoUrl != null &&
                                    activeLogoUrl!.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    activeLogoUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.cloud_upload_outlined, size: 36),
                                    SizedBox(height: 8),
                                    Text('Tap to upload (≤ 2 MB)'),
                                  ],
                                ),
                      ),
                    ),
                    if (isEdit &&
                        selectedLogoBytes == null &&
                        activeLogoUrl != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tap above to replace the current logo.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    if (selectedLogoName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedLogoName!,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Optimised: ${sizeLabel(selectedLogoSize)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (originalLogoSize != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Original: ${sizeLabel(originalLogoSize)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    buildInputField(taxController, 'Tax Number'),
                    buildInputField(
                      typeController,
                      'Shop Type',
                      isRequired: true,
                    ),
                    buildInputField(
                      categoryController,
                      'Shop Category',
                      isRequired: true,
                    ),
                    buildInputField(
                      emailController,
                      'Shop Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    buildInputField(
                      phoneController,
                      'Shop Phone',
                      keyboardType: TextInputType.phone,
                    ),
                    buildInputField(
                      addressController,
                      'Shop Address (Street, City, State, Zip, Country)',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: isEdit ? 'Save Changes' : 'Create Shop',
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (formKey.currentState?.validate() != true)
                              return;

                            if (!isEdit && selectedLogoBytes == null) {
                              Get.snackbar(
                                'Logo Required',
                                'Please upload a shop logo before continuing.',
                              );
                              return;
                            }

                            final addressPayload = {
                              ..._readAddress(existingShop?['shop_address']),
                              'street': addressController.text.trim(),
                            };
                            if (!isEdit) {
                              addressPayload.addAll({
                                'city': '',
                                'state': '',
                                'zip': '',
                                'country': '',
                              });
                            }

                            final data = {
                              'shop_name': nameController.text.trim(),
                              'tax_number': taxController.text.trim(),
                              'shop_type': typeController.text.trim(),
                              'shop_category': categoryController.text.trim(),
                              'shop_email': emailController.text.trim(),
                              'shop_phone': phoneController.text.trim(),
                              'shop_address': addressPayload,
                            };

                            if (isEdit) {
                              final shopId =
                                  existingShop?['id']?.toString() ??
                                  controller.shopData.value?['id'];
                              if (shopId == null) {
                                Get.snackbar(
                                  'Error',
                                  'Unable to determine shop record to update.',
                                );
                                return;
                              }

                              controller.updateShop(
                                shopId: shopId,
                                data: data,
                                logoBytes: selectedLogoBytes,
                                previousLogoUrl: previousLogoUrl,
                              );
                            } else {
                              controller.createShop(
                                data,
                                logoBytes: selectedLogoBytes,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

String _readString(dynamic value) => value == null ? '' : value.toString();

String? _readOptionalString(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isEmpty ? null : str;
}

Map<String, dynamic> _readAddress(dynamic raw) {
  if (raw is Map<String, dynamic>) {
    return Map<String, dynamic>.from(raw);
  }
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return {};
}
