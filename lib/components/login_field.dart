import 'package:flutter/material.dart';

import 'profile.dart';

///The input field for all inputs that we have in login screen and sign in screen
class InputLoginField extends StatelessWidget {
  const InputLoginField(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.field,
      required this.setColorField,
      required this.setColorText,
      required this.setSelectedField,
      required this.isPassword,
      required this.isPasswordInvisible,
      required this.changePasswordVisibility})
      : super(key: key);

  //final Profile profile;
  final Profile field;
  final String hintText;
  final bool isPassword;
  final bool isPasswordInvisible;
  final Function() changePasswordVisibility;
  final IconData icon;
  final Function(Profile) setSelectedField;
  final Function(Profile) setColorField;
  final Function(Profile) setColorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: setColorField(field)),
      child: TextField(
        obscureText: isPassword ? isPasswordInvisible : false,
        onTap: () {
          setSelectedField(field);
        },
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: setColorText(field)),
            hintText: hintText,
            hintStyle: TextStyle(color: setColorText(field)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: isPasswordInvisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      changePasswordVisibility();
                    })
                : null),
        style:
            TextStyle(color: setColorText(field), fontWeight: FontWeight.bold),
      ),
    );
  }
}
