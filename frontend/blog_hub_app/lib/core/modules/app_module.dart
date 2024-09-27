import 'package:blog_hub_app/app.dart';
import 'package:blog_hub_app/core/backend/client/client.dart';
import 'package:blog_hub_app/core/backend/endpoints.dart';
import 'package:blog_hub_app/core/backend/services/cache_service.dart';
import 'package:blog_hub_app/core/modules/auth_module.dart';
import 'package:blog_hub_app/core/modules/dashboard_module.dart';
import 'package:blog_hub_app/data/data_sources/auth_remote_source.dart';
import 'package:blog_hub_app/data/repositories/auth_repo_impl.dart';
import 'package:blog_hub_app/domain/repositories/auth_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModule extends Module {
  final prefs;

  AppModule(this.prefs);
  final options = BaseOptions(
    baseUrl: Endpoints.accounts,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  @override
  void binds(Injector i) {
    i.addLazySingleton<CacheService>(CacheServiceImpl.new);
    i.addLazySingleton<ImagePicker>(ImagePicker.new);
    i.addLazySingleton<SharedPreferences>(() => SharedPreferences);
    // i.add<Dio>(Dio.new);
    // i.add(BaseOptions.new);
    // i.addSingleton<DioClient>(DioClientImpl.new);
    i.add<BaseOptions>(
      () => BaseOptions(
        // baseUrl: 'http://127.0.0.1:8000/', // Set your base URL here
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Register Dio with the BaseOptions instance
    i.add<Dio>(
      () => Dio(i.get<BaseOptions>()),
    );

    // Register DioClientImpl with the Dio instance
    i.addSingleton<DioClient>(
      () => DioClientImpl(i.get<Dio>()),
    );
    // [data sources]

    i.addSingleton<AuthRemoteSources>(AuthRemoteSourcesImpl.new);
    i.addSingleton<AuthRepo>(AuthRepoImpl.new);
  }

  @override
  void routes(RouteManager r) {
    r.redirect('/', to: '/auth/sign-in');
    r.module('/auth', module: AuthModule());
    r.module('/dashboard', module: DashboardModule());
  }
}
