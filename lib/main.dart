import 'package:material_ui/material_ui.dart';

void main() => runApp(const StreamoraApp());

/// Root widget of the streamora application.
class StreamoraApp extends StatelessWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'streamora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('streamora'))),
    );
  }
}
