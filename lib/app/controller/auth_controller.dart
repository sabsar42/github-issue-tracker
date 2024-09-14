// lib/controllers/auth_controller.dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  var username = ''.obs;

  void setUsername(String newUsername) {
    username.value = newUsername;
    update();
  }
}
