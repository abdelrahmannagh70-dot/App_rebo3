import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),

              const SizedBox(height: 25),

              const Text(
                'Hello! Register to get started',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              _buildTextField(hint: 'Username'),

              const SizedBox(height: 12),

              _buildTextField(
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              _buildTextField(hint: 'Password', obscureText: true),

              const SizedBox(height: 12),

              _buildTextField(hint: 'Confirm password', obscureText: true),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // هنضيف عملية التسجيل بعد كده
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC5A653),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text('Already have an account? '),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          color: Color(0xFFC5A653),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
        ),
      ),
    );
  }
}
