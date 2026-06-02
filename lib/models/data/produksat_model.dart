class ProdukSatModel {
  int? id;
  int? idProduk;
  String? satuan;
  int isi;
  String? barcode;
  String? tipe;
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
    this.tipe,
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
    tipe: map['tipe'],
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
    "tipe": tipe,
    "h_pokok": hPokok,
    "h_jual": hJual,
    "pot_kemasan": diskon,
    "stok": stok,
  };

  Map<String, dynamic> toDb() => {
    "id": id,
    "id_produk": idProduk,
    "satuan": satuan,
    "isi": isi,
    "barcode": barcode,
    "tipe": tipe,
    "h_pokok": hPokok,
    "h_jual": hJual,
    "pot_kemasan": diskon,
  };

  ProdukSatModel copyWith({
    int? id,
    int? idProduk,
    String? satuan,
    int? isi,
    String? barcode,
    String? tipe,
    double? hPokok,
    double? hJual,
    double? diskon,
    int? stok,
  }) {
    return ProdukSatModel(
      id: id ?? this.id,
      idProduk: idProduk ?? this.idProduk,
      satuan: satuan ?? this.satuan,
      isi: isi ?? this.isi,
      barcode: barcode ?? this.barcode,
      tipe: tipe ?? this.tipe,
      hPokok: hPokok ?? this.hPokok,
      hJual: hJual ?? this.hJual,
      diskon: diskon ?? this.diskon,
      stok: stok ?? this.stok,
    );
  }

  bool compare(ProdukSatModel other) {
    return satuan == other.satuan &&
        isi == other.isi &&
        barcode == other.barcode &&
        hPokok == other.hPokok &&
        hJual == other.hJual;
  }
}
