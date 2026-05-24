import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key, required this.args});
  final ArgsModel args;
  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Daftar Kategori")),
          floatingActionButton: widget.args.formMode == FormMode.browse
              ? null
              : FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
          body: prov.daftarKategori.isEmpty
              ? Center(child: EmptydataElement())
              : ListView(
                  children: prov.daftarKategori.map((kat) {
                    return ListTile(title: Text(kat));
                  }).toList(),
                ),
        );
      },
    );
  }
}
