class AppUser {
  final String uid;
  AppUser({this.uid});
}

class UserData {
  String firstName;
  String lastName;
  String phoneNumber;
  String uni;
  List<String> interests = [];
  UserData({this.firstName, this.lastName, this.phoneNumber, this.uni});
}
