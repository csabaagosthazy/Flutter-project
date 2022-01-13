import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/pages/login_page.dart';
import 'package:flutter_group2_tshirt_project/services/auth_service.dart';
import 'package:flutter_group2_tshirt_project/services/db_service.dart';
import 'package:google_fonts/google_fonts.dart';

enum EditProfile { firstname, lastname }

///
///This page managed the profile of the user.
///User can update his/her firstname and surname.
///New values will be sent to the database.
///
///The profile shows circle avatar with first letters of
///firstname and lastname of the user.
///
///The logout button allows to log out from the current account.
///
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService auth = AuthService();
  DbService db = DbService();
  //Change for the real user's data!!
  String firstname = " ";
  String lastname = " ";
  User? user = null;

  bool firstnameIsReadOnly = true;
  bool lastnameIsReadOnly = true;

  void editField(EditProfile field) {
    switch (field) {
      case EditProfile.firstname:
        setState(() => firstnameIsReadOnly = !firstnameIsReadOnly);
        break;
      case EditProfile.lastname:
        setState(() => lastnameIsReadOnly = !lastnameIsReadOnly);
        break;
    }
  }

  void firstnameChanged(String value) async {
    if (value == "") {
      value = " ";
    } else {
      db.updateUser(user!.uid, value, lastname);
      setState(() => firstname = value);
    }
  }

  void lastnameChanged(String value) async {
    if (value == "") {
      value = " ";
    } else {
      db.updateUser(user!.uid, firstname, value);
      setState(() => lastname = value);
    }
  }

  Future<void> getUserAttirbutes() async {
    //get current user
    User? currentUser = await auth.getCurrentUser();
    if (currentUser != null) {
      DocumentSnapshot snapshot = await db.getUserById(currentUser.uid);
      if (snapshot.exists) {
        setState(() {
          lastname = snapshot.get("LastName");
          firstname = snapshot.get("FirstName");
          user = currentUser;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAttirbutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Edit Profile",
                  style: GoogleFonts.lato(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 2),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple[200],
                  child: Text(
                    firstname.substring(0, 1).toUpperCase() +
                        lastname.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.lato(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        letterSpacing: 2),
                  ),
                  maxRadius: 80,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  autofocus: true,
                  readOnly: firstnameIsReadOnly,
                  decoration: InputDecoration(
                      hintText: firstname,
                      labelText: "Firstname",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      suffixIcon: IconButton(
                        icon: firstnameIsReadOnly
                            ? const Icon(Icons.edit)
                            : const Icon(Icons.check),
                        splashColor: Colors.cyan,
                        onPressed: () => editField(EditProfile.firstname),
                      )),
                  keyboardType: TextInputType.text,
                  onChanged: firstnameChanged,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  readOnly: lastnameIsReadOnly,
                  decoration: InputDecoration(
                      hintText: lastname,
                      labelText: "Lastname",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      suffixIcon: IconButton(
                        icon: lastnameIsReadOnly
                            ? const Icon(Icons.edit)
                            : const Icon(Icons.check),
                        splashColor: Colors.cyan,
                        onPressed: () => editField(EditProfile.lastname),
                      )),
                  keyboardType: TextInputType.text,
                  onChanged: lastnameChanged,
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      AuthService auth = AuthService();
                      auth.signOut();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text(
                      "LOG OUT",
                      style: GoogleFonts.heebo(
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
