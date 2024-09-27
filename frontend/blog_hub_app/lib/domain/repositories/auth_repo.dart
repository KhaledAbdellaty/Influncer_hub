import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class AuthRepo {
  static AuthRepo get instance => Modular.get();

  Future<Either<String, Map<String, dynamic>>> register(
    {
    required String email,
    required String username,
    required String password,
    required String password2,
  }
  );
  Future<Either<String, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });
}
