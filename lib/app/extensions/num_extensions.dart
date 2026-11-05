import 'package:flutter/widgets.dart';

extension NumSpaceExtension on num {
  /// Vertical space: SizedBox(height: value)
  Widget get ph => SizedBox(height: toDouble());

  /// Horizontal space: SizedBox(width: value)
  Widget get pw => SizedBox(width: toDouble());
}
