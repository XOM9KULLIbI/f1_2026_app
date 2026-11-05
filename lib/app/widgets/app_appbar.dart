import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          color: ThemeColors.racingRed,
          height: 2,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
