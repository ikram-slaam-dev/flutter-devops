import 'package:flutter/material.dart';

/// The three states a practical project can be in.
enum ProjectStatus {
  notStarted('Not Started', Colors.blueGrey),
  inProgress('In Progress', Colors.orange),
  completed('Completed', Colors.green);

  const ProjectStatus(this.label, this.color);

  final String label;
  final MaterialColor color;
}

/// One learning topic shown as a card (AWS, Docker, ...).
class LearningTopic {
  LearningTopic({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;

  /// A number from 0.0 (nothing done) to 1.0 (finished).
  double progress;
}

/// A small to-do item related to one topic.
class LearningTask {
  LearningTask({
    required this.title,
    required this.topic,
    this.done = false,
  });

  final String title;
  final String topic;
  bool done;
}

/// A practical hands-on project.
class ProjectItem {
  ProjectItem({
    required this.title,
    required this.description,
    required this.topic,
    required this.status,
  });

  final String title;
  final String description;
  final String topic;
  ProjectStatus status;
}
