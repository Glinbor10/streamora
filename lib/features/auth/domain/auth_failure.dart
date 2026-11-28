/// Reasons why authentication can fail.
enum AuthFailureType {
  /// The server URL is empty or malformed.
  invalidUrl,

  /// The server could not be reached.
  network,

  /// The server rejected the username or password.
  unauthorized,

  /// The account exists but is expired or disabled.
  expiredAccount,

  /// The provider returned a server error (5xx).
  serverError,

  /// An ISP or network filter returned a block page instead of the API.
  blockedNetwork,

  /// Anything else.
  unknown,
}

/// Typed authentication error, safe to show in the UI.
class AuthFailure implements Exception {
  /// Creates a failure of the given [type].
  const new(this.type);

  /// What went wrong.
  final AuthFailureType type;

  @override
  String toString() => 'AuthFailure(${type.name})';
}
