import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/social_login_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  late TabController _tabController;
  bool _obscurePassword = true;
  bool _isPhoneLogin = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/home');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildTabBar(),
              const SizedBox(height: 24),
              _buildLoginForm(authState),
              const SizedBox(height: 24),
              _buildSocialLogin(),
              const SizedBox(height: 24),
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.sports_cricket,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back! Sign in to continue',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        onTap: (index) {
          setState(() {
            _isPhoneLogin = index == 1;
            _otpSent = false;
          });
        },
        tabs: const [
          Tab(text: 'Email'),
          Tab(text: 'Phone'),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isPhoneLogin) ...[
            AuthFormField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: _obscurePassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: Validators.password,
            ),
          ] else ...[
            AuthFormField(
              controller: _phoneController,
              label: 'Phone Number',
              hintText: '+1234567890',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              validator: Validators.phoneNumber,
            ),
            if (_otpSent) ...[
              const SizedBox(height: 16),
              AuthFormField(
                controller: _otpController,
                label: 'OTP',
                hintText: 'Enter 6-digit OTP',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.security,
                validator: Validators.otp,
              ),
            ],
          ],
          const SizedBox(height: 16),
          if (!_isPhoneLogin)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showForgotPasswordDialog(),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          const SizedBox(height: 24),
          if (authState.isLoading)
            const Center(child: AppLoader())
          else
            AppButton(
              text: _getButtonText(),
              onPressed: _handleLogin,
              isLoading: authState.isLoading,
            ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SocialLoginButtons(
          onGooglePressed: () => ref.read(authProvider.notifier).loginWithGoogle(),
          onBiometricPressed: () => ref.read(authProvider.notifier).loginWithBiometric(),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        TextButton(
          onPressed: () => context.push('/signup'),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getButtonText() {
    if (_isPhoneLogin) {
      return _otpSent ? 'Verify OTP' : 'Send OTP';
    }
    return 'Sign In';
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    if (_isPhoneLogin) {
      if (!_otpSent) {
        _sendOtp();
      } else {
        _verifyOtp();
      }
    } else {
      _loginWithEmail();
    }
  }

  void _loginWithEmail() {
    ref.read(authProvider.notifier).loginWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _sendOtp() {
    ref.read(authProvider.notifier).sendOtp(
          phoneNumber: _phoneController.text.trim(),
        );
    setState(() {
      _otpSent = true;
    });
  }

  void _verifyOtp() {
    ref.read(authProvider.notifier).loginWithPhone(
          phoneNumber: _phoneController.text.trim(),
          otp: _otpController.text.trim(),
        );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive reset instructions'),
            const SizedBox(height: 16),
            AuthFormField(
              controller: emailController,
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Send Reset Email',
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                ref.read(authProvider.notifier).sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset email sent!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}