import 'package:meta/meta.dart';

/// What kind of content is being played.
enum PlaybackKind {
  /// A live TV channel (no progress is stored).
  live,

  /// A movie.
  movie,

  /// An episode of a series.
  episode,
}

/// Everything the player needs to start an item.
///
/// Holds the playback URL, which may embed credentials: never log it and
/// never persist it.
@immutable
class PlaybackTarget {
  /// Creates a target.
  const new({
    required this.kind,
    required this.id,
    required this.title,
    required this.url,
    this.subtitle,
    this.seriesId,
    this.upNext = const [],
  });

  /// Kind of content.
  final PlaybackKind kind;

  /// Identifier inside its kind (stream or episode id).
  final int id;

  /// Title shown in the player.
  final String title;

  /// Playback URL.
  final String url;

  /// Secondary line, such as "S1 E3".
  final String? subtitle;

  /// Series the episode belongs to, for episodes.
  final int? seriesId;

  /// Episodes that follow this one, in playback order.
  final List<PlaybackTarget> upNext;

  /// Key under which progress is stored; null for live TV.
  String? get progressKey =>
      kind == PlaybackKind.live ? null : '${kind.name}:$id';

  /// Copy with a different queue of following episodes.
  PlaybackTarget withUpNext(List<PlaybackTarget> next) => PlaybackTarget(
    kind: kind,
    id: id,
    title: title,
    url: url,
    subtitle: subtitle,
    seriesId: seriesId,
    upNext: next,
  );
}

/// Saved watching position of a movie or episode.
@immutable
class WatchProgress {
  /// Creates a progress entry.
  const new({
    required this.key,
    required this.kind,
    required this.id,
    required this.title,
    required this.positionMs,
    required this.durationMs,
    required this.updatedAtMs,
    this.subtitle,
    this.seriesId,
  });

  /// Restores an entry from [json].
  factory fromJson(Map<String, dynamic> json) => WatchProgress(
    key: json['key'] as String,
    kind: PlaybackKind.values.byName(json['kind'] as String),
    id: json['id'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String?,
    seriesId: json['seriesId'] as int?,
    positionMs: json['positionMs'] as int,
    durationMs: json['durationMs'] as int,
    updatedAtMs: json['updatedAtMs'] as int,
  );

  /// Storage key, `kind:id`.
  final String key;

  /// Movie or episode.
  final PlaybackKind kind;

  /// Identifier inside its kind.
  final int id;

  /// Title at the time of saving.
  final String title;

  /// Secondary line, such as "S1 E3".
  final String? subtitle;

  /// Series id for episodes.
  final int? seriesId;

  /// Last position in milliseconds.
  final int positionMs;

  /// Total duration in milliseconds.
  final int durationMs;

  /// When it was saved, milliseconds since epoch.
  final int updatedAtMs;

  /// Fraction watched from 0 to 1.
  double get fraction =>
      durationMs <= 0 ? 0 : (positionMs / durationMs).clamp(0, 1);

  /// Serializes the entry. Never contains a URL.
  Map<String, dynamic> toJson() => {
    'key': key,
    'kind': kind.name,
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'seriesId': seriesId,
    'positionMs': positionMs,
    'durationMs': durationMs,
    'updatedAtMs': updatedAtMs,
  };
}
