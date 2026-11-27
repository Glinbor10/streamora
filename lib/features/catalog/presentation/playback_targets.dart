import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/player/domain/playback.dart';

/// Opens the player for [target].
void play(BuildContext context, PlaybackTarget target) =>
    context.push('/player', extra: target);

/// Target for a live channel.
PlaybackTarget liveTarget(CatalogRepository repo, LiveChannel channel) =>
    PlaybackTarget(
      kind: PlaybackKind.live,
      id: channel.id,
      title: channel.title,
      url: repo.liveUrl(channel),
    );

/// Target for a movie.
PlaybackTarget movieTarget(CatalogRepository repo, Movie movie) =>
    PlaybackTarget(
      kind: PlaybackKind.movie,
      id: movie.id,
      title: movie.title,
      subtitle: movie.year,
      url: repo.movieUrl(movie),
    );

/// Target for [episode] of [detail], with every later episode queued.
PlaybackTarget episodeTarget(
  CatalogRepository repo,
  SeriesDetail detail,
  Episode episode,
) {
  final ordered = [
    for (final season in detail.seasons) ...?detail.episodesBySeason[season],
  ];
  PlaybackTarget build(Episode e) => PlaybackTarget(
    kind: PlaybackKind.episode,
    id: e.id,
    title: detail.series.title,
    subtitle: 'S${e.season} E${e.number} · ${e.title}',
    seriesId: detail.series.id,
    url: repo.episodeUrl(e),
  );

  final index = ordered.indexWhere((e) => e.id == episode.id);
  final following = index < 0 ? <Episode>[] : ordered.skip(index + 1);
  return build(episode).withUpNext([for (final e in following) build(e)]);
}
