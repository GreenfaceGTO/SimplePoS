class UserModel {
  String? nama;
  String? email;
  bool loggedIn;
  String? pin;

  UserModel({this.nama, this.email, this.loggedIn = false, this.pin});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    nama: json['nama'],
    email: json['email'],
    loggedIn: json['logged_in'] ?? false,
    pin: json['pin'],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "email": email,
    "logged_in": loggedIn,
    "pin": pin,
  };
}
