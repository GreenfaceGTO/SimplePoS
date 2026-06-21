class SaldoModel {
  int? id;
  String? tanggal;
  String? pos;
  double? nilai;
  String? keterangan;

  SaldoModel({this.id, this.tanggal, this.pos, this.nilai, this.keterangan});

  factory SaldoModel.fromMap(Map<String, dynamic> map) => SaldoModel(
    id: map['id'],
    tanggal: map['tanggal'],
    pos: map['pos_tipe'],
    nilai: map['nilai'],
    keterangan: map['keterangan'],
  );

  Map<String, dynamic> toMap() => {
    "id": null,
    "tanggal": tanggal,
    "pos_tipe": pos,
    "nilai": nilai,
    "keterangan": keterangan,
  };
}
