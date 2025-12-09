class AppException implements Exception {
  final String message;
  final String? details;

  AppException(this.message, [this.details]);

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class DatabaseException extends AppException {
  DatabaseException(super.message);
}

