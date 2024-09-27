import 'package:blog_hub_app/data/repositories/auth_repo_impl.dart';
import 'package:blog_hub_app/shared/utils/defaults.dart';
import 'package:blog_hub_app/shared/utils/ghaps.dart';
import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets/social_login_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 296,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDefaults.padding * 1.5,
                      ),
                      child: SvgPicture.asset('assets/logo/Logo.svg'),
                    ),
                    Text(
                      'Sign In',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH24,
                    Text(
                      'Sign up with Open account',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH24,
                    SocialLoginButton(
                      onGoogleLoginPressed: () {},
                      onAppleLoginPressed: () {},
                    ),
                    gapH24,
                    const Divider(),
                    gapH24,
                    Text(
                      'Or continue with email address',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH16,

                    /// EMAIL TEXT FIELD
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/mail_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/check_filled.svg',
                          width: 17,
                          height: 11,
                          fit: BoxFit.none,
                          // colorFilter: AppColors.success.toColorFilter,
                        ),
                        hintText: 'Your email',
                      ),
                    ),
                    gapH16,

                    /// PASSWORD TEXT FIELD
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/lock_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        hintText: 'Password',
                      ),
                    ),
                    gapH16,

                    /// SIGN IN BUTTON
                    SizedBox(
                      width: 296,
                      child: ElevatedButton(
                        onPressed: () {
                          final repo = AuthRepoImpl();
                          repo.login(email: 'k@k.com', password: '123456');
                        },
                        child: const Text('Sign in'),
                      ),
                    ),
                    gapH24,

                    /// FOOTER TEXT
                    Text(
                      'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    gapH24,

                    /// SIGNUP TEXT
                    Row(
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textGrey),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              color: AppColors.titleLight,
                            ),
                          ),
                          onPressed: () =>
                              Modular.to.navigate('/auth/register'),
                          child: const Text('Sign up'),
                        ),
                      ],
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
