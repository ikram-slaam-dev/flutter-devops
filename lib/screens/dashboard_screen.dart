import 'package:devops_learning_tracker/models/models.dart';
import 'package:devops_learning_tracker/state/app_state.dart';
import 'package:devops_learning_tracker/widgets/page_header.dart';
import 'package:devops_learning_tracker/widgets/responsive_grid.dart';
import 'package:devops_learning_tracker/widgets/stat_card.dart';
import 'package:devops_learning_tracker/widgets/topic_card.dart';
import 'package:flutter/material.dart';

/// Overview page: overall progress, quick numbers and one card per topic.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        const PageHeader(
          title: 'Dashboard',
          subtitle: 'Your DevOps learning progress at a glance.',
        ),
        _OverallCard(progress: state.overallProgress),
        const SizedBox(height: 16),
        ResponsiveGrid(
          minItemWidth: 220,
          children: [
            StatCard(
              icon: Icons.task_alt,
              label: 'Tasks completed',
              value: '${state.completedTasks} / ${state.tasks.length}',
            ),
            StatCard(
              icon: Icons.play_circle_outline,
              label: 'Projects in progress',
              value: state.projectCount(ProjectStatus.inProgress).toString(),
            ),
            StatCard(
              icon: Icons.verified_outlined,
              label: 'Projects completed',
              value: state.projectCount(ProjectStatus.completed).toString(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Learning topics', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 300,
          children: [
            for (final topic in state.topics)
              TopicCard(
                topic: topic,
                onChange: (delta) => state.changeProgress(topic, delta),
              ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (progress * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall progress', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '$percent%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
