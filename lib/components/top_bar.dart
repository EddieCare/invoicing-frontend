import 'dart:ui';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon? leadingIcon;
  final String? title;
  final bool showBackButton;
  final List<Widget> actions;

  const TopBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions = const [],
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        child: ClipRRect(
          child: Container(
            color: Colors.white.withAlpha(50), // Soft transparent background
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                if (leadingIcon != null) SizedBox(child: leadingIcon),
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                // Placeholder for symmetry
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
