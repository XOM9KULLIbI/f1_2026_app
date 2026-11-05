import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';
import '../extensions/num_extensions.dart';

class AppProgressIndicator extends StatelessWidget {
  final String? message;

  const AppProgressIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: ThemeColors.racingRed,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            16.ph,
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
