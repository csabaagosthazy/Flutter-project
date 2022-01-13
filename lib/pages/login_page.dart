import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/profile.dart';
import 'package:flutter_group2_tshirt_project/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_group2_tshirt_project/components/login_field.dart';

import '../validation.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool isPasswordInvisible = true;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  final Color enabledFieldColor = const Color(0xFF816AE2);
  final Color disabledFieldColor = const Color(0xFFD3D3D3);
  final Color enabledTextColor = Colors.white;
  final Color disabledTextColor = const Color(0xFF816AE2);

//could be null in the beggining
  Profile? selectedField;

  bool _submitted = false;

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

  //CHECK password and user
  void checkLoginOfUser() {
    setState(() => _submitted = true);
    if(_errorEmail != null){
      return;
    }

    AuthService auth = AuthService();

    //TODO: Login to firebase
    auth.signIn(controllerEmail.text, controllerPassword.text)
        .then((user) =>
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const HomePage()),
        )
    );
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
    //  controller.dispose();
  }
  String? get _errorEmail{
    return errorEmail(controllerEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 30.0),
              //   alignment: Alignment.topLeft,
              child: Center(
                  child: Image.asset('assets/images/runner.png',
                      height: 250, width: 250, fit: BoxFit.fill))),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Text(
              "Login",
              style: GoogleFonts.lora(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 46,
                  letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Please sign in to continue:",
            style: GoogleFonts.lora(
              color: Colors.deepPurple,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              //   letterSpacing: 0.5
            ),
          ),
          const SizedBox(height: 20),
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
            controller: controllerEmail,
            errorText: _submitted ?_errorEmail:null,
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
            controller: controllerPassword,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: checkLoginOfUser,
              child: Text(
                "Login",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF33F3EF),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)))),
          const SizedBox(
            height: 40,
          ),
          Text("Don't have an account?",
              style: GoogleFonts.sora(
                color: Colors.grey,
                letterSpacing: 0.5,
              )),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Signup()));
            },
            child: Text(" Sign up",
                style: GoogleFonts.sora(
                  decoration: TextDecoration.underline,
                  color: const Color(0xFF0DF5E4).withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
          ),
        ],
      )),
    );
  }
}
