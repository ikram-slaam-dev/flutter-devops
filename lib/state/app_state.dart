import 'package:devops_learning_tracker/data/sample_data.dart';
import 'package:devops_learning_tracker/models/models.dart';
import 'package:flutter/foundation.dart';

/// Holds all app data in memory and tells the UI when something changes.
///
/// Extending [ChangeNotifier] lets widgets listen for changes without
/// needing any extra package.
class AppState extends ChangeNotifier {
  AppState()
      : topics = sampleTopics(),
        tasks = sampleTasks(),
        projects = sampleProjects();

  final List<LearningTopic> topics;
  final List<LearningTask> tasks;
  final List<ProjectItem> projects;

  /// Average progress of all topics (0.0 to 1.0).
  double get overallProgress {
    if (topics.isEmpty) return 0;
    final total = topics.fold<double>(0, (sum, t) => sum + t.progress);
    return total / topics.length;
  }

  int get completedTasks => tasks.where((t) => t.done).length;

  int projectCount(ProjectStatus status) {
    return projects.where((p) => p.status == status).length;
  }

  void addTask(String title, String topic) {
    tasks.insert(0, LearningTask(title: title, topic: topic));
    notifyListeners();
  }

  void toggleTask(LearningTask task) {
    task.done = !task.done;
    notifyListeners();
  }

  void removeTask(LearningTask task) {
    tasks.remove(task);
    notifyListeners();
  }

  void changeProgress(LearningTopic topic, double delta) {
    topic.progress = (topic.progress + delta).clamp(0.0, 1.0).toDouble();
    notifyListeners();
  }

  void setProjectStatus(ProjectItem project, ProjectStatus status) {
    project.status = status;
    notifyListeners();
  }
}
