import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

dynamic _onServerErrorBase(dynamic e, [StackTrace? st]) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        if (e.response == null) return;
        final errors = e.response!.data['errors'];

        String errorMessage = '';
        if (errors is String) {
          return errors;
        } else if (errors is Map<String, dynamic>) {
          // return e.response!.data["message"];
          errors.forEach((err, list) {
            list as List<dynamic>;
            errorMessage += list.join("");
            if (errors.length > 1) errorMessage += " | ";
          });
          // remove last " | "
          if (errorMessage.endsWith(" | ")) {
            errorMessage = errorMessage.substring(0, errorMessage.length - 3);
          }
          return errorMessage;
        }
        return e.response!.data['message'];
      default:
    }
  }
  return e;
}

Future<Either<String?, T>> basicErrorHandling<T>(
    Future<T> Function() apiRequest,
    {Future<String> Function<T>(T error)? onError,
    bool isLogin = false}) async {
  try {
    final f = await apiRequest();
    return Right(f);
  } catch (e, st) {
    if (onError != null) {
      final f = await onError(e);
      return Left(f);
    }
    final f = _onServerErrorBase(e, st);
    if (f is! String) {
      return Left(f.toString());
      //   return const Left(
      //       "Something went wrong and has been reported to the developers");
      // }
      // if (f.toString().contains('The weight must not be')) {
      //   return const Left(
      //       "Please go to Item info and increase number of sides");
      // }
      // if (isLogin) {
      //   return Left(f.toString());
      // } else {
      //   return const Left(
      //       "Something went wrong and has been reported to the developers");
      // }
    }

    return Left(f.toString());
  }
}
