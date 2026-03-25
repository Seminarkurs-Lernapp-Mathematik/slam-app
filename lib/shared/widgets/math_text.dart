import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Renders a string that may contain inline LaTeX ($...$) mixed with plain text.
class MathText extends StatelessWidget {
  const MathText(
    this.text, {
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final parts = text.split(r'$');
    if (parts.length <= 1) {
      return Text(text, style: effectiveStyle);
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(parts.length, (index) {
        final part = parts[index];
        if (part.isEmpty) return const SizedBox.shrink();
        if (index % 2 == 1) {
          try {
            return Math.tex(
              part,
              textStyle: effectiveStyle,
              mathStyle: MathStyle.text,
            );
          } catch (_) {
            return Text(part, style: effectiveStyle);
          }
        }
        return Text(part, style: effectiveStyle);
      }),
    );
  }
}
