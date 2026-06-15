import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    this.disabled = false,
    required this.value,
    required this.tambah,
    required this.kurang,
  });
  final bool disabled;
  final int value;
  final VoidCallback? tambah;
  final VoidCallback? kurang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: disabled ? null : kurang,
            child: Icon(
              Icons.remove_circle_outline,
              size: 18,
              color: disabled
                  ? Colors.grey.shade400
                  : (kurang != null ? Colors.red : Colors.grey.shade400),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 4, right: 4),
            padding: const EdgeInsets.only(left: 8, right: 8),
            // color: Colors.grey.shade300,
            child: Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: disabled ? Colors.grey.shade400 : null,
              ),
            ),
          ),
          InkWell(
            onTap: disabled ? null : tambah,
            child: Icon(
              Icons.add_circle_outline,
              size: 18,
              color: disabled
                  ? Colors.grey.shade400
                  : (tambah != null ? Colors.teal : Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
