import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:my_persona/Auth/auth_widgets.dart'; // Import common auth widgets
// Import ThemeProvider
// Import Provider

class RegisterForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String error;
  final VoidCallback onRegister;
  final ValueChanged<String> onViewChange;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.error,
    required this.onRegister,
    required this.onViewChange,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Account',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start building your portfolio',
              style: GoogleFonts.poppins(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            buildAuthTextField(
              context: context,
              controller: widget.emailController,
              labelText: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            buildAuthTextField(
              context: context,
              controller: widget.passwordController,
              labelText: 'Password',
              hintText: '••••••••',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            buildAuthTextField(
              context: context,
              controller: widget.confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: '••••••••',
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            if (widget.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.error,
                  style: GoogleFonts.poppins(color: colorScheme.error, fontSize: 14),
                ),
              ),
            const SizedBox(height: 24),
            buildAuthElevatedButton(
              context: context,
              onPressed: widget.onRegister,
              text: 'Register',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => widget.onViewChange('login'),
              child: Text(
                "Already have an account? Login",
                style: GoogleFonts.poppins(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
