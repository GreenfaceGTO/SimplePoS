class TableScheme {
  static const tbUsaha = "tb_usaha";
  static const tbItem = "tb_item";
  static const tbItemSat = "tb_itemsat";
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
    tag       TEXT,
    stok      INTEGER
);

''';

  static const createTbItemSat = '''CREATE TABLE $tbItemSat (
    id          INTEGER   PRIMARY KEY,
    id_produk   INTEGER   REFERENCES tb_item (id) ON DELETE CASCADE,
    satuan      TEXT (10),
    isi         INTEGER,
    barcode     TEXT,
    tipe        TEXT (1)  CHECK (tipe IN ('D', 'K') ),
    h_pokok     REAL,
    h_jual      REAL,
    pot_kemasan REAL,

    UNIQUE(id_produk, satuan)
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
    harga     REAL,
    diskon    REAL
);

''';
}
