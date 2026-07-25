import 'package:flutter/material.dart';

import '../../../../core/theme/blockoNeonText.dart';

/// One tappable row inside [BlockoMenuPanel] — a label, an optional
/// trailing value ("On"/"Off"), and an optional bottom divider.
class BlockoMenuRow extends StatelessWidget {
  const BlockoMenuRow({
    super.key,
    required this.label,
    required this.color,
    this.value,
    this.valueColor,
    this.dividerColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final String? value;
  final Color? valueColor;
  final Color? dividerColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: dividerColor == null ? null : BoxDecoration(border: Border(bottom: BorderSide(color: dividerColor!))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: BlockoNeonText.menuItem(color: color)),
            if (value != null) Text(value!, style: BlockoNeonText.menuItem(color: valueColor ?? color)),
          ],
        ),
      ),
    );
  }
}
