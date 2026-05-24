import 'dart:convert';

class ProdukModel {
  int? id;
  String? namaProduk;
  List<String>? tag;
  double? stok;
  List<ProdukSatModel> lstSatuan;

  ProdukModel({
    this.id,
    this.namaProduk,
    this.tag = const [],
    this.stok,
    this.lstSatuan = const [],
  });

  factory ProdukModel.fromMap(Map<String, dynamic> map) => ProdukModel(
    id: map['id'],
    namaProduk: map['nama_item'],
    tag: List.from(jsonDecode(map['tag'])),
    stok: map['stok'],
    lstSatuan: map['satuan'] != null
        ? List<ProdukSatModel>.from(
            map['satuan'].map((e) => ProdukSatModel.fromMap(e)),
          )
        : [],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama_item": namaProduk,
    "tag": jsonEncode(tag),
    "stok": stok,
    "satuan": jsonEncode(lstSatuan.map((e) => e.toMap()).toList()),
  };
}

class ProdukSatModel {
  int? id;
  int? idProduk;
  String? satuan;
  String? barcode;
  double? harga;
  double? diskon;

  ProdukSatModel({
    this.id,
    this.idProduk,
    this.satuan,
    this.barcode,
    this.harga,
    this.diskon,
  });

  factory ProdukSatModel.fromMap(Map<String, dynamic> map) => ProdukSatModel(
    id: map['id'],
    idProduk: map['id_produk'],
    satuan: map['satuan'],
    barcode: map['barcode'],
    harga: map['harga'],
    diskon: map['diskon'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_produk": idProduk,
    "satuan": satuan,
    "barcode": barcode,
    "harga": harga,
    "dusko": diskon,
  };
}
