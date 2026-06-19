sealed class APIException implements Exception {
  APIException(this.message);
  final String message;
}

class InvalidApiKeyException extends APIException {
  final String msg;
  
  InvalidApiKeyException(this.msg) : super(msg);
}
class NotFoundException extends APIException {
  final String msg;
  
  NotFoundException(this.msg) : super(msg);
}

class TimeoutException extends APIException {
   final String msg;
  
  TimeoutException(this.msg) : super(msg);
}
class NotAllowedException extends APIException {
  final String msg;

  NotAllowedException(this.msg) : super(msg);
}
class NotRegisteredUserException extends APIException {
    final String msg;

  NotRegisteredUserException(this.msg) : super(msg);
}

class NoInternetConnectionException extends APIException {
  final String msg;

  NoInternetConnectionException(this.msg) : super(msg);
}

class LoginAttemptFailed extends APIException {
    final String msg;

  LoginAttemptFailed(this.msg) : super(msg);
}

class InvalidCredentials extends APIException {
    final String msg;

  InvalidCredentials(this.msg) : super(msg);
}