import 'package:flutter/material.dart';

class ProdukTabpage extends StatefulWidget {
  const ProdukTabpage({super.key});

  @override
  State<ProdukTabpage> createState() => _ProdukTabpageState();
}

class _ProdukTabpageState extends State<ProdukTabpage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Produk Tab Page"));
  }
}
