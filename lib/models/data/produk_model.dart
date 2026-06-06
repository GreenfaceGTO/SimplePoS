import 'dart:convert';
import 'dart:developer';

import 'package:simplepos/models/data/produksat_model.dart';

class ProdukModel {
  int? id;
  String? namaProduk;
  List<String>? tag;
  int? stok;
  List<ProdukSatModel>? lstSatuan;

  ProdukModel({
    this.id,
    this.namaProduk,
    List<String>? tag,
    this.stok,
    List<ProdukSatModel>? lstSatuan,
  }) : tag = tag ?? [],
       lstSatuan = lstSatuan ?? [];

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
    "satuan": jsonEncode(lstSatuan!.map((e) => e.toMap()).toList()),
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "nama_item": namaProduk,
    "tag": jsonEncode(tag),
    "stok": stok,
  };

  ProdukModel copyWith({
    int? id,
    String? namaProduk,
    List<String>? tag,
    int? stok,
    List<ProdukSatModel>? lstSatuan,
  }) {
    return ProdukModel(
      id: id ?? this.id,
      namaProduk: namaProduk ?? this.namaProduk,
      tag: tag ?? List<String>.from(this.tag!),
      stok: stok ?? this.stok,
      lstSatuan: lstSatuan ?? this.lstSatuan!.map((e) => e.copyWith()).toList(),
    );
  }

  ProdukSatModel? getSatuanDasar() {
    try {
      return lstSatuan!.firstWhere((e) => e.tipe == 'D');
    } catch (_) {
      return null;
    }
  }

  bool compare(ProdukModel other) {
    if (id != other.id) return false;
    if (namaProduk != other.namaProduk) return false;

    if (tag!.length != other.tag!.length) return false;
    for (int i = 0; i < tag!.length; i++) {
      if (!tag!.contains(other.tag![i])) return false;
    }
    if (lstSatuan!.length != other.lstSatuan!.length) return false;
    for (int i = 0; i < lstSatuan!.length; i++) {
      if (!lstSatuan![i].compare(other.lstSatuan![i])) {
        return false;
      }
    }
    log("sama");
    return true;
  }

  ProdukModel clear() => ProdukModel();
}
