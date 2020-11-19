import 'package:firebase_auth/firebase_auth.dart';

class Account {
  String uid;
  String displayName;
  String phoneNumber;
  String photoURL;
  String email;

  Account({this.uid, this.displayName, this.phoneNumber, this.photoURL, this.email});


  @override
  String toString() {
    return 'Account{uid: $uid, displayName: $displayName, phoneNumber: $phoneNumber, photoURL: $photoURL, email: $email}';
  }

  // Account.fromJson(Map<String, dynamic> json){
  //
  // }
  Account.fromUser(User user){
    uid = user.uid;
    displayName = user.displayName;
    phoneNumber = user.phoneNumber;
    photoURL = user.photoURL;
    email = user.email;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String,dynamic>();
    data['displayName'] = this.displayName;
    data['phoneNumber']  = this.phoneNumber;
    data['photoURL'] = this.photoURL;
    data['email'] = this.email;
    return data;
  }
}
