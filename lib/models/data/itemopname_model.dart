import 'package:simplepos/models/data/produk_model.dart';

class ItemopnameModel {
  int? id;
  int? idHeader;
  int? idProduk;
  String? namaProduk;
  int? stokSistem;
  int? stokFisik;

  ItemopnameModel({
    this.id,
    this.idHeader,
    this.idProduk,
    this.namaProduk,
    this.stokSistem,
    this.stokFisik,
  });

  factory ItemopnameModel.fromMap(Map<String, dynamic> map) => ItemopnameModel(
    id: map['id'],
    idHeader: map['id_header'],
    namaProduk: map['nama_item'],
    idProduk: map['id_item'],
    stokSistem: map['stok_sistem'],
    stokFisik: map['stok_fisik'],
  );

  factory ItemopnameModel.fromProduk(ProdukModel data) => ItemopnameModel(
    idProduk: data.id,
    stokSistem: data.stok,
    stokFisik: 0,
    namaProduk: data.namaProduk,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_header": idHeader,
    "id_item": idProduk,
    "nama_item": namaProduk,
    "stok_sistem": stokSistem,
    "stok_fisik": stokFisik,
  };
  Map<String, dynamic> toDbMap() => {
    "id": id,
    "id_header": idHeader,
    "id_item": idProduk,
    "stok_sistem": stokSistem,
    "stok_fisik": stokFisik,
  };
}
