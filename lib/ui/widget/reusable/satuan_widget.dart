import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/enums.dart';

class SatuanWidget extends StatelessWidget {
  const SatuanWidget({super.key, required this.args});
  final ArgsModel args;
  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(
      builder: (context, prov, _) {
        return ListView(
          children: prov.daftarSatuan.map((sat) {
            return ListTile(
              onTap: args.formMode == FormMode.browse ? () {} : null,
              title: Text(sat),
            );
          }).toList(),
        );
      },
    );
  }
}
