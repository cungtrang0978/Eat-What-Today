

class Account {
  String uid;
  String name;
  String phoneNumber;
  String avatarUrl;
  String email;

  Account({this.uid, this.name, this.phoneNumber, this.avatarUrl, this.email});

  @override
  String toString() {
    return 'Account{uid: $uid, name: $name, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, email: $email}';
  }
  
}