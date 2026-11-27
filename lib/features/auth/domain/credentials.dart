import 'package:meta/meta.dart';

/// Xtream account credentials.
@immutable
class Credentials {
  /// Creates credentials.
  const new({
    required this.server,
    required this.username,
    required this.password,
  });

  /// Normalized server URL (see `UrlNormalizer`).
  final String server;

  /// Account username.
  final String username;

  /// Account password.
  final String password;

  @override
  bool operator ==(Object other) =>
      other is Credentials &&
      other.server == server &&
      other.username == username &&
      other.password == password;

  @override
  int get hashCode => Object.hash(server, username, password);

  /// Never prints the password.
  @override
  String toString() => 'Credentials($server, $username, ***)';
}
