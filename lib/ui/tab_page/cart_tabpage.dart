import 'package:flutter/material.dart';

class CartTabpage extends StatefulWidget {
  const CartTabpage({super.key});

  @override
  State<CartTabpage> createState() => _CartTabpageState();
}

class _CartTabpageState extends State<CartTabpage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Cart Tab Page"));
  }
}
