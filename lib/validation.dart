import 'package:flutter/cupertino.dart';

String? errorText(TextEditingController controller) {
  final text = controller.value.text;

  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  return null;
}

String? errorEmail(TextEditingController controller){
  final text = controller.value.text;

  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if ( !regex.hasMatch(text)){
    return 'Enter a valid email address';
  }

  return null;

}

String? errorPassword(TextEditingController controller) {
  final text = controller.value.text;
  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  //Min characters password
  int minLength = 8;
  bool hasMinLength = text.length >= minLength;
  if (!hasMinLength) {
    return ">= than "+minLength.toString() + " characters";
  }
  //At least one uppercase
  bool hasUppercase = text.contains(new RegExp(r'[A-Z]'));
  if(!hasUppercase){
    return "Need to contain one uppercase character !";
  }

  //At leat one lowercase
  bool hasLowercase = text.contains(new RegExp(r'[a-z]'));
  if(!hasLowercase){
    return "Need to contain one lowercase character !";
  }
  //Contains some disgits
  bool hasDigits = text.contains(new RegExp(r'[0-9]'));
  if(!hasDigits){
    return "Need to contain one number !";
  }
  //Contains one special character
  bool hasSpecialCharacters = text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  if(!hasSpecialCharacters){
    return "Need to contain one special character !";
  }
return null;
}
String? errorPasswordConfirmation(TextEditingController passwordConfirmationController, TextEditingController passwordController) {

  if(passwordConfirmationController.value.text != passwordController.value.text){
    return "Passwords are not the same!";
  }
  return null;

}
