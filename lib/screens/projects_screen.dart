import 'package:devops_learning_tracker/models/models.dart';
import 'package:devops_learning_tracker/state/app_state.dart';
import 'package:devops_learning_tracker/widgets/page_header.dart';
import 'package:devops_learning_tracker/widgets/responsive_grid.dart';
import 'package:devops_learning_tracker/widgets/status_chip.dart';
import 'package:flutter/material.dart';

/// Page listing practical projects, with a status filter.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key, required this.state});

  final AppState state;

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  /// null means "show all projects".
  ProjectStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final visible = state.projects
        .where((p) => _filter == null || p.status == _filter)
        .toList();

    return ListView(
      children: [
        const PageHeader(
          title: 'Projects',
          subtitle: 'Hands-on projects and how far along each one is.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: Text('All (${state.projects.length})'),
              selected: _filter == null,
              onSelected: (_) => setState(() => _filter = null),
            ),
            for (final status in ProjectStatus.values)
              ChoiceChip(
                label: Text('${status.label} (${state.projectCount(status)})'),
                selected: _filter == status,
                onSelected: (_) => setState(() => _filter = status),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          const Text('No projects with this status yet.')
        else
          ResponsiveGrid(
            minItemWidth: 320,
            children: [
              for (final project in visible)
                _ProjectCard(
                  project: project,
                  onStatusChanged: (status) {
                    state.setProjectStatus(project, status);
                  },
                ),
            ],
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onStatusChanged});

  final ProjectItem project;
  final ValueChanged<ProjectStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<ProjectStatus>(
                  tooltip: 'Change status',
                  onSelected: onStatusChanged,
                  itemBuilder: (context) => [
                    for (final status in ProjectStatus.values)
                      PopupMenuItem<ProjectStatus>(
                        value: status,
                        child: Text(status.label),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(project.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(status: project.status),
                Text(project.topic, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
