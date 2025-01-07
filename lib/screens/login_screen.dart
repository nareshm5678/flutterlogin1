import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/image_slider.dart';
import '../constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Desktop layout
            return const Row(
              children: [
                Expanded(child: LoginForm()),
                Expanded(child: ImageSlider()),
              ],
            );
          } else {
            // Mobile layout
            return const SingleChildScrollView(
              child: Column(
                children: [
                  ImageSlider(),
                  LoginForm(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
