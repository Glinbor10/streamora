import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/logo.dart';

/// Login form with a secondary Demo Mode button.
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _server.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final failure = await ref
        .read(authControllerProvider.notifier)
        .login(
          server: _server.text,
          username: _username.text,
          password: _password.text,
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = failure == null ? null : _message(failure.type);
    });
  }

  static String _message(AuthFailureType type) => switch (type) {
    AuthFailureType.invalidUrl => 'The server address is not valid.',
    AuthFailureType.network =>
      'Could not reach the server. Check your connection and try again.',
    AuthFailureType.unauthorized => 'Invalid username or password.',
    AuthFailureType.expiredAccount => 'This account is expired or disabled.',
    AuthFailureType.unknown => 'Something went wrong. Please try again.',
  };

  static String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: StreamoraLogo(size: 84)),
                  const SizedBox(height: 16),
                  Text(
                    'Streamore',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All your streams, one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const Key('server'),
                    controller: _server,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Server',
                      hintText: 'example.com:8080',
                    ),
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('username'),
                    controller: _username,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('password'),
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: _required,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      key: const Key('error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('login'),
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    key: const Key('demo'),
                    onPressed: _busy
                        ? null
                        : ref.read(authControllerProvider.notifier).startDemo,
                    child: const Text('Demo Mode'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
