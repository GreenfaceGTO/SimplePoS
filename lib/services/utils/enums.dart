enum FormMode { input, view, update, browse }

enum ButtonType { elevated, outlined, text }

enum OrientationMode { vertical, horizontal }

enum MessageMode { warning, info, error }

/// Pilihan mode halaman produk.
///
/// [browser] : mode pilih untuk diinput sebagai penjualan,
/// [master] : mode manajemen produk (tambah, edit, hapus),
/// [pembelian] : mode pilih untuk diinput sebagai pembelian,
/// [opname] : mode pilih untuk diinput sebagai data opname
enum ProdukPageMode { browser, master, pembelian, opname }
