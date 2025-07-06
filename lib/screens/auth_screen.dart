import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isSignUp) {
        context.read<AuthBloc>().add(
              AuthSignUpRequested(email: email, password: password),
            );
      } else {
        context.read<AuthBloc>().add(
              AuthSignInRequested(email: email, password: password),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6366F1).withValues(alpha: 0.1),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(child: Text(state.errorMessage!)),
                          ],
                        ),
                        backgroundColor: const Color(0xFFEF4444),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.note_alt_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _isSignUp ? 'Create Account' : 'Welcome Back',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp
                              ? 'Sign up to start taking notes'
                              : 'Sign in to access your notes',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              // Check for stronger password requirements
                              if (_isSignUp) {
                                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: state.isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _isSignUp ? 'Sign Up' : 'Sign In',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                  });
                                  _formKey.currentState?.reset();
                                  _emailController.clear();
                                  _passwordController.clear();
                                },
                          child: Text(
                            _isSignUp
                                ? 'Already have an account? Sign In'
                                : 'Don\'t have an account? Sign Up',
                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
