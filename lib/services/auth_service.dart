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
  Future<User?> register(
      String email, String firstName, String lastName, String password) async {
    User? user;

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      db.createUser(user.uid, firstName, lastName);
    }

    return user;
  }

  ///Sign-in process
  ///
  ///email : user email
  ///
  ///password: user password
  ///
  ///Returns User?
  Future<User?> signIn(String email, String password) async {
    User? user;

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    return user;
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
