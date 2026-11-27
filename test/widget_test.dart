import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/main.dart';

void main() {
  testWidgets('app shows its name', (tester) async {
    await tester.pumpWidget(const StreamoraApp());
    expect(find.text('streamora'), findsOneWidget);
  });
}
