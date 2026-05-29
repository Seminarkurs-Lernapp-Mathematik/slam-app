import 'package:flutter/material.dart';

import '../animations/app_animations.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LottieLoop(
            asset: AppAnim.loadingDots,
            width: size * 2,
            height: size * 0.7,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            SlideInUp(
              delay: const Duration(milliseconds: 100),
              child: Text(
                message!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  factory LoadingIndicator.small({Color? color}) {
    return const LoadingIndicator(size: 24);
  }
}
