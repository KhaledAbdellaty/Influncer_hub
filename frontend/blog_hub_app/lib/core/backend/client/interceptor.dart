import 'package:blog_hub_app/core/backend/services/cache_service.dart';
import 'package:blog_hub_app/shared/utils/alerts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = CacheService.instance.get<String>('token');
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    // options.sendTimeout = 3000;

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // _checkVerification(err);
    // _checkResturant(err);
    return handler.next(err);
  }

  // void _checkVerification(DioException err) {
  //   if (err.type == DioExceptionType.badResponse && err.response != null) {
  //     if (err.response!.statusCode == 403 &&
  //         (err.message == "Your email address is not verified." ||
  //             err.response!.data
  //                 .toString()
  //                 .contains("Your email address is not verified."))) {
  //       // Repository.instance.sendVerficationEmail();
  //       Alerts.showDialog(
  //         Modular.routerDelegate.navigatorKey.currentContext!,
  //         title: "Account Verification",
  //         message:
  //             "Your email address is not verified yet we've sent you a verification email, please check your inbox. and relog again",
  //         alertType: AlertType.warning,
  //         dismissable: false,
  //         hasCancelButton: false,
  //         onPressed: () {
  //           CacheService.instance.sharedPreferences.clear();
  //           CacheService.instance.webSessionStorage.clear();

  //           Modular.to.pushReplacementNamed("/auth/login");
  //         },
  //       );
  //     }
  //   }
  // }

  // void _checkResturant(DioException err) {
  //   if (err.type == DioExceptionType.badResponse && err.response != null) {
  //     if (err.response!.statusCode == 403 &&
  //         (err.message == "You must create a restaurant first." ||
  //             err.response!.data
  //                 .toString()
  //                 .contains("You must create a restaurant first."))) {
  //       Alerts.showDialog(
  //         Modular.routerDelegate.navigatorKey.currentContext!,
  //         title: "Resturant missing",
  //         message:
  //             "You haven't created a restaurant yet, please create a restaurant first to continue.",
  //         alertType: AlertType.warning,
  //         dismissable: false,
  //         hasCancelButton: false,
  //         onPressed: () => Modular.to.pushReplacementNamed("/onboarding/"),
  //       );
  //     }
  //   }
  // }
}
