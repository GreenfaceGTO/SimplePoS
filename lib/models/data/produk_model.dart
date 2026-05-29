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
  int isi;
  String? barcode;
  double? hPokok;
  double? hJual;
  double diskon;
  int? stok;

  ProdukSatModel({
    this.id,
    this.idProduk,
    this.satuan,
    this.isi = 0,
    this.barcode,
    this.hPokok,
    this.hJual,
    this.diskon = 0,
    this.stok,
  });

  factory ProdukSatModel.fromMap(Map<String, dynamic> map) => ProdukSatModel(
    id: map['id'],
    idProduk: map['id_produk'],
    satuan: map['satuan'],
    isi: map['isi'],
    barcode: map['barcode'],
    hPokok: map['h_pokok'],
    hJual: map['h_jual'],
    diskon: map['pot_kemasan'],
    stok: map['stok'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_produk": idProduk,
    "satuan": satuan,
    "isi": isi,
    "barcode": barcode,
    "h_pokok": hPokok,
    "h_jual": hJual,
    "pot_kemasan": diskon,
    "stok": stok,
  };
}
