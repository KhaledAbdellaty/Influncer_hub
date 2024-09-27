import 'package:blog_hub_app/data/data_sources/auth_remote_source.dart';
import 'package:blog_hub_app/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final _authSources = AuthRemoteSources.instance;

  @override
  Future<Either<String, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authSources.login(email: email, password: password);

      return Right(res.data);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> register({
    required String email,
    required String username,
    required String password,
    required String password2,
  }) async {
    try {
      final res = await _authSources.register(
          email: email,
          username: username,
          password: password,
          password2: password2);
      return Right(res.data);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
