import 'package:simplepos/services/utils/enums.dart';

class ArgsModel {
  final FormMode formMode;
  final dynamic data;

  ArgsModel({required this.formMode, this.data});

  factory ArgsModel.fromMap(Map<String, dynamic> map) =>
      ArgsModel(formMode: map['mode'], data: map['data']);

  Map<String, dynamic> toMap() => {"mode": formMode, "data": data};
}
