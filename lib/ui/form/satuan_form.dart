import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/providers/master_provider.dart';

class SatuanForm extends StatefulWidget {
  const SatuanForm({super.key, required this.args});
  final ArgsModel args;

  @override
  State<SatuanForm> createState() => _SatuanFormState();
}

class _SatuanFormState extends State<SatuanForm> {
  String tipe = 'D'; //tipe satuan dasar
  String? namaItem;

  @override
  void initState() {
    namaItem = widget.args.data['nama_item'];
    if (widget.args.data['sat_dasar'] != null) {
      tipe = "K";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tipe == 'D' ? "Satuan Dasar" : "Satuan Lain")),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            width: double.infinity,
            // padding: EdgeInsets.all(12),
            // color: Colors.blueGrey.shade200,
            child: ListTile(
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: -4),
              // dense: true,
              title: Text("Nama Produk", style: tema.textTheme.bodySmall),
              subtitle: Text(namaItem!, style: tema.textTheme.titleMedium),
            ),
            // Text(namaItem!, style: TextStyle(color: Colors.red)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Consumer<MasterProvider>(
                  builder: (context, prov, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            items: prov.daftarSatuan.map((sat) {
                              return DropdownMenuItem(child: Text(sat));
                            }).toList(),
                            onChanged: (val) {},
                            hint: Text(
                              tipe == 'D' ? "Satuan Dasar" : "Satuan Lain",
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_circle,
                            size: 18,
                            color: tema.primaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
