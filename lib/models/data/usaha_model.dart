class UsahaModel {
  String? namaUsaha;
  String? alamat;
  String? email;
  String? userName;
  String? password;

  UsahaModel({
    this.namaUsaha,
    this.alamat,
    this.email,
    this.userName,
    this.password,
  });

  factory UsahaModel.fromMap(Map<String, dynamic> map) => UsahaModel(
    namaUsaha: map['nama'],
    alamat: map['alamat'],
    email: map['email'],
    userName: map['user_name'],
    password: map['password'],
  );

  Map<String, dynamic> toMap() => {
    "nama": namaUsaha,
    "alamat": alamat,
    "email": email,
    "user_name": userName,
    "password": password,
  };
}
