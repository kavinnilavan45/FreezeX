import 'package:flutter_test/flutter_test.dart';
import 'package:freezex/main.dart';

void main() {
  testWidgets('FreezeX app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FreezeXApp());

    expect(find.text('FreezeX'), findsWidgets);
  });
}