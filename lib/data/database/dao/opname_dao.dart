import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/itemopname_model.dart';
import 'package:simplepos/models/data/opname_model.dart';
import 'package:simplepos/models/data/produk_model.dart';

class OpnameDao {
  // ------------------------------------------------------------------
  // Mengambil daftar riwayat opname periode ini, baik yang selesai
  // maupun yang belum
  // ------------------------------------------------------------------
  Future<List<OpnameModel>> fetchOpnameHistory(int? tahun, int? bulan) async {
    final db = await Dbmanager.database;
    final today = DateTime.now();
    tahun ??= today.year;
    bulan ??= today.month;
    DateTime awal = DateTime(tahun, bulan, 1);
    DateTime akhir = DateTime(tahun, bulan + 1, 1);

    try {
      final data = await db.query(
        TableScheme.tbOpnameHd,
        where: "tanggal>=? AND tanggal<?",
        whereArgs: [awal.toIso8601String(), akhir.toIso8601String()],
        orderBy: "tanggal DESC",
      );

      if (data.isNotEmpty) {
        List<OpnameModel> lstData = data
            .map((e) => OpnameModel.fromMap(e))
            .toList();

        for (var opname in lstData) {
          final detail = await db.query(
            TableScheme.tbOpnameDt,
            where: "id_header=?",
            whereArgs: [opname.id],
          );
          opname.lstDetail = List.from(
            detail.map((d) => ItemopnameModel.fromMap(d)),
          );

          // mengisi properti nama produk dari tabel item
          for (var dtl in opname.lstDetail!) {
            dtl.namaProduk = await getProductName(dtl.idProduk!);
          }
        }
        return lstData;
      }
    } catch (e) {
      Exception(e.toString());
    }
    return [];
  }

  // ------------------------
  // Membuat data opname
  // ------------------------
  Future<OpnameModel?> createOpname(OpnameModel data) async {
    final db = await Dbmanager.database;
    try {
      return await db.transaction((txn) async {
        // simpan header
        final idHeader = await txn.insert(
          TableScheme.tbOpnameHd,
          data.toDbMap(),
        );
        data.id = idHeader;

        // menyimpan data detail
        for (var item in data.lstDetail!) {
          item.idHeader = idHeader;
          final idDetail = await txn.insert(
            TableScheme.tbOpnameDt,
            item.toDbMap(),
          );
          item.id = idDetail;
        }
        return data;
      });
    } catch (e) {
      Exception(e.toString());
    }
    return null;
  }

  // -------------------------------------------
  // Mengambil nama item dari tabel produk
  // -------------------------------------------
  Future<String> getProductName(int id) async {
    final db = await Dbmanager.database;
    final result = await db.query(
      TableScheme.tbItem,
      where: "id=?",
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return "Produk tidak ada di master";
    }
    return result.map((e) => ProdukModel.fromMap(e)).first.namaProduk!;
  }

  // ------------------------------------------------------------------------
  // Mengambil daftar produk untuk proses cut off stok opname. Item yang
  // diambil adalah item yang belum pernah diopname dalam periode berjalan
  // ------------------------------------------------------------------------
  Future<List<ProdukModel>> getNonIraProduk() async {
    final db = await Dbmanager.database;
    // simpan tanggal hari ini untuk menentukan periode data
    final today = DateTime.now();

    // tahun dan bulan dikonversikan ke tipe string
    final tahun = today.year;
    final bulan = today.month;
    try {
      final result = await db.rawQuery(
        """SELECT * FROM ${TableScheme.tbItem} p WHERE NOT EXISTS (SELECT 1 FROM ${TableScheme.tbOpnameHd} h INNER JOIN ${TableScheme.tbOpnameDt} d ON d.id_header=h.id WHERE d.id_item=p.id AND strftime('%Y', h.tanggal)=? AND strftime('%m',h.tanggal)=?) ORDER BY p.nama_item""",
        [tahun.toString(), bulan.toString().padLeft(2, '0')],
      );
      if (result.isEmpty) return [];
      List<ProdukModel> lstProduk = List.from(
        result.map((e) => ProdukModel.fromMap(e)),
      );
      return lstProduk;
    } catch (e) {
      Exception(e.toString());
    }
    return [];
  }
}
