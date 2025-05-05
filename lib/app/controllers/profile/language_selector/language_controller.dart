// language_controller.dart
import 'package:get/get.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'English'.obs;

  var languages =
      <String>[
        'English',
        'Hindi',
        'Sanskrit',
        'Urdu',
        'French',
        'Spanish',
        'Chinese',
        'Japanese',
        'Korean',
      ].obs;

  void selectLanguage(String lang) {
    print("Language is this --> " + lang);
    selectedLanguage.value = lang;
  }
}
