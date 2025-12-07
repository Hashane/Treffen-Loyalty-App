import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/responsive.dart';

class EnhancedAuthScreen extends StatefulWidget {
  final VoidCallback onLogin;

  const EnhancedAuthScreen({super.key, required this.onLogin});

  @override
  State<EnhancedAuthScreen> createState() => _EnhancedAuthScreenState();
}

class _EnhancedAuthScreenState extends State<EnhancedAuthScreen> with TickerProviderStateMixin {
  bool isLogin = true;
  bool showPassword = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _logoController;
  late AnimationController _slideController;
  late AnimationController _shakeController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    // Screen fade animation
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Logo animation
    _logoController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoRotationAnimation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Form slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Text animations
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Shake animation for errors
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));
  }

  void _startAnimations() {
    _fadeController.forward();
    _logoController.forward();
    _slideController.forward();
  }

  Future<void> _handleSubmit() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      // Success haptic
      HapticFeedback.heavyImpact();

      widget.onLogin();
    } else {
      // Error shake animation
      _shakeController.forward().then((_) => _shakeController.reverse());
      HapticFeedback.vibrate();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    _slideController.dispose();
    _shakeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),

          child: Column(
            children: [
              SafeArea(
                bottom: false, // ← Don't add bottom padding
                child: _buildHeader(),
              ),
              Expanded(child: _buildFormContainer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: context.hp(0.08), bottom: context.hp(0.04)),
      child: Column(
        children: [
          // Animated Logo
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value * 3.14159,
                  child: Container(
                    width: context.wp(0.18),
                    height: context.wp(0.18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                      borderRadius: context.radiu(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.loyalty,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: context.wp(0.09),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: context.hp(0.03)),
          // Title
          FadeTransition(
            opacity: _titleAnimation,
            child: Transform.translate(
              offset: Offset(0, (1 - _titleAnimation.value) * -20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: context.ssp(28),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // no header theme toggle here by design
                ],
              ),
            ),
          ),
          SizedBox(height: context.hp(0.01)),
          // Subtitle
          FadeTransition(
            opacity: _subtitleAnimation,
            child: Transform.translate(
              offset: Offset(0, (1 - _subtitleAnimation.value) * -20),
              child: Text(
                isLogin ? 'Sign in to continue' : 'Create your account',
                style: TextStyle(
                  fontSize: context.ssp(16),
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _slideController,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.ssp(40)),
              topRight: Radius.circular(context.ssp(40)),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.ssp(24)),
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                final offset = 10 * _shakeAnimation.value;
                return Transform.translate(
                  offset: Offset(offset * (1 - 2 * (_shakeAnimation.value % 1)), 0),
                  child: _buildForm(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Input
          _buildInputField(
            label: 'Email',
            controller: emailController,
            icon: Icons.mail_outline,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: context.ssp(24)),

          // Password Input
          _buildInputField(
            label: 'Password',
            controller: passwordController,
            icon: Icons.lock_outline,
            hint: 'Enter your password',
            obscureText: !showPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                setState(() => showPassword = !showPassword);
                HapticFeedback.selectionClick();
              },
            ),
          ),
          SizedBox(height: context.ssp(16)),

          // Forgot Password
          if (isLogin)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Handle forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                ),
              ),
            ),

          SizedBox(height: context.ssp(24)),

          // Submit Button
          _buildSubmitButton(),

          SizedBox(height: context.ssp(32)),

          // Divider
          _buildDivider(),

          SizedBox(height: context.ssp(32)),

          // Social Login Buttons
          _buildSocialButtons(),

          const SizedBox(height: 32),

          // Toggle Login/Signup
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.ssp(14),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.ssp(8)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: context.radiu(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: context.radiu(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: context.radiu(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: context.radiu(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.ssp(16),
              vertical: context.ssp(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: context.ssp(56),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
        borderRadius: context.radiu(16),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: context.radiu(16)),
        ),
        child: isLoading
            ? SizedBox(
                height: context.ssp(24),
                width: context.ssp(24),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                isLogin ? 'Sign In' : 'Create Account',
                style: TextStyle(
                  fontSize: context.ssp(16),
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.ssp(16)),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: context.ssp(14),
            ),
          ),
        ),
        Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _buildSocialButton('Google', Icons.g_mobiledata, cs.primary)),
        SizedBox(width: context.ssp(16)),
        Expanded(child: _buildSocialButton('Facebook', Icons.facebook, cs.primary)),
      ],
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Handle social login
      },
      borderRadius: context.radiu(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.ssp(12)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08)),
          borderRadius: context.radiu(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            SizedBox(width: context.ssp(8)),
            Text(
              label,
              style: TextStyle(
                fontSize: context.ssp(14),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : 'Already have an account? ',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72)),
        ),
        GestureDetector(
          onTap: () {
            setState(() => isLogin = !isLogin);
            HapticFeedback.selectionClick();
          },
          child: Text(
            isLogin ? 'Sign Up' : 'Sign In',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
