import 'package:http/http.dart' as http;

/// Many Xtream servers block the default Dart User-Agent, so every request
/// presents a standard player User-Agent instead.
const xtreamUserAgent = 'IPTVSmartersPlayer';

/// HTTP client that always sends [xtreamUserAgent].
class UserAgentClient extends http.BaseClient {
  /// Wraps [inner] (a new client by default).
  new([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] = xtreamUserAgent;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
