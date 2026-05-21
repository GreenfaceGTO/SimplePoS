class UsahaModel {
  String? logoToko;
  String? namaUsaha;
  String? alamat;
  String? email;
  String? userName;
  String? password;

  UsahaModel({
    this.logoToko,
    this.namaUsaha,
    this.alamat,
    this.userName,
    this.email,
    this.password,
  });

  factory UsahaModel.fromMap(Map<String, dynamic> map) => UsahaModel(
    logoToko: map['logo_toko'],
    namaUsaha: map['nama'],
    alamat: map['alamat'],
    email: map['email'],
    userName: map['owner_name'],
    password: map['password'],
  );

  Map<String, dynamic> toMap() => {
    "logo_toko": logoToko,
    "nama": namaUsaha,
    "alamat": alamat,
    "email": email,
    "owner_name": userName,
    "password": password,
  };
}
