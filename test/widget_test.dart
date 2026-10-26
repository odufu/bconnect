import 'package:flutter_test/flutter_test.dart';
import 'package:bconnect/main.dart';

void main() {
  testWidgets('BConnect App loads splash screen and choice cards', (WidgetTester tester) async {
    await tester.pumpWidget(const BConnectApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('What do you want'), findsOneWidget);
    expect(find.text('BUY'), findsOneWidget);
    expect(find.text('SELL'), findsOneWidget);
  });
}
