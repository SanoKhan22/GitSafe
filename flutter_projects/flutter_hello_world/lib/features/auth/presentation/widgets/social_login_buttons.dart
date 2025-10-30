import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onBiometricPressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
    this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (onGooglePressed != null)
          _SocialButton(
            icon: Icons.g_mobiledata,
            label: 'Google',
            color: const Color(0xFFDB4437),
            onPressed: onGooglePressed!,
          ),
        if (onFacebookPressed != null)
          _SocialButton(
            icon: Icons.facebook,
            label: 'Facebook',
            color: const Color(0xFF4267B2),
            onPressed: onFacebookPressed!,
          ),
        if (onApplePressed != null)
          _SocialButton(
            icon: Icons.apple,
            label: 'Apple',
            color: Colors.black,
            onPressed: onApplePressed!,
          ),
        if (onBiometricPressed != null)
          _SocialButton(
            icon: Icons.fingerprint,
            label: 'Biometric',
            color: AppColors.primary,
            onPressed: onBiometricPressed!,
          ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}