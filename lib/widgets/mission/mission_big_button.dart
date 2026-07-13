import 'package:flutter/material.dart';

/// Botão grande e de toque fácil, usado nas telas do Modo Missão —
/// atende ao pedido de "botões maiores e mais fáceis de tocar".
class MissionBigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const MissionBigButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ],
    );

    final style = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      ),
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(64)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    return filled
        ? FilledButton(onPressed: onTap, style: style, child: child)
        : OutlinedButton(onPressed: onTap, style: style, child: child);
  }
}
