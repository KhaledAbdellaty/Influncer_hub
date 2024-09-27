import 'package:blog_hub_app/core/backend/client/client.dart';
import 'package:blog_hub_app/core/backend/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class AuthRemoteSources {
  Future<Response<dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String password2,
  });
  Future<Response<dynamic>> login({
    required String email,
    required String password,
  });
  static AuthRemoteSources get instance => Modular.get();
}

class AuthRemoteSourcesImpl implements AuthRemoteSources {
  final DioClient _dioClient = DioClientImpl.instance;

  static AuthRemoteSources get instance => Modular.get();
  @override
  Future<Response> login(
      {required String email, required String password}) async {
    return await _dioClient.post(
      'http://127.0.0.1:8000/accounts/login/',
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  @override
  Future<Response> register(
      {required String email,
      required String username,
      required String password,
      required String password2}) async {
    return await _dioClient.post(
      Endpoints.register,
      isUrlEncoded: true,
      data: {
        "email": email,
        "password": password,
        "password2": password2,
        "username": username,
      },
    );
  }
}
