// lib/features/auth/presentation/screens/auth_screen.dart
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController(text: "test@money.com");
  final _passwordController = TextEditingController(text: "123456");

  void _login() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập thành công!"), backgroundColor: Colors.green),
    );
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.account_balance_wallet, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "MoneyNote",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),

                const SizedBox(height: 40),

                // White Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Tab
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isLogin ? Colors.grey[100] : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("Đăng nhập", textAlign: TextAlign.center, style: TextStyle(fontWeight: isLogin ? FontWeight.bold : FontWeight.normal)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isLogin ? Colors.grey[100] : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("Đăng ký", textAlign: TextAlign.center, style: TextStyle(fontWeight: !isLogin ? FontWeight.bold : FontWeight.normal)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      _buildTextField("Email", Icons.email, _emailController),
                      const SizedBox(height: 16),
                      _buildTextField("Mật khẩu", Icons.lock, _passwordController, isPassword: true),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(isLogin ? "Đăng nhập" : "Đăng ký", style: const TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text("hoặc", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text("Tiếp tục với Google"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text("© 2026 MoneyNote. All rights reserved.", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}