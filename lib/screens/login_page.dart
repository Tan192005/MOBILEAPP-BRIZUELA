import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dashboard_page.dart';

class AppColors {
  static const background = Color(0xFF171717);
  static const accent = Color(0xFFFFB26B);
  static const cream = Color(0xFFFFF1E6);
  static const panel = Color(0xD91D1D1D);
  static const line = Color(0x99FFF1E6);
  static const textGrey = Color(0xFFD1C5BD);
  static const textDark = Color(0xFFFFF1E6);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isRegisterMode = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (_isRegisterMode) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
      );
    } on FirebaseAuthException catch (error) {
      _showAuthError(error.message ?? 'Authentication failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showAuthError('Enter your email above to reset your password.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        _showAuthError('Password reset instructions were sent to $email.');
      }
    } on FirebaseAuthException catch (error) {
      _showAuthError(error.message ?? 'Could not send password reset email.');
    }
  }

  Future<void> _signInWithGoogle() async {
    await _runSocialSignIn(() async {
      final account = await _googleSignIn.signIn();
      if (account == null) return;
      final authentication = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  Future<void> _signInWithFacebook() async {
    await _runSocialSignIn(() async {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.cancelled) return;
      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw FirebaseAuthException(
          code: 'facebook-login-failed',
          message: result.message ?? 'Facebook sign-in failed.',
        );
      }
      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  Future<void> _runSocialSignIn(Future<void> Function() signIn) async {
    setState(() => _isLoading = true);
    try {
      await signIn();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
      );
    } on FirebaseAuthException catch (error) {
      _showAuthError(error.message ?? 'Authentication failed.');
    } catch (error) {
      _showAuthError('Social sign-in is not configured for this app yet.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAuthError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/image-1790068242124.png',
            key: const ValueKey('login-background-image'),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: AppColors.background),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66231A12), Color(0x990E1110)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Color(0xFF3B2415),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 11),
                            const Text(
                              'FITORA',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: AppColors.cream,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                        decoration: BoxDecoration(
                          color: const Color(0xB31A1D1B),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 32,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Welcome back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.cream,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your next great workout starts here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 28),
                              _buildEmailField(),
                              const SizedBox(height: 14),
                              _buildPasswordField(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _isLoading ? null : _resetPassword,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.accent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _handleSignIn,
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Color(0xFF3B2415),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20,
                                        ),
                                  label: Text(
                                    _isLoading
                                        ? (_isRegisterMode
                                            ? 'Creating account...'
                                            : 'Signing in...')
                                        : (_isRegisterMode ? 'REGISTER' : 'LOGIN'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: const Color(0xFF3B2415),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildSocialLogin(),
                              const SizedBox(height: 22),
                              Center(
                                child: TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(
                                          () => _isRegisterMode =
                                              !_isRegisterMode,
                                        ),
                                  child: Text(
                                    _isRegisterMode
                                        ? 'Already have an account? LOGIN'
                                        : 'New to Fitora? REGISTER',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'MOVE WITH PURPOSE  ·  FEEL THE DIFFERENCE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return _RoundedTextField(
      controller: _emailController,
      hintText: 'Email',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!value.contains('@')) return 'Enter a valid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _RoundedTextField(
      controller: _passwordController,
      hintText: 'Password',
      icon: Icons.lock_outline,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textGrey,
          size: 20,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (value.length < 6) return 'At least 6 characters';
        return null;
      },
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: Colors.white24)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white24)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _socialButton(
                'Google',
                Icons.g_mobiledata_rounded,
                _signInWithGoogle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _socialButton(
                'Facebook',
                Icons.facebook_rounded,
                _signInWithFacebook,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.cream,
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 21),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _RoundedTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}
