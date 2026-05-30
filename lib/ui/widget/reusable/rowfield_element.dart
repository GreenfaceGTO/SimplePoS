import 'package:flutter/material.dart';

class CustomRowField extends StatelessWidget {
  const CustomRowField({super.key, required this.title, required this.value});
  final String title;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: tema.textTheme.bodyMedium)),
          value,
        ],
      ),
    );
  }
}
