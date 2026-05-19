class TableScheme {
  static const tbUsaha = "tb_usaha";
  static const tbItem = "tb_item";
  static const tbTranshd = "tb_transhd";
  static const tbTransdt = "tb_transdt";

  static const createTbUsaha = '''CREATE TABLE $tbUsaha (
    nama          TEXT,
    alamat        TEXT,
    owner_name    TEXT,
    email         TEXT,
    password,
    reseller_code TEXT (6),
    logo_toko     TEXT
);

''';

  static const createTbItem = '''CREATE TABLE $tbItem (
    id        INTEGER PRIMARY KEY,
    nama_item TEXT    CONSTRAINT nama_item UNIQUE,
    barcode   TEXT    UNIQUE,
    tag       TEXT,
    harga     REAL,
    stok      INTEGER
);
''';

  static const createTbTranshd = '''CREATE TABLE $tbTranshd (
    id      INTEGER PRIMARY KEY,
    tanggal TEXT,
    tipe    TEXT    CHECK (tipe IN ("beli", "jual") ),
    total   REAL,
    bayar   REAL,
    kembali REAL,
    status          CHECK (status IN ("pending", "selesai", "batal") ) 
);
''';

  static const createTbTransdt = '''CREATE TABLE $tbTransdt (
    id        INTEGER PRIMARY KEY,
    id_header INTEGER REFERENCES tb_transhd (id) ON DELETE CASCADE
                      CONSTRAINT [id_header,id_item] UNIQUE,
    id_item   INTEGER REFERENCES tb_item (id),
    qty       INTEGER,
    harga     REAL
);
''';
}
