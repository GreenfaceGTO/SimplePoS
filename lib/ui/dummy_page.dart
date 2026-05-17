import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key, required this.caption});
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(caption)));
  }
}
