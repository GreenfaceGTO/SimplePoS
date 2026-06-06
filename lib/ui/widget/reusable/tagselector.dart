import 'package:flutter/material.dart';

class Tagselector extends StatelessWidget {
  const Tagselector({
    super.key,
    required this.tags,
    this.selectedTag,
    required this.onChange,
    this.showViewAll = true,
  });
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onChange;
  final bool showViewAll;

  @override
  Widget build(BuildContext context) {
    final items = showViewAll ? ["Semua..", ...tags] : tags;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final isShowAll = items[index] == "Semua";
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(items[index]),
            selected: isShowAll
                ? selectedTag == null
                : selectedTag == items[index],
            onSelected: (_) {
              onChange(isShowAll ? null : items[index]);
            },
          ),
        );
      },
    );
  }
}
