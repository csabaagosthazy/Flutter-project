import "./db_service.dart";
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DbService db = DbService();

  ///Registration process (call db create user also)
  ///
  ///email : user email
  ///
  ///firstName : user first name
  ///
  ///lastName : user last name
  ///
  ///password: user password
  ///
  ///Returns registration success
  Future<bool> register(
      String email, String firstName, String lastName, String password) async {
    bool registrationSuccess = false;
    final User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      db
          .createUser(user.uid, firstName, lastName)
          .then((_) => registrationSuccess = true);
    }

    return registrationSuccess;
  }

  ///Sign-in process
  ///
  ///email : user email
  ///
  ///password: user password
  ///
  ///Returns User?
  Future<User?> signIn(String email, String password) async {
    return (await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user!;
  }

  ///Sign-out process
  ///
  ///Signes out the current user
  Future<void> signOut() async {
    await auth.signOut();
  }

  ///get current user
  ///
  ///Returns current user or null
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }
}
