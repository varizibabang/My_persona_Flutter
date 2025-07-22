import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildAuthTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurfaceVariant),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(179)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), // Increased border radius for a softer look
        borderSide: BorderSide.none, // No border by default
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Primary color border when focused
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(128), width: 1), // Lighter outline when enabled
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Increased padding
    ),
  );
}

Widget buildAuthElevatedButton({
  required BuildContext context,
  required VoidCallback? onPressed, // Make onPressed nullable
  required String text,
  Widget? child, // Add optional child widget
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Text/icon color
        padding: const EdgeInsets.symmetric(vertical: 18), // Increased vertical padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Increased border radius for a softer look
        ),
        elevation: 8, // Increased elevation for more depth
        shadowColor: Theme.of(context).colorScheme.primary.withAlpha(77), // Custom shadow color
      ),
      child: child ?? // Use child if provided, otherwise use Text
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600),
          ),
    ),
  );
}

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
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Register',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create your account',
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
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
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
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
                  style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.error, fontSize: 14),
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
                  color: Theme.of(context).colorScheme.primary,
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
