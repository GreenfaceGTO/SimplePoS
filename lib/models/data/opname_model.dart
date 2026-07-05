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

  Map<String, dynamic> toMap() => {
    "id": id,
    "tanggal": tanggal,
    "keterangan": keterangan,
  };
}
