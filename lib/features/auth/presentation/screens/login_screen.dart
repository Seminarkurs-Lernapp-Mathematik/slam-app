import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/animations/app_animations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Shake controller for error feedback
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authLoginProvider({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      }).future);

      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      _shakeCtrl.forward(from: 0);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedGradientBg(
        colors: const [
          [Color(0xFF0D0D14), Color(0xFF1A0A1F)],
          [Color(0xFF0D0D14), Color(0xFF0F1A1F)],
          [Color(0xFF0D0D14), Color(0xFF1A100A)],
        ],
        duration: const Duration(seconds: 7),
        child: FloatingParticles(
          count: 16,
          colors: [
            const Color(0xFFFF6B2C).withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
            const Color(0xFF9B5CFF).withValues(alpha: 0.1),
          ],
          child: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: GlassPanel(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      ScaleIn(
                        curve: AppCurves.spring,
                        duration: AppDurations.slow,
                        child: Icon(
                          Icons.school,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      SlideInUp(
                        delay: const Duration(milliseconds: 80),
                        child: Text(
                          'SLAM Learning',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),

                      SlideInUp(
                        delay: const Duration(milliseconds: 120),
                        child: Text(
                          'Anmelden',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      SlideInUp(
                        delay: const Duration(milliseconds: 160),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-Mail',
                            hintText: 'name@mvl-gym.de',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte E-Mail eingeben';
                            }
                            if (!value.contains('@')) return 'Ungültige E-Mail';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      SlideInUp(
                        delay: const Duration(milliseconds: 210),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Passwort',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: AnimatedSwitcher(
                                duration: AppDurations.quick,
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  key: ValueKey(_obscurePassword),
                                ),
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte Passwort eingeben';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Error message with shake
                      if (_errorMessage != null) ...[
                        AnimatedBuilder(
                          animation: _shakeAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                              8 *
                                  (0.5 - (_shakeAnim.value * 3 % 1).abs()) *
                                  (1 - _shakeAnim.value),
                              0,
                            ),
                            child: child,
                          ),
                          child: SlideInUp(
                            child: InlineErrorMessage(message: _errorMessage!),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Login Button
                      SlideInUp(
                        delay: const Duration(milliseconds: 260),
                        child: GradientButton(
                          text: 'Anmelden',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          icon: Icons.login,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SlideInUp(
                        delay: const Duration(milliseconds: 300),
                        child: TextButton(
                          onPressed: () => context.go('/register'),
                          child:
                              const Text('Noch kein Konto? Registrieren'),
                        ),
                      ),

                      SlideInUp(
                        delay: const Duration(milliseconds: 330),
                        child: TextButton(
                          onPressed: () => context.go('/password-reset'),
                          child: const Text('Passwort vergessen?'),
                        ),
                      ),
                    ],           // children
                  ),             // Column
                ),               // Form
              ),                 // GlassPanel
            ),                   // ConstrainedBox
          ),                     // SingleChildScrollView
        ),                       // Center
      ),                         // SafeArea
    ),                           // FloatingParticles
  ),                             // AnimatedGradientBg (body:)
);
  }
}
