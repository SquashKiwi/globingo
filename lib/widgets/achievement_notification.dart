import 'package:flutter/material.dart';
import 'package:globingo/services/achievement_service.dart';

class AchievementNotification extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;

  const AchievementNotification({
    super.key,
    required this.achievement,
    this.onDismiss,
  });

  @override
  State<AchievementNotification> createState() => _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _textController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
    
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _glowController.repeat(reverse: true);
    
    // Auto dismiss after 4 seconds
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      _dismiss();
    }
  }

  void _dismiss() async {
    _slideController.reverse();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted && widget.onDismiss != null) {
      widget.onDismiss!();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievementColor = AchievementService.getAchievementColor(widget.achievement);
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: _dismiss,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  achievementColor.withValues(alpha: 0.9),
                  achievementColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: achievementColor.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: achievementColor.withValues(alpha: 0.8 + _glowAnimation.value * 0.2),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Achievement Icon
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                widget.achievement.icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Achievement Text
                        Expanded(
                          child: FadeTransition(
                            opacity: _textAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (widget.achievement.isHidden)
                                      const Icon(
                                        Icons.visibility_off,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.achievement.isHidden ? 'Hidden Achievement!' : 'Achievement Unlocked!',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.achievement.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                                                 Text(
                                   AchievementService.getAchievementDescription(widget.achievement, true),
                                   style: TextStyle(
                                     color: Colors.white.withValues(alpha: 0.9),
                                     fontSize: 14,
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Close button
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: GestureDetector(
                            onTap: _dismiss,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 