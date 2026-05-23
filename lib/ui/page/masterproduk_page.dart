import 'package:flutter/material.dart';

class MasterprodukPage extends StatefulWidget {
  const MasterprodukPage({super.key});

  @override
  State<MasterprodukPage> createState() => _MasterprodukPageState();
}

class _MasterprodukPageState extends State<MasterprodukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Master Produk")),
      body: Center(child: Text("Master Produk Page")),
    );
  }
}
