/// Lowercases text and strips common Latin accents so searches ignore them.
abstract final class TextNormalizer {
  static const _from = 'àáâãäåāçćčèéêëēėęìíîïīįłñńòóôõöøōšśùúûüūýÿžźż';
  static const _to = 'aaaaaaaccceeeeeeeiiiiiilnnoooooooossuuuuuyyzzz';
  static final _map = <int, String>{
    for (var i = 0; i < _from.length; i++) _from.codeUnitAt(i): _to[i],
  };

  /// Returns a lowercase, accent-free version of [input].
  static String normalize(String input) {
    final lower = input.toLowerCase();
    final buffer = StringBuffer();
    for (final unit in lower.codeUnits) {
      buffer.write(_map[unit] ?? String.fromCharCode(unit));
    }
    return buffer.toString().trim();
  }
}
