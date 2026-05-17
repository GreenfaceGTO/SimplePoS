import 'package:simplepos/data/database/dbmanager.dart';
import 'package:simplepos/data/database/table_scheme.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class UsahaDao {
  // =========Mengambil data usaha=========
  Future<UsahaModel?> getDataUsaha() async {
    final db = await Dbmanager.database;
    try {
      final result = await db.query(TableScheme.tbUsaha, limit: 1);
      if (result.isEmpty) {
        return null;
      }
      return UsahaModel.fromMap(result[0]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
