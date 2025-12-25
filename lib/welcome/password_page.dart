import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isRegister = false;
  bool _obscure = true;
  String? _phoneNumber;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _phoneNumber = args['phone_number'] as String?;
        _countryCode = args['country_code'] as String?;
        _isRegister = (args['register'] as bool?) ?? false;
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (_phoneNumber == null) {
      _showError('Phone number not found');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    if (_isRegister) {
      if (confirm.isEmpty) {
        _showError('Please confirm your password');
        return;
      }
      if (password != confirm) {
        _showError('Password confirmation does not match');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> response;
      if (_isRegister) {
        response = await _apiService.register(
          phoneNumber: _phoneNumber!,
          countryCode: _countryCode ?? '+1',
          password: password,
          passwordConfirmation: confirm,
        );
      } else {
        response = await _apiService.login(
          phoneNumber: _phoneNumber!,
          countryCode: _countryCode ?? '+1',
          password: password,
        );
      }

      setState(() => _isLoading = false);

      if (response['success'] == true) {
        final hasProfile = response['has_profile'] ?? false;
        if (mounted) {
          if (hasProfile) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushNamed(context, '/first_name');
          }
        }
      } else {
        _showError(response['message']?.toString() ?? 'Authentication failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      _isRegister ? 'Create your password' : 'Enter your password',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFFF3F80), width: 2),
                        ),
                      ),
                    ),
                    if (_isRegister) ...[
                      const SizedBox(height: 20),
                      TextField(
                        controller: _confirmController,
                        obscureText: _obscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFFF3F80), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3F80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isRegister ? 'Register' : 'Login',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => setState(() => _isRegister = !_isRegister),
                    child: Text(
                      _isRegister ? 'Already have an account? Login' : 'New here? Create account',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
