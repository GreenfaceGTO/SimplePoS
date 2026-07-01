import 'dart:convert';

import 'package:simplepos/models/data/itemtransaksi_model.dart';

class TransaksiModel {
  int? id;
  String? tanggal;
  String? tipe;
  double? total;
  String? caraBayar;
  double? bayar;
  double? kembali;
  String? status;
  String? catatan;
  List<ItemtransaksiModel> lstDetail;

  TransaksiModel({
    this.id,
    this.tanggal,
    this.tipe,
    this.total,
    this.caraBayar,
    this.bayar,
    this.kembali,
    this.status,
    this.catatan,
    List<ItemtransaksiModel>? lstDetail,
  }) : lstDetail = lstDetail ?? [];

  factory TransaksiModel.fromMap(Map<String, dynamic> map) => TransaksiModel(
    id: map['id'],
    tanggal: map['tanggal'],
    tipe: map['tipe'],
    total: map['total'],
    caraBayar: map['cara_bayar'],
    bayar: map['bayar'],
    kembali: map['kembali'],
    status: map['status'],
    catatan: map['catatan'],
    lstDetail: map['detail'] != null
        ? List<ItemtransaksiModel>.from(
            map['detail'].map((e) => ItemtransaksiModel.fromMap(e)),
          )
        : [],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "tanggal": tanggal,
    "tipe": tipe,
    "total": total,
    "cara_bayar": caraBayar,
    "bayar": bayar,
    "kembali": kembali,
    "status": status,
    "catatan": catatan,
    "detail": jsonEncode(lstDetail.map((e) => e.toMap()).toList()),
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "tanggal": tanggal,
    "tipe": tipe,
    "total": total,
    "cara_bayar": caraBayar,
    "bayar": bayar,
    "kembali": kembali,
    "status": status,
    "catatan": catatan,
  };

  TransaksiModel copyWith({
    int? id,
    String? tanggal,
    String? tipe,
    double? total,
    String? caraBayar,
    double? bayar,
    double? kembali,
    String? status,
    String? catatan,
    List<ItemtransaksiModel>? lstDetail,
  }) {
    return TransaksiModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      tipe: tipe ?? this.tipe,
      total: total ?? this.total,
      caraBayar: caraBayar ?? this.caraBayar,
      bayar: bayar ?? this.bayar,
      kembali: kembali ?? this.kembali,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
      lstDetail: lstDetail ?? this.lstDetail.map((e) => e.copyWith()).toList(),
    );
  }
}
