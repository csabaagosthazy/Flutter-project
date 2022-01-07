import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/profile.dart';
import 'package:flutter_group2_tshirt_project/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_group2_tshirt_project/components/login_field.dart';

import '../validation.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isPasswordInvisible = true;
  bool _submitted = false;

  final Color enabledFieldColor = Colors.white;
  final Color disabledFieldColor = const Color(0xFFD3D3D3);
  final Color enabledTextColor = const Color(0xFF9B5EF7);
  final Color disabledTextColor = const Color(0xFF9B5EF7);

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

//could be null in the beggining
  Profile? selectedField;

  String? get _errorFirstname{
    return errorText(firstnameController);
  }

  String? get _errorLastname{
    return errorText(lastnameController);
  }
  String? get _errorEmail{
    return errorEmail(emailController);
  }
  String? get _errorPassword{
    return errorPassword(passwordController);
  }
  String? get _errorPasswordConfirmation{
    return errorPasswordConfirmation(passwordConfirmationController, passwordController);
  }

  Color setColorField(Profile f) {
    return selectedField == f ? enabledFieldColor : disabledFieldColor;
  }

  Color setColorText(Profile f) {
    return selectedField == f ? enabledTextColor : disabledTextColor;
  }

  setSelectedField(Profile selected) {
    setState(() {
      selectedField = selected;
    });
  }

  bool changePasswordVisibility() {
    setState(() {
      isPasswordInvisible = !isPasswordInvisible;
    });
    return isPasswordInvisible;
  }
  void signUp(){
    setState(() => _submitted = true);
    if(_errorFirstname != null || _errorLastname != null || _errorEmail != null || _errorPassword != null || _errorPasswordConfirmation != null){
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF816AE2),
      //backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text(
              "Create Account",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  letterSpacing: 2),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Please add your information here:",
              style: GoogleFonts.lato(
                  color: Colors.white, fontSize: 16, letterSpacing: 1),
            ),
            const SizedBox(height: 20),
            InputLoginField(
              hintText: "Firstname",
              icon: Icons.person_outline_rounded,
              field: Profile.firstname,
              setColorField: setColorField,
              setColorText: setColorText,
              setSelectedField: setSelectedField,
              isPassword: false,
              isPasswordInvisible: isPasswordInvisible,
              changePasswordVisibility: changePasswordVisibility,
              controller: firstnameController,
              errorText: _submitted ? _errorFirstname : null,
            ),
            InputLoginField(
              hintText: "Lastname",
              icon: Icons.person_outline_rounded,
              field: Profile.lastname,
              setColorField: setColorField,
              setColorText: setColorText,
              setSelectedField: setSelectedField,
              isPassword: false,
              isPasswordInvisible: isPasswordInvisible,
              changePasswordVisibility: changePasswordVisibility,
              controller: lastnameController,
              errorText: _submitted ? _errorLastname : null,

            ),
            InputLoginField(
              hintText: "Email",
              icon: Icons.email_outlined,
              field: Profile.email,
              setColorField: setColorField,
              setColorText: setColorText,
              setSelectedField: setSelectedField,
              isPassword: false,
              isPasswordInvisible: isPasswordInvisible,
              changePasswordVisibility: changePasswordVisibility,
              controller: emailController,
              errorText: _submitted ? _errorEmail : null,

            ),
            InputLoginField(
              hintText: "Password",
              icon: Icons.lock_outline_rounded,
              field: Profile.password,
              setColorField: setColorField,
              setColorText: setColorText,
              setSelectedField: setSelectedField,
              isPassword: true,
              isPasswordInvisible: isPasswordInvisible,
              changePasswordVisibility: changePasswordVisibility,
              controller: passwordController,
              errorText: _submitted ? _errorPassword : null,

            ),
            InputLoginField(
              hintText: "Confirm Password",
              icon: Icons.lock_outline_rounded,
              field: Profile.confirmPassword,
              setColorField: setColorField,
              setColorText: setColorText,
              setSelectedField: setSelectedField,
              isPassword: true,
              isPasswordInvisible: isPasswordInvisible,
              changePasswordVisibility: changePasswordVisibility,
              controller: passwordConfirmationController,
              errorText: _submitted ? _errorPasswordConfirmation : null,

            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  signUp();
                },
                child: Text(
                  "SIGN UP",
                  style: GoogleFonts.heebo(
                    color: Colors.black,
                    letterSpacing: 0.5,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF0DF5E4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)))),
          ],
        ),
      ),
    );
  }
}
