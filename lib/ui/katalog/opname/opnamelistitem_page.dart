import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/opname_provider.dart';

class OpnamelistitemPage extends StatefulWidget {
  const OpnamelistitemPage({super.key});

  @override
  State<OpnamelistitemPage> createState() => _OpnamelistitemPageState();
}

class _OpnamelistitemPageState extends State<OpnamelistitemPage> {
  bool _showInfo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stok Opname")),
      body: Consumer<OpnameProvider>(
        builder: (context, prov, _) {
          return Column(
            children: [
              if (_showInfo)
                MaterialBanner(
                  content: Text("Perhitungan harus menggunakan satuan dasar"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showInfo = false;
                        });
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              Expanded(
                child: SizedBox(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: prov.currentTask!.lstDetail!.map((item) {
                      return Column(children: [Text(item.namaProduk!)]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
