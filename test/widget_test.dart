import 'package:devops_learning_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the dashboard and can open Projects', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DevOpsTrackerApp());

    expect(find.text('DevOps Learning Tracker'), findsOneWidget);
    expect(find.text('Learning topics'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Projects'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Deploy a Flutter app on AWS Amplify'), findsOneWidget);
  });
}
