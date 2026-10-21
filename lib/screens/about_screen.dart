import 'package:devops_learning_tracker/widgets/page_header.dart';
import 'package:flutter/material.dart';

/// Static page that explains the app and how it reaches the web.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _tech = [
    'Flutter',
    'Dart',
    'Material 3',
    'GitHub',
    'AWS Amplify Hosting',
  ];

  static const _steps = [
    'You write Dart code and push it to GitHub.',
    'Amplify notices the push and starts a build.',
    'The build downloads Flutter and runs flutter pub get.',
    'flutter build web --release turns the Dart code into HTML, CSS and JavaScript.',
    'Amplify publishes the build/web folder as your website.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        const PageHeader(
          title: 'About',
          subtitle: 'What this app is and how it is deployed.',
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DevOps Learning Tracker', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text(
                  'A small practice project for learning DevOps and AWS. '
                  'It tracks topics, tasks and hands-on projects.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'All data is sample data kept in memory. There is no backend '
                  'or database, so changes reset when you refresh the page.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Built with', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final name in _tech) Chip(label: Text(name)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From code to website', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                for (var i = 0; i < _steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_steps[i])),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
