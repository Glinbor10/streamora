import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:streamora/shared/user_agent_client.dart';

void main() {
  test('sends the OkHttp User-Agent expected by Xtream providers', () async {
    String? observedAgent;
    final inner = MockClient((request) async {
      observedAgent = request.headers['User-Agent'];
      return http.Response('ok', 200);
    });
    final client = UserAgentClient(inner);

    await client.get(Uri.parse('http://fake.test/player_api.php'));

    expect(observedAgent, 'okhttp/4.12.0');
    client.close();
  });
}
