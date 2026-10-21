import 'package:devops_learning_tracker/models/models.dart';
import 'package:flutter/material.dart';

/// A card showing one learning topic with a progress bar.
class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, required this.onChange});

  final LearningTopic topic;

  /// Called with +0.1 or -0.1 when the user taps the plus / minus buttons.
  final ValueChanged<double> onChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (topic.progress * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: topic.color.withValues(alpha: 0.15),
                  child: Icon(topic.icon, color: topic.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    topic.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text('$percent%', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(topic.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: topic.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: topic.color,
              backgroundColor: topic.color.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Decrease progress by 10%',
                  onPressed: topic.progress <= 0 ? null : () => onChange(-0.1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  tooltip: 'Increase progress by 10%',
                  onPressed: topic.progress >= 1 ? null : () => onChange(0.1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
