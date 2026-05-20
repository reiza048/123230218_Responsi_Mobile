import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_mobile/main.dart';

void main() {
  testWidgets('Boot screen loads LoginPage when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('suka Games'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
  });
}
