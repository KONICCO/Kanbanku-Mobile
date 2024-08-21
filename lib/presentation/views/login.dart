import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController()
    ..text = 'nico678514@gmail.com';
  final TextEditingController _passwordController = TextEditingController()
    ..text = '12345678';

  @override
  Widget build(BuildContext context) {
    return BlocListener<KanbanCubit, KanbanState>(
      listener: (context, state) {
        if (state.user != null) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF06B6D4), // from-cyan-500
                  Color(0xFF3B82F6), // to-blue-500
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo di luar card putih
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/app.png', // Path ke file logo
                          height: 80, // Sesuaikan tinggi logo
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Kanbanku',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Please insert your email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Please insert your password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF06B6D4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              onPressed: () {
                                context.read<KanbanCubit>().login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Don\'t have an account?'),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.pushNamed(context, '/register');
                            //   },
                            //   child: const Text(
                            //     'don\'t have an account?',
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                            const SizedBox(height: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              onPressed: () {

                                Navigator.pushReplacementNamed(context, '/register');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
