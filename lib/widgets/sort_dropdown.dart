import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const SortDropdown({required this.value, required this.onChanged, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: DropdownButton<String>(
        value: value,
        onChanged: (val) => onChanged(val!),
        items:
            ['Price', 'Stock']
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text('Sort by $e')),
                )
                .toList(),
      ),
    );
  }
}
