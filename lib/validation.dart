import 'package:flutter/cupertino.dart';

String? errorText(TextEditingController controller) {
  // at any time, we can get the text from _controller.value.text
  final text = controller.value.text;

  if (text.isEmpty) {
    return 'Can\'t be empty';
  }
  if (text.length < 4) {
    return 'Too short';
  }
  // return null if the text is valid
  return null;
}

String? errorEmail(TextEditingController controller){
  // at any time, we can get the text from _controller.value.text
  final text = controller.value.text;
  print("SOS" + controller.value.toString());
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
  // at any time, we can get the text from _controller.value.text
  final text = controller.value.text;
  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  //Min characters password
  int minLength = 8;
  bool hasMinLength = text.length > minLength;
  if (!hasMinLength) {
    return "The password must be equals or greater than "+minLength.toString() + "characters";
  }
  //At least one uppercase
  bool hasUppercase = text.contains(new RegExp(r'[A-Z]'));
  if(!hasUppercase){
    return "The password must contain at least one uppercase character !";
  }

  //At leat one lowercase
  bool hasLowercase = text.contains(new RegExp(r'[a-z]'));
  if(!hasLowercase){
    return "The password must contain at least one lowercase character !";
  }
  //Contains some disgits
  bool hasDigits = text.contains(new RegExp(r'[0-9]'));
  if(!hasDigits){
    return "The password must contain at least one number !";
  }
  //Contains one special character
  bool hasSpecialCharacters = text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  if(!hasSpecialCharacters){
    return "The password must contain at least one special character !";
  }
return null;
}
String? errorPasswordConfirmation(TextEditingController passwordConfirmationController, TextEditingController passwordController) {

  if(passwordConfirmationController.value.text != passwordController.value.text){
    return "Passwords are not the same!";
  }
  return null;

}
