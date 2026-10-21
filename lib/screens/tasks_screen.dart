import 'package:devops_learning_tracker/models/models.dart';
import 'package:devops_learning_tracker/state/app_state.dart';
import 'package:devops_learning_tracker/widgets/page_header.dart';
import 'package:flutter/material.dart';

/// Page with a form to add learning tasks and the list of existing tasks.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.state});

  final AppState state;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late String _selectedTopic = widget.state.topics.first.name;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    widget.state.addTask(_titleController.text.trim(), _selectedTopic);
    form.reset(); // clears the text field
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;

    return ListView(
      children: [
        const PageHeader(
          title: 'Learning Tasks',
          subtitle: 'Add small tasks and tick them off as you learn.',
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add a learning task', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task title',
                      hintText: 'e.g. Deploy an app with Amplify',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  Text('Topic', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final topic in state.topics)
                        ChoiceChip(
                          label: Text(topic.name),
                          selected: _selectedTopic == topic.name,
                          onSelected: (_) {
                            setState(() => _selectedTopic = topic.name);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add),
                    label: const Text('Add task'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your tasks (${state.completedTasks}/${state.tasks.length} done)',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (state.tasks.isEmpty)
          const Text('No tasks yet. Add your first one above.')
        else
          for (final task in state.tasks)
            _TaskTile(
              task: task,
              onToggle: () => state.toggleTask(task),
              onDelete: () => state.removeTask(task),
            ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final LearningTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          style: task.done
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(task.topic),
        trailing: IconButton(
          tooltip: 'Delete task',
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
