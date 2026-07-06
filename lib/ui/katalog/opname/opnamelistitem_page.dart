import 'dart:developer';

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
                  backgroundColor: Colors.teal,
                  elevation: 3,
                  contentTextStyle: TextStyle(color: Colors.white),
                  leading: Icon(Icons.info_outline, color: Colors.white),
                  content: Text("Input dengan menggunakan satuan dasar"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showInfo = false;
                        });
                      },
                      child: Text("OK", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              Expanded(
                child: SizedBox(
                  child: ListView.separated(
                    itemBuilder: (context, idx) {
                      var data = prov.currentTask!.lstDetail![idx];
                      return ListTile(
                        onTap: () {
                          log("hitung");
                        },
                        title: Text(data.namaProduk!),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Stok Sistem: ${data.stokSistem.toString()}"),
                            Text("Stok Fisik: ${data.stokFisik.toString()}"),
                          ],
                        ),
                        trailing: Icon(Icons.summarize_outlined),
                      );
                    },
                    separatorBuilder: (context, idx) {
                      return Divider();
                    },
                    itemCount: prov.currentTask!.lstDetail!.length,
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
