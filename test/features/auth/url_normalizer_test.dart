import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/auth/domain/url_normalizer.dart';

void main() {
  group('UrlNormalizer', () {
    test('adds http scheme and strips trailing slash', () {
      expect(
        UrlNormalizer.normalize('example.com:8080/'),
        'http://example.com:8080',
      );
    });

    test('keeps https and path, trims spaces', () {
      expect(
        UrlNormalizer.normalize('  https://example.com/panel// '),
        'https://example.com/panel',
      );
    });

    test('rejects empty and malformed input', () {
      expect(UrlNormalizer.normalize(''), isNull);
      expect(UrlNormalizer.normalize('   '), isNull);
      expect(UrlNormalizer.normalize('http://'), isNull);
      expect(UrlNormalizer.normalize('ftp://example.com'), isNull);
    });
  });
}
