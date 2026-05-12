import 'package:flutter_test/flutter_test.dart';
import 'package:orange_money_app/main.dart';

void main() {
  testWidgets('Orange Money app displays title', (WidgetTester tester) async {
    await tester.pumpWidget(const OrangeMoneyApp());

    // Verify that the app title appears in the AppBar
    expect(find.text('Orange Money'), findsOneWidget);
  });

  testWidgets('Balance card displays correct amount', (WidgetTester tester) async {
    await tester.pumpWidget(const OrangeMoneyApp());

    // Verify balance amount is displayed
    expect(find.text('50,000 XAF'), findsOneWidget);
    expect(find.text('Available Balance'), findsOneWidget);
  });

  testWidgets('Quick action buttons are present', (WidgetTester tester) async {
    await tester.pumpWidget(const OrangeMoneyApp());

    // Verify quick action buttons
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);
    expect(find.text('Recharge'), findsOneWidget);
  });

  testWidgets('Recent transactions section has items', (WidgetTester tester) async {
    await tester.pumpWidget(const OrangeMoneyApp());

    // Verify some transaction items
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('Send Money'), findsOneWidget);
    expect(find.text('Merchant Payment'), findsOneWidget);
  });

  testWidgets('Bottom navigation bar has three items', (WidgetTester tester) async {
    await tester.pumpWidget(const OrangeMoneyApp());

    // Verify bottom navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
