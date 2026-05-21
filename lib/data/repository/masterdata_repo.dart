import 'package:simplepos/data/database/dao/usaha_dao.dart';
import 'package:simplepos/models/data/usaha_model.dart';

class MasterdataRepo {
  final UsahaDao usahaDao;

  MasterdataRepo({required this.usahaDao});

  // =======Menyimpan data usaha=======
  Future<void> saveDataUsaha(UsahaModel data) async {
    try {
      await usahaDao.saveUsaha(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  // =========Mengambil data usaha=========
  Future<UsahaModel?> getDataUsaha() async {
    try {
      return await usahaDao.getDataUsaha();
    } catch (e) {
      throw Exception(e);
    }
  }
}
