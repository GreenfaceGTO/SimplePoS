import 'package:simplepos/models/data/itemopname_model.dart';

class OpnameModel {
  int? id;
  String? tanggal;
  String? keterangan;
  List<ItemopnameModel>? lstDetail;

  OpnameModel({
    this.id,
    this.tanggal,
    this.keterangan,
    List<ItemopnameModel>? lstDetail,
  }) : lstDetail = lstDetail ?? [];

  factory OpnameModel.fromMap(Map<String, dynamic> map) => OpnameModel(
    id: map['id'],
    tanggal: map['tanggal'],
    keterangan: map['keterangan'],
    lstDetail: map['detail'] != null
        ? List<ItemopnameModel>.from(
            map['detail'].map((e) => ItemopnameModel.fromMap(e)),
          )
        : [],
  );

  Map<String, dynamic> toDbMap() => {
    "id": id,
    "tanggal": tanggal,
    "keterangan": keterangan,
  };
  Map<String, dynamic> toMap() => {
    "id": id,
    "tanggal": tanggal,
    "keterangan": keterangan,
    "detail": lstDetail!.map((e) => e.toMap()).toList(),
  };

  /// Memeriksa apakah seluruh perhitungan sudah dilakukan (tidak ada lagi stokfisik yang null)
  bool isComplete() {
    return lstDetail!.any((e) => e.stokFisik == null);
  }

  // Mengembalikan jumlah item selesai dan yang belum dihitung
  Map<String, dynamic> progress() => {
    "complete": lstDetail!
        .where((e) => e.stokFisik != null && e.stokFisik! > 0)
        .length,
    "uncomplete": lstDetail!.where((e) => e.stokFisik == 0).length,
  };
}
