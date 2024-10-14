import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  const Tag({super.key});

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  String? selectedTag;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Jarak horizontal antar chips
      runSpacing: 8, // Jarak vertical antar chips
      alignment: WrapAlignment.start,
      children: [
        FilterChip(
          label: const Text('Pengabdian'),
          selected: selectedTag == 'Pengabdian', 
          onSelected: (bool value) {
            setState(() {
              selectedTag = value ? 'Pengabdian' : null;
            });
          },
        ),
        FilterChip(
          label: const Text('Penelitian'),
          selected: selectedTag == 'Penelitian',
          onSelected: (bool value) {
            setState(() {
              selectedTag = value ? 'Penelitian' : null;
            });
          },
        ),
        FilterChip(
          label: const Text('Teknis'),
          selected: selectedTag == 'Teknis',
          onSelected: (bool value) {
            setState(() {
              selectedTag = value ? 'Teknis' : null;
            });
          },
        ),
      ],
    );
  }
}
