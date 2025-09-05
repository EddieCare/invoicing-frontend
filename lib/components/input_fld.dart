// import 'package:flutter/material.dart';

// Widget buildInputField(
//   TextEditingController controller,
//   String label, {
//   bool isRequired = false,
//   TextInputType keyboardType = TextInputType.text,
//   int maxLines = 1,
//   String? Function(String?)? customValidator,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 16),
//     child: TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator: (value) {
//         if (isRequired && (value == null || value.trim().isEmpty)) {
//           return 'This field is required';
//         }
//         if (customValidator != null) {
//           return customValidator(value);
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable Input Field
Widget buildInputField(
  TextEditingController controller,
  String label, {
  bool isRequired = false,
  bool isNumber = false,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  String? Function(String?)? customValidator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: isRequired ? "$label *" : label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black45),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return "$label is required";
        }
        if (customValidator != null) {
          return customValidator(value);
        }
        return null;
      },
    ),
  );
}

/// Reusable Dropdown
Widget buildDropdownField(
  String label,
  RxString selectedValue,
  List<String> items, {
  bool isRequired = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Obx(
      () => DropdownButtonFormField<String>(
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: (value) {
          if (value != null) selectedValue.value = value;
        },
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: isRequired ? "$label *" : label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        iconEnabledColor: Colors.black,
        dropdownColor: Colors.white,
      ),
    ),
  );
}

/// Reusable Button
Widget buildButton(
  String label, {
  required VoidCallback onTap,
  bool isPrimary = true,
}) {
  return Expanded(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.black : Colors.grey.shade300,
        foregroundColor: isPrimary ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    ),
  );
}
