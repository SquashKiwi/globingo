import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globingo/providers/toast_provider.dart';
import 'package:globingo/widgets/achievement_toast.dart';

class GlobalToastOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalToastOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toasts = ref.watch(toastProvider);

    return Stack(
      children: [
        child,
        // Toast notifications overlay with SafeArea
        SafeArea(
          child: Column(
            children: [
              // Toast notifications at the top
              ...toasts.map((achievement) => 
                AchievementToast(
                  achievement: achievement,
                  onDismiss: () {
                    ref.read(toastProvider.notifier).dismissAchievement(achievement);
                  },
                ),
              ),
              const Spacer(), // Push toasts to the top
            ],
          ),
        ),
      ],
    );
  }
} 