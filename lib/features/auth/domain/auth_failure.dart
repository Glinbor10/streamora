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
