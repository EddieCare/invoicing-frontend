import 'package:flutter/material.dart';

import '../../values/values.dart';

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: AppColor.pageColor,
    elevation: 0,
    titleSpacing: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {},
    ),
    title: const Text(
      "Edit Profile",
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black87),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {},
      ),
    ],
  );
}

Widget buildTextField(
  String label,
  TextEditingController controller,
  String hint,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDropdownField(
  String label,
  String value,
  List<String> items,
  ValueChanged<String?> onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items:
              items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    ],
  );
}

Widget buildPhoneField() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone number",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset(
                  "assets/flags/us.png",
                  width: 32,
                  height: 20,
                ), // Add US flag asset
              ),
              const Text("123-456-7890", style: TextStyle(fontSize: 16)),
              const Spacer(),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget buildSubmitButton(VoidCallback onPressed, String buttonText) {
//   return SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: () => onPressed(),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Text(
//         buttonText,
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     ),
//   );
// }

Widget buildSubmitButton({
  required VoidCallback onPressed,
  required String buttonText,
  required bool? isLoading,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: isLoading! ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 2.5,
                ),
              )
              : Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
    ),
  );
}
