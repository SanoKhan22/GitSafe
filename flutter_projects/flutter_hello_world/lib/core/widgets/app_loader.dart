import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../theme/text_theme.dart';

/// GullyCric App Loader Widget
/// 
/// Consistent loading indicators following Material 3 design
/// with cricket-themed animations and various loader types
class AppLoader extends StatelessWidget {
  final AppLoaderType type;
  final AppLoaderSize size;
  final Color? color;
  final String? message;
  final bool showMessage;

  const AppLoader({
    super.key,
    this.type = AppLoaderType.circular,
    this.size = AppLoaderSize.medium,
    this.color,
    this.message,
    this.showMessage = false,
  });

  /// Circular loader constructor
  const AppLoader.circular({
    super.key,
    this.size = AppLoaderSize.medium,
    this.color,
    this.message,
    this.showMessage = false,
  }) : type = AppLoaderType.circular;

  /// Linear loader constructor
  const AppLoader.linear({
    super.key,
    this.size = AppLoaderSize.medium,
    this.color,
    this.message,
    this.showMessage = false,
  }) : type = AppLoaderType.linear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.colorScheme.primary;

    Widget loader = _buildLoader(loaderColor);

    if (showMessage && message != null) {
      loader = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            message!,
            style: AppTextTheme.cricket.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loader;
  }

  Widget _buildLoader(Color loaderColor) {
    switch (type) {
      case AppLoaderType.circular:
        return _buildCircularLoader(loaderColor);
      case AppLoaderType.linear:
        return _buildLinearLoader(loaderColor);
      case AppLoaderType.dots:
        return _buildDotsLoader(loaderColor);
      case AppLoaderType.cricket:
        return _buildCricketLoader(loaderColor);
    }
  }

  Widget _buildCircularLoader(Color loaderColor) {
    return SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        strokeWidth: _getStrokeWidth(),
      ),
    );
  }

  Widget _buildLinearLoader(Color loaderColor) {
    return SizedBox(
      width: _getLinearWidth(),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        backgroundColor: loaderColor.withOpacity(0.2),
      ),
    );
  }

  Widget _buildDotsLoader(Color loaderColor) {
    return SizedBox(
      width: _getSize(),
      height: _getSize() / 4,
      child: DotsLoader(
        color: loaderColor,
        size: _getDotSize(),
      ),
    );
  }

  Widget _buildCricketLoader(Color loaderColor) {
    return SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: CricketBallLoader(
        color: loaderColor,
        size: _getSize(),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AppLoaderSize.small:
        return 24;
      case AppLoaderSize.medium:
        return 40;
      case AppLoaderSize.large:
        return 56;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoaderSize.small:
        return 2;
      case AppLoaderSize.medium:
        return 3;
      case AppLoaderSize.large:
        return 4;
    }
  }

  double _getLinearWidth() {
    switch (size) {
      case AppLoaderSize.small:
        return 100;
      case AppLoaderSize.medium:
        return 200;
      case AppLoaderSize.large:
        return 300;
    }
  }

  double _getDotSize() {
    switch (size) {
      case AppLoaderSize.small:
        return 6;
      case AppLoaderSize.medium:
        return 8;
      case AppLoaderSize.large:
        return 10;
    }
  }
}

/// Full screen loader overlay
class FullScreenLoader extends StatelessWidget {
  final String? message;
  final bool isVisible;
  final Color? backgroundColor;
  final AppLoaderType loaderType;

  const FullScreenLoader({
    super.key,
    this.message,
    this.isVisible = true,
    this.backgroundColor,
    this.loaderType = AppLoaderType.circular,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: AppLoader(
            type: loaderType,
            size: AppLoaderSize.large,
            message: message,
            showMessage: message != null,
          ),
        ),
      ),
    );
  }
}

/// Dots loader animation
class DotsLoader extends StatefulWidget {
  final Color color;
  final double size;

  const DotsLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size / 4),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.3 + (_animations[index].value * 0.7)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Cricket ball loader animation
class CricketBallLoader extends StatefulWidget {
  final Color color;
  final double size;

  const CricketBallLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<CricketBallLoader> createState() => _CricketBallLoaderState();
}

class _CricketBallLoaderState extends State<CricketBallLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 3.14159,
          child: Transform.scale(
            scale: 0.8 + (_bounceAnimation.value * 0.2),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: AppColors.cricketBall,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cricketBall.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: CricketBallPainter(),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Cricket ball painter for seam lines
class CricketBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw seam lines
    final path = Path();
    path.moveTo(center.dx - radius * 0.3, center.dy - radius * 0.8);
    path.quadraticBezierTo(
      center.dx,
      center.dy - radius * 0.2,
      center.dx + radius * 0.3,
      center.dy + radius * 0.8,
    );

    path.moveTo(center.dx + radius * 0.3, center.dy - radius * 0.8);
    path.quadraticBezierTo(
      center.dx,
      center.dy - radius * 0.2,
      center.dx - radius * 0.3,
      center.dy + radius * 0.8,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Loading button widget
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppLoaderType loaderType;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loaderType = AppLoaderType.circular,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        ),
      ),
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLoader(
                  type: loaderType,
                  size: AppLoaderSize.small,
                  color: foregroundColor ?? Colors.white,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}

/// Shimmer loading effect
class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceVariant;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Loader enumerations
enum AppLoaderType {
  circular,
  linear,
  dots,
  cricket,
}

enum AppLoaderSize {
  small,
  medium,
  large,
}