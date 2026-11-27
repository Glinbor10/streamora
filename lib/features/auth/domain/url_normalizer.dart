/// Normalizes user-typed server addresses.
abstract final class UrlNormalizer {
  /// Returns `scheme://host[:port][/path]` without trailing slashes, or null
  /// when [input] is not a usable server address.
  ///
  /// A missing scheme defaults to `http`.
  static String? normalize(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final withScheme = RegExp('^[a-zA-Z][a-zA-Z0-9+.-]*://').hasMatch(trimmed)
        ? trimmed
        : 'http://$trimmed';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || uri.host.isEmpty) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    final path = uri.path.replaceAll(RegExp(r'/+$'), '');
    final port = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$port$path';
  }
}
