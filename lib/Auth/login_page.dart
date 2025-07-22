import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:my_persona/Home/home_page.dart';
import 'package:my_persona/Auth/auth_service.dart'; // Import the new auth service
import 'package:my_persona/Auth/auth_widgets.dart'; // Import common auth widgets
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  String _view = 'login'; // login | register | portfolio
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false); // Get AuthService from Provider
    _authService.addListener(_onAuthServiceChange);
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle events
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthServiceChange);
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Optional: Handle app lifecycle changes for performance/resource management
    if (state == AppLifecycleState.paused) {
      // Consider pausing animations or releasing resources
    } else if (state == AppLifecycleState.resumed) {
      // Consider resuming animations or re-acquiring resources
    }
  }

  void _onAuthServiceChange() {
    // Rebuild the widget when AuthService state changes (e.g., isLoggedIn, error)
    // The AuthService already calls notifyListeners() only when a relevant state changes.
    setState(() {});
  }

  void _handleLogin() async {
    try {
      if (_authService.isLoggedIn) {
        // If already logged in, navigate directly to HomePage
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // If not logged in, proceed with Firebase login
        await _authService.login();
        if (_authService.error.isEmpty) {
          if (!mounted) return; // Check mounted before any further context usage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } finally {
      // No loading state to reset
    }
  }

  void _handleRegister() async { // Made async to await future operations
    await _authService.register(context); // Await the registration operation
    // After successful registration, switch to login view
    if (_authService.error.isEmpty) { // Assuming no error means successful registration
      setState(() {
        _view = 'login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The check for isLoggedIn and navigation is now handled in initState.
    // This build method will only render the login/register UI.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 4,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        title: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 10),
            Text(
              'MyPersona',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _view == 'login'
              ? _buildLoginForm()
              : _buildRegisterForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return LoginForm(
      emailController: _authService.emailController,
      passwordController: _authService.passwordController,
      error: _authService.error,
      onLogin: _handleLogin,
      onViewChange: (view) {
        setState(() {
          _view = view;
          _authService.error = ''; // Clear error when switching views
        });
      },
    );
  }

  Widget _buildRegisterForm() {
    return RegisterForm(
      emailController: _authService.emailController,
      passwordController: _authService.passwordController,
      confirmPasswordController: _authService.confirmPasswordController,
      error: _authService.error,
      onRegister: _handleRegister,
      onViewChange: (view) {
        setState(() {
          _view = view;
          _authService.error = ''; // Clear error when switching views
        });
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String error;
  final VoidCallback onLogin;
  final ValueChanged<String> onViewChange;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.error,
    required this.onLogin,
    required this.onViewChange,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

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
              'Login',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome back!',
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
              onPressed: widget.onLogin,
              text: 'Login',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => widget.onViewChange('register'),
              child: Text(
                "Don't have an account? Register",
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
