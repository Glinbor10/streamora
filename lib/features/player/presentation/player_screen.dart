import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/domain/progress_repository.dart';
import 'package:streamora/features/player/domain/resume_policy.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';
import 'package:streamora/shared/user_agent_client.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Full-screen video player for live TV, movies and episodes.
class PlayerScreen extends ConsumerStatefulWidget {
  /// Creates the player for [target].
  const new({required this.target, super.key});

  /// What to play.
  final PlaybackTarget target;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final Player _player = Player();
  late final VideoController _controller = VideoController(_player);
  late final ProgressRepository _repo = ref.read(progressRepositoryProvider);
  late final ProviderContainer _container = ProviderScope.containerOf(context);
  late PlaybackTarget _target = widget.target;
  final List<StreamSubscription<Object?>> _subs = [];
  Timer? _saveTimer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _failed = false;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    _subs
      ..add(_player.stream.position.listen((p) => _position = p))
      ..add(_player.stream.duration.listen((d) => _duration = d))
      ..add(
        _player.stream.error.listen((_) {
          if (mounted) setState(() => _failed = true);
        }),
      )
      ..add(
        _player.stream.completed.listen((done) {
          if (done) unawaited(_onCompleted());
        }),
      );
    _saveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => unawaited(_save()),
    );
    unawaited(_open());
  }

  Future<void> _open() async {
    if (mounted) {
      setState(() {
        _failed = false;
        _ended = false;
      });
    }
    final key = _target.progressKey;
    final saved = key == null ? null : await _repo.get(key);
    final start = ResumePolicy.resumeAt(saved);
    try {
      await _player.open(
        Media(
          _target.url,
          httpHeaders: {'User-Agent': xtreamUserAgent},
          start: start == Duration.zero ? null : start,
        ),
      );
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _save() async {
    final key = _target.progressKey;
    if (key == null) return;
    if (!ResumePolicy.shouldTrack(_position, _duration)) return;
    if (ResumePolicy.isFinished(_position, _duration)) {
      await _repo.remove(key);
    } else {
      await _repo.save(
        WatchProgress(
          key: key,
          kind: _target.kind,
          id: _target.id,
          title: _target.title,
          subtitle: _target.subtitle,
          seriesId: _target.seriesId,
          positionMs: _position.inMilliseconds,
          durationMs: _duration.inMilliseconds,
          updatedAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    _container.invalidate(continueWatchingProvider);
  }

  Future<void> _onCompleted() async {
    await _save();
    if (mounted && _target.upNext.isNotEmpty) {
      setState(() => _ended = true);
    }
  }

  Future<void> _playNext() async {
    final next = _target.upNext.first;
    _target = next.withUpNext(_target.upNext.skip(1).toList());
    _position = Duration.zero;
    _duration = Duration.zero;
    await _open();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    unawaited(_save());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Video(controller: _controller),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filledTonal(
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
          if (_failed)
            ColoredBox(
              color: Colors.black,
              child: ErrorView(
                message: 'This stream could not be played.',
                onRetry: _open,
              ),
            ),
          if (_ended && _target.upNext.isNotEmpty)
            Positioned(
              right: 24,
              bottom: 96,
              child: FilledButton.icon(
                onPressed: _playNext,
                icon: const Icon(Icons.skip_next),
                label: Text('Next: ${_target.upNext.first.subtitle ?? ''}'),
              ),
            ),
        ],
      ),
    );
  }
}
