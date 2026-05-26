import 'package:flutter/material.dart';

class ProfilTabpage extends StatefulWidget {
  const ProfilTabpage({super.key});

  @override
  State<ProfilTabpage> createState() => _ProfilTabpageState();
}

class _ProfilTabpageState extends State<ProfilTabpage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profil Tab Page"));
  }
}
