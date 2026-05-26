import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/ui/widget/reusable/emptydata_element.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key, required this.currentTag});
  final List<String> currentTag;
  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  /// variabel untuk menyalin data kategori yang dikumpulkan provider dari data produk.
  /// data pada variabel ini nantinya akan disatukan dengan data dari widget.currentTag
  /// yang dikirim dari halaman pemanggil.
  List<String> localKategori = [];

  /// variabel penampung kategori yang dipilih.
  List<String> selectedTag = [];

  @override
  void initState() {
    localKategori.addAll(context.read<MasterProvider>().daftarKategori);
    if (widget.currentTag.isNotEmpty) {
      selectedTag.addAll(widget.currentTag);
      for (var kat in widget.currentTag) {
        if (!localKategori.contains(kat)) {
          localKategori.add(kat);
        }
      }
    }
    localKategori.sort((a, b) => a.compareTo(b));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Daftar Kategori"),
            actions: selectedTag.isNotEmpty
                ? [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, selectedTag);
                      },
                      child: Text("OK"),
                    ),
                  ]
                : [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String? kat = await PublicWidget.showRefForm(
                context,
                title: "Kategori",
              );
              if (kat != null) {
                if (!localKategori.contains(kat)) {
                  setState(() {
                    localKategori.add(kat);
                    localKategori.sort((a, b) => a.compareTo(b));
                  });
                }
              }
            },
            child: Icon(Icons.add),
          ),
          body: localKategori.isEmpty
              ? Center(child: EmptydataElement())
              : ListView(
                  children: localKategori.map((kat) {
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: selectedTag.contains(kat),
                      title: Text(kat),
                      onChanged: (val) {
                        if (val!) {
                          setState(() {
                            selectedTag.add(kat);
                          });
                        } else {
                          setState(() {
                            selectedTag.removeWhere((e) => e == kat);
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}
