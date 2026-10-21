import 'package:devops_learning_tracker/screens/about_screen.dart';
import 'package:devops_learning_tracker/screens/dashboard_screen.dart';
import 'package:devops_learning_tracker/screens/projects_screen.dart';
import 'package:devops_learning_tracker/screens/tasks_screen.dart';
import 'package:devops_learning_tracker/state/app_state.dart';
import 'package:flutter/material.dart';

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = [
  _Destination('Dashboard', Icons.dashboard_outlined, Icons.dashboard),
  _Destination('Learning Tasks', Icons.task_alt_outlined, Icons.task_alt),
  _Destination('Projects', Icons.folder_outlined, Icons.folder),
  _Destination('About', Icons.info_outline, Icons.info),
];

/// The frame around every page: top bar plus navigation menu.
///
/// Navigation is a simple "selected index", so the browser URL never changes
/// and no Amplify rewrite rule is needed.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final AppState _state = AppState();
  int _index = 0;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  Widget _currentPage() {
    return switch (_index) {
      0 => DashboardScreen(state: _state),
      1 => TasksScreen(state: _state),
      2 => ProjectsScreen(state: _state),
      _ => const AboutScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isWide = width >= 1000;

    final page = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: ListenableBuilder(
            listenable: _state,
            builder: (context, _) => _currentPage(),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('DevOps Learning Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isMobile
          ? page
          : Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  extended: isWide,
                  labelType: isWide ? null : NavigationRailLabelType.all,
                  destinations: [
                    for (final d in _destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: page),
              ],
            ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final d in _destinations)
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
              ],
            )
          : null,
    );
  }
}
