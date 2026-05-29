enum AuthFailureCode {
  invalidInput,
  invalidCredentials,
  weakPassword,
  rateLimited,
  offline,
  unauthorized,
  blocked,
  suspended,
  forcedLogout,
  serviceUnavailable,
  localUnlockFailed,
  unknownSafeFailure,
}

class AuthFailure {
  const AuthFailure({
    required this.code,
    required this.message,
    this.retryAllowed = false,
  });

  const AuthFailure.invalidInput({
    String message = 'Check the provided details and try again.',
  }) : this(code: AuthFailureCode.invalidInput, message: message);

  const AuthFailure.invalidCredentials({
    String message = 'The email or password is not correct.',
  }) : this(code: AuthFailureCode.invalidCredentials, message: message);

  const AuthFailure.weakPassword({
    String message = 'Choose a stronger password to continue.',
  }) : this(code: AuthFailureCode.weakPassword, message: message);

  const AuthFailure.rateLimited({
    String message = 'Too many attempts were made. Try again shortly.',
  }) : this(
         code: AuthFailureCode.rateLimited,
         message: message,
         retryAllowed: true,
       );

  const AuthFailure.offline({
    String message = 'No network connection is available right now.',
  }) : this(
         code: AuthFailureCode.offline,
         message: message,
         retryAllowed: true,
       );

  const AuthFailure.unauthorized({
    String message = 'Sign in again to continue.',
  }) : this(
         code: AuthFailureCode.unauthorized,
         message: message,
         retryAllowed: true,
       );

  const AuthFailure.blocked({
    String message = 'This account cannot use protected actions right now.',
  }) : this(code: AuthFailureCode.blocked, message: message);

  const AuthFailure.suspended({
    String message = 'This account is temporarily unavailable.',
  }) : this(code: AuthFailureCode.suspended, message: message);

  const AuthFailure.forcedLogout({
    String message = 'The session must be ended and restarted.',
  }) : this(code: AuthFailureCode.forcedLogout, message: message);

  const AuthFailure.serviceUnavailable({
    String message = 'The service is unavailable right now.',
  }) : this(
         code: AuthFailureCode.serviceUnavailable,
         message: message,
         retryAllowed: true,
       );

  const AuthFailure.localUnlockFailed({
    String message = 'Local unlock could not be completed.',
  }) : this(code: AuthFailureCode.localUnlockFailed, message: message);

  const AuthFailure.unknownSafeFailure({
    String message = 'Something went wrong. Please try again.',
  }) : this(
         code: AuthFailureCode.unknownSafeFailure,
         message: message,
         retryAllowed: true,
       );

  final AuthFailureCode code;
  final String message;
  final bool retryAllowed;
}