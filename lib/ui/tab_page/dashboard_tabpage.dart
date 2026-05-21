import 'package:flutter/material.dart';

class DashboardTabpage extends StatefulWidget {
  const DashboardTabpage({super.key});

  @override
  State<DashboardTabpage> createState() => _DashboardTabpageState();
}

class _DashboardTabpageState extends State<DashboardTabpage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Dashboard Tab Page"));
  }
}
