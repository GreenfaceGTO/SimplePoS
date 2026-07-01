import 'package:simplepos/models/data/produksat_model.dart';

class ItemtransaksiModel {
  int? id;
  int? idTransaksi;
  int? idProduk;
  String? namaProduk;
  int? idSatuan;

  String? namaSatuan;
  int? isi;
  double? harga;
  int? qty;
  double? diskon;

  ItemtransaksiModel({
    this.id,
    this.idTransaksi,
    this.idProduk,
    this.namaProduk,
    this.idSatuan,
    this.namaSatuan,
    this.isi,
    this.harga,
    this.qty,
    this.diskon,
  });

  factory ItemtransaksiModel.fromMap(Map<String, dynamic> map) =>
      ItemtransaksiModel(
        id: map['id'],
        idTransaksi: map['id_header'],
        idProduk: map["id_item"],
        namaProduk: map['nama_item'],
        idSatuan: map['id_satuan'],
        namaSatuan: map['nama_satuan'],
        isi: map['isi'],
        harga: map['harga'],
        qty: map['qty'],
        diskon: map['diskon'],
      );

  factory ItemtransaksiModel.fromProdukSat(ProdukSatModel item) =>
      ItemtransaksiModel(
        namaSatuan: item.satuan,
        isi: item.isi,
        idSatuan: item.id,
        harga: item.hJual,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_header": idTransaksi,
    "id_item": idProduk,
    "nama_item": namaProduk,
    "id_satuan": idSatuan,
    "nama_satuan": namaSatuan,
    "isi": isi,
    "harga": harga,
    "qty": qty,
    "diskon": diskon,
  };

  ItemtransaksiModel copyWith({
    int? id,
    int? idTransaksi,
    int? idProduk,
    String? namaProduk,
    int? idSatuan,
    String? namaSatuan,
    int? isi,
    double? harga,
    int? qty,
    double? diskon,
  }) {
    return ItemtransaksiModel(
      id: id ?? this.id,
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idProduk: idProduk ?? this.idProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      idSatuan: idSatuan ?? this.idSatuan,
      namaSatuan: namaSatuan ?? this.namaSatuan,
      isi: isi ?? this.isi,
      harga: harga ?? this.harga,
      qty: qty ?? this.qty,
      diskon: diskon ?? this.diskon,
    );
  }
}
