import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String _error = '';
  String get error => _error;
  set error(String value) {
    if (_error != value) { // Only notify if value changes
      _error = value;
      notifyListeners();
    }
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  AuthService() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners(); // Notify listeners when auth state changes
    });
  }


  Future<void> login() async {
    error = ''; // Clear previous errors

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      error = 'Please fill in all fields';
      return;
    }

    try {
      debugPrint('Login initiated at: ${DateTime.now()}'); // Log start time
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      debugPrint('Login completed at: ${DateTime.now()}'); // Log end time
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'An unknown error occurred during login.';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    }
  }

  Future<void> register(BuildContext context) async {
    error = ''; // Clear previous errors

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      error = 'Please fill in all fields';
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      error = 'Passwords do not match';
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! You can now log in.')),
      );
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'An unknown error occurred during registration.';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    error = '';
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'An unknown error occurred during sign out.';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
