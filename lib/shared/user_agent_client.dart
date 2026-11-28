import 'package:http/http.dart' as http;

/// Some Xtream providers block the default Dart User-Agent, while others block
/// the generic player User-Agent. Official Android players use OkHttp, so we
/// present the same User-Agent to avoid both kinds of block page.
const xtreamUserAgent = 'okhttp/4.12.0';

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
