class TableScheme {
  static const tbUsaha = "tb_usaha";
  static const tbItem = "tb_item";
  static const tbItemSat = "tb_itemsat";
  static const tbTranshd = "tb_transhd";
  static const tbTransdt = "tb_transdt";
  static const tbMutasiStok = 'tb_mutasistok';
  static const tbSaldo = 'tb_saldo';

  static const createTbUsaha = '''CREATE TABLE $tbUsaha (
    kode_usaha    TEXT,
    tgl_register  TEXT,
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
    id         INTEGER PRIMARY KEY,
    tanggal    TEXT,
    tipe       TEXT    CHECK (tipe IN ("beli", "jual") ),
    total      REAL,
    cara_bayar TEXT    CHECK (cara_bayar IN ('tunai', 'qris') ),
    bayar      REAL,
    kembali    REAL,
    status     TEXT    CHECK (status IN ("draft", "pending", "selesai", "batal") ),
    catatan    TEXT
);
''';

  static const createTbTransdt = '''CREATE TABLE $tbTransdt (
    id          INTEGER PRIMARY KEY,
    id_header   INTEGER REFERENCES tb_transhd (id) ON DELETE CASCADE,
    id_item     INTEGER REFERENCES tb_item (id),
    nama_item   TEXT,
    id_satuan   INTEGER REFERENCES tb_itemsat (id),
    nama_satuan TEXT,
    isi         INTEGER,
    harga       REAL,
    qty         INTEGER,
    diskon      REAL,
    UNIQUE (id_header,id_item)
);
''';

  static const createTbMutasiStok = '''CREATE TABLE $tbMutasiStok (
    id           INTEGER,
    tanggal      TEXT,
    keterangan   TEXT,
    pos_tipe     TEXT    CHECK (pos_tipe IN ('IN', 'OUT') ) 
                         DEFAULT OUT,
    id_transaksi INTEGER REFERENCES tb_transhd (id) ON DELETE CASCADE,
    id_item      INTEGER REFERENCES tb_item (id) ON DELETE CASCADE,
    id_satuan    INTEGER REFERENCES tb_itemsat (id) ON DELETE CASCADE,
    qty          INTEGER,
    nilai        REAL
);
''';

  static const createTbsaldo = '''CREATE TABLE $tbSaldo (
    id        INTEGER,
    tanggal    TEXT,
    pos_tipe   TEXT    CHECK (pos_tipe IN ('D', 'K') ) 
                       DEFAULT K,
    nilai      REAL,
    keterangan TEXT
);
''';
}
