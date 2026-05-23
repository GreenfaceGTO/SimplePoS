import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptydataElement extends StatelessWidget {
  const EmptydataElement({
    super.key,
    this.caption = "Belum ada data",
    this.iconSize = 50,
  });
  final String caption;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          FontAwesomeIcons.database,
          size: iconSize,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 8),
        Text(
          caption,
          style: tema.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
