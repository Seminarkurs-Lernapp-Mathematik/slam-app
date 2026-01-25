import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/services/auth_service.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  Timer? _checkTimer;
  bool _isChecking = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _startAutoCheck();
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startAutoCheck() {
    // Check every 3 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkEmailVerification();
    });
  }

  Future<void> _checkEmailVerification() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final isVerified = await authService.reloadAndCheckEmailVerification();

      if (isVerified) {
        _checkTimer?.cancel();
        if (mounted) {
          setState(() {
            _successMessage = 'E-Mail erfolgreich verifiziert!';
          });

          // Wait a moment then navigate
          await Future.delayed(const Duration(seconds: 1));

          if (mounted) {
            context.go('/home');
          }
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Überprüfen: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendEmailVerification();

      setState(() {
        _successMessage = 'Verifizierungs-E-Mail erneut gesendet!';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);
    final userEmail = authService.currentUser?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GlassPanel(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.email,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'E-Mail verifizieren',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Wir haben dir eine Verifizierungs-E-Mail an',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userEmail,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'gesendet. Bitte klicke auf den Link in der E-Mail, um dein Konto zu verifizieren.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Auto-checking indicator
                    if (_isChecking) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Überprüfe Verifizierung...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Success Message
                    if (_successMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _successMessage!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Error Message
                    if (_errorMessage != null) ...[
                      InlineErrorMessage(message: _errorMessage!),
                      const SizedBox(height: 16),
                    ],

                    // Instructions
                    GlassPanel.inactive(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Hinweise:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionItem(
                            '1. Überprüfe dein E-Mail-Postfach',
                          ),
                          _buildInstructionItem(
                            '2. Klicke auf den Verifizierungslink',
                          ),
                          _buildInstructionItem(
                            '3. Diese Seite wird automatisch aktualisiert',
                          ),
                          _buildInstructionItem(
                            '4. Überprüfe ggf. deinen Spam-Ordner',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Resend Button
                    SecondaryButton(
                      text: 'E-Mail erneut senden',
                      onPressed: _resendVerificationEmail,
                      icon: Icons.refresh,
                    ),
                    const SizedBox(height: 16),

                    // Back to Login
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Zurück zum Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 16,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
