import 'dart:convert';

class ProdukModel {
  int? id;
  String? namaProduk;
  String? barcode;
  List<String>? tag;
  double? stok;
  List<ProdukSatModel> lstSatuan;

  ProdukModel({
    this.id,
    this.namaProduk,
    this.barcode,
    this.tag,
    this.stok,
    this.lstSatuan = const [],
  });

  factory ProdukModel.fromMap(Map<String, dynamic> map) => ProdukModel(
    id: map['id'],
    namaProduk: map['nama_item'],
    barcode: map['barcode'],
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
    "barcode": barcode,
    "tag": jsonEncode(tag),
    "stok": stok,
    "satuan": jsonEncode(lstSatuan.map((e) => e.toMap()).toList()),
  };
}

class ProdukSatModel {
  int? id;
  int? idProduk;
  String? satuan;
  double? harga;
  double? diskon;

  ProdukSatModel({
    this.id,
    this.idProduk,
    this.satuan,
    this.harga,
    this.diskon,
  });

  factory ProdukSatModel.fromMap(Map<String, dynamic> map) => ProdukSatModel(
    id: map['id'],
    idProduk: map['id_produk'],
    satuan: map['satuan'],
    harga: map['harga'],
    diskon: map['diskon'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_produk": idProduk,
    "satuan": satuan,
    "harga": harga,
    "dusko": diskon,
  };
}
