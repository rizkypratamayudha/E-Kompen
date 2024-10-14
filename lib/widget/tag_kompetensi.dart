import 'package:flutter/material.dart';

class TagKompetensi extends StatefulWidget {
  const TagKompetensi({super.key});

  @override
  State<TagKompetensi> createState() => _TagKompetensiState();
}

class _TagKompetensiState extends State<TagKompetensi> {
  bool selectedTag = false;
  bool selectedTag1 = false;
  bool selectedTag2 = false;
  bool selectedTag3 = false;
  bool selectedTag4 = false;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Jarak horizontal antar chips
      runSpacing: 8, // Jarak vertical antar chips
      alignment: WrapAlignment.start,
      children: [
        FilterChip(
          label: const Text('Coding'),
          selected: selectedTag, 
          onSelected: (bool value) {
            setState(() {
              selectedTag = !selectedTag;
            });
          },
        ),
        FilterChip(
          label: const Text('Word'),
          selected: selectedTag1,
          onSelected: (bool value) {
            setState(() {
              selectedTag1 = !selectedTag1;
            });
          },
        ),
        FilterChip(
          label: const Text('Excel'),
          selected: selectedTag2,
          onSelected: (bool value) {
            setState(() {
              selectedTag2 = !selectedTag2;
            });
          },
        ),
        FilterChip(
          label: const Text('Input Data'),
          selected: selectedTag3,
          onSelected: (bool value) {
            setState(() {
              selectedTag3 = !selectedTag3;
            });
          },
        ),
        FilterChip(
          label: const Text('Penelitian'),
          selected: selectedTag4,
          onSelected: (bool value) {
            setState(() {
              selectedTag4 = !selectedTag4;
            });
          },
        ),
      ],
    );
  }
}