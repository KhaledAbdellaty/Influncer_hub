import 'package:blog_hub_app/presentation/controller/auth_cubit/auth_cubit.dart';
import 'package:blog_hub_app/presentation/view/auth/auth_view.dart';
import 'package:blog_hub_app/presentation/view/auth/register_page.dart';
import 'package:blog_hub_app/presentation/view/auth/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(RouteManager r) {
    // r.child('/',
    //     child: (context) => BlocProvider(
    //           create: (_) => AuthCubit(),
    //           child: const AuthView(),
    //         ));
    r.child('/sign-in',
        child: (context) => BlocProvider(
              create: (_) => AuthCubit(),
              child: const SignInPage(),
            ));
    r.child('/register',
        child: (context) => BlocProvider(
              create: (_) => AuthCubit(),
              child: const RegisterPage(),
            ));
  }
}
