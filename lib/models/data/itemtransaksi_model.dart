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
        namaProduk: map['nama_satuan'],
        isi: map['isi'],
        harga: map['harga'],
        qty: map['qty'],
        diskon: map['diskon'],
      );

  factory ItemtransaksiModel.fromProdukSat(ProdukSatModel item) =>
      ItemtransaksiModel(
        namaSatuan: item.satuan,
        isi: item.isi,
        harga: item.hJual,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_header": idTransaksi,
    "id_item": idProduk,
    "nama_satuan": namaSatuan,
    "isi": isi,
    "harga": harga,
    "qty": qty,
    "diskon": diskon,
  };
}
