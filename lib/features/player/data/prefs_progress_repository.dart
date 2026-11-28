import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/domain/progress_repository.dart';
import 'package:streamora/features/player/domain/resume_policy.dart';

/// Reads the stored JSON blob, or null when empty.
typedef BlobReader = Future<String?> Function();

/// Writes the JSON blob.
typedef BlobWriter = Future<void> Function(String value);

const _prefsKey = 'watch_progress';

Future<String?> _readPrefs() => SharedPreferencesAsync().getString(_prefsKey);

Future<void> _writePrefs(String value) =>
    SharedPreferencesAsync().setString(_prefsKey, value);

/// [ProgressRepository] storing one JSON list in shared preferences.
///
/// Reader and writer are injectable so it can be tested without plugins.
class PrefsProgressRepository implements ProgressRepository {
  /// Creates the repository.
  new({BlobReader reader = _readPrefs, BlobWriter writer = _writePrefs})
    : _read = reader,
      _write = writer;

  final BlobReader _read;
  final BlobWriter _write;

  @override
  Future<List<WatchProgress>> all() async {
    final raw = await _read();
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = [
        for (final item in jsonDecode(raw) as List<dynamic>)
          WatchProgress.fromJson(item as Map<String, dynamic>),
      ]..sort((a, b) => b.updatedAtMs.compareTo(a.updatedAtMs));
      return list;
    } on Object {
      // Corrupted data must never break the app.
      return [];
    }
  }

  @override
  Future<WatchProgress?> get(String key) async {
    for (final entry in await all()) {
      if (entry.key == key) return entry;
    }
    return null;
  }

  @override
  Future<void> save(WatchProgress progress) async {
    final entries = (await all())
      ..removeWhere((e) => e.key == progress.key)
      ..insert(0, progress);
    await _persist(entries.take(ResumePolicy.maxEntries).toList());
  }

  @override
  Future<void> remove(String key) async {
    final entries = (await all())..removeWhere((e) => e.key == key);
    await _persist(entries);
  }

  @override
  Future<void> clear() => _persist(const []);

  Future<void> _persist(List<WatchProgress> entries) =>
      _write(jsonEncode([for (final e in entries) e.toJson()]));
}
