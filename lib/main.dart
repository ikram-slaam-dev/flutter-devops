import 'package:devops_learning_tracker/screens/app_shell.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DevOpsTrackerApp());
}

/// The root widget of the application.
class DevOpsTrackerApp extends StatelessWidget {
  const DevOpsTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevOps Learning Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
