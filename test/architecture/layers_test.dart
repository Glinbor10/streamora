import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Architecture rules: enforces layer isolation by inspecting imports.
///
/// Layout: lib/features/(feature)/{domain,data,presentation}, lib/shared.
void main() {
  final importRe = RegExp(r'''^\s*(?:import|export)\s+["']([^"']+)["']''');
  final dartFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  String norm(String p) => p.replaceAll(r'\', '/');

  /// Resolves an import to a path relative to the repo root (lib/...),
  /// or null when it is not a project import.
  String? resolve(File file, String uri) {
    if (uri.startsWith('package:streamora/')) {
      return 'lib/${uri.substring('package:streamora/'.length)}';
    }
    if (uri.startsWith('package:') || uri.startsWith('dart:')) {
      return null;
    }
    final dir = norm(file.parent.path);
    final parts = [...dir.split('/'), ...uri.split('/')];
    final out = <String>[];
    for (final p in parts) {
      if (p == '..') {
        if (out.isNotEmpty) out.removeLast();
      } else if (p != '.' && p.isNotEmpty) {
        out.add(p);
      }
    }
    return out.join('/');
  }

  final featureRe = RegExp('^lib/features/([^/]+)/([^/]+)/');

  List<String> violations(
    bool Function(String from, String? uri, String? to) isViolation,
  ) {
    final result = <String>[];
    for (final file in dartFiles) {
      final from = norm(file.path);
      for (final line in file.readAsLinesSync()) {
        final m = importRe.firstMatch(line);
        if (m == null) continue;
        final uri = m.group(1)!;
        if (isViolation(from, uri, resolve(file, uri))) {
          result.add('$from -> $uri');
        }
      }
    }
    return result;
  }

  test('domain layer is pure Dart (no Flutter, data or presentation)', () {
    final v = violations((from, uri, to) {
      final f = featureRe.firstMatch(from);
      if (f == null || f.group(2) != 'domain') return false;
      if (uri!.startsWith('package:flutter/')) return true;
      final t = to == null ? null : featureRe.firstMatch(to);
      return t != null && t.group(2) != 'domain';
    });
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('data layer depends only on domain', () {
    final v = violations((from, uri, to) {
      final f = featureRe.firstMatch(from);
      if (f == null || f.group(2) != 'data') return false;
      final t = to == null ? null : featureRe.firstMatch(to);
      return t != null && t.group(2) == 'presentation';
    });
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('features only import other features through their domain', () {
    final v = violations((from, uri, to) {
      final f = featureRe.firstMatch(from);
      final t = to == null ? null : featureRe.firstMatch(to);
      if (f == null || t == null) return false;
      return f.group(1) != t.group(1) && t.group(2) != 'domain';
    });
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('shared never imports features', () {
    final v = violations((from, uri, to) {
      if (!from.startsWith('lib/shared/')) return false;
      return to != null && to.startsWith('lib/features/');
    });
    expect(v, isEmpty, reason: v.join('\n'));
  });
}
