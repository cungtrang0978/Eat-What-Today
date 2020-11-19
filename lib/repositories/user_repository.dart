import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eat_what_today/models/account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  //constructor

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: <String>[
              'email',
              'https://www.googleapis.com/auth/contacts.readonly',
            ]);

  Future<User> signInWithGoogle() async {
//    await _googleSignIn.signIn();
//    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
//    return firebaseUser;
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.accessToken,
        accessToken: googleSignInAuthentication.idToken);
    await _firebaseAuth.signInWithCredential(authCredential);
    final currentUser = _firebaseAuth.currentUser;
    return currentUser;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    if (!_firebaseAuth.currentUser.emailVerified) {
      await _firebaseAuth.currentUser.sendEmailVerification();
    }
  }

  Future<bool> isExistAccount() async {
    final user = await getUser();
    try {
      await usersRef.doc(user.uid).get();
      return true;
    } catch (_) {}

    return false;
  }

  Future<void> insertUser() async {
    User user = await getUser();
    final isExist = await isExistAccount();
    if (!isExist) {
      Account account = Account.fromUser(user);
      usersRef.doc(user.uid).set(account.toJson());
    }
  }

  Future<bool> isVerifiedEmail() async {
    return _firebaseAuth.currentUser.emailVerified;
  }
}
