import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.to.pushNamed('/auth/sign-in');

    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: RouterOutlet(),
    );
  }
}
