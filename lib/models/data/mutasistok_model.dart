class MutasistokModel {
  int? id;
  String? tanggal;
  String? keterangan;
  String? pos;
  int? idTransaksi;
  int? idProduk;
  int? idSatuan;
  int? qty;
  double? nilai;

  MutasistokModel({
    this.id,
    this.tanggal,
    this.keterangan,
    this.pos,
    this.idTransaksi,
    this.idProduk,
    this.idSatuan,
    this.qty,
    this.nilai,
  });

  factory MutasistokModel.fromMap(Map<String, dynamic> map) => MutasistokModel(
    id: map['id'],
    tanggal: map['tanggal'],
    keterangan: map['keterangan'],
    pos: map['pos_tipe'],
    idTransaksi: map['id_transaksi'],
    idProduk: map['id_item'],
    idSatuan: map['id_satuan'],
    qty: map['qty'],
    nilai: map['nilai'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "tanggal": tanggal,
    "keterangan": keterangan,
    "pos_tipe": pos,
    "id_transaksi": idTransaksi,
    "id_item": idProduk,
    "id_satuan": idSatuan,
    "qty": qty,
    "nilai": nilai,
  };
}
