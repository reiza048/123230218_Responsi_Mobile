import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_mobile/main.dart';

void main() {
  testWidgets('Boot screen loads LoginPage when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify that the login page title "Hydra Games" is shown
    expect(find.text('Hydra Games'), findsOneWidget);

    // Verify that login button is displayed
    expect(find.text('Login'), findsOneWidget);

    // Verify that email input field exists
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
  });
}
