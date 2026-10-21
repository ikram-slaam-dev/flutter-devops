import 'package:devops_learning_tracker/models/models.dart';
import 'package:flutter/material.dart';

/// Sample data that lives inside the app. No database or backend is used.

List<LearningTopic> sampleTopics() {
  return [
    LearningTopic(
      name: 'AWS',
      description: 'Cloud basics: EC2, S3, IAM and Amplify Hosting.',
      icon: Icons.cloud_outlined,
      color: Colors.yellow,
      progress: 0.55,
    ),
    LearningTopic(
      name: 'Docker',
      description: 'Containers, images, Dockerfiles and Compose.',
      icon: Icons.inventory_2_outlined,
      color: Colors.blue,
      progress: 0.40,
    ),
    LearningTopic(
      name: 'Linux',
      description: 'The shell, permissions, services and networking.',
      icon: Icons.terminal,
      color: Colors.teal,
      progress: 0.70,
    ),
    LearningTopic(
      name: 'Git/GitHub',
      description: 'Commits, branches, remotes and pull requests.',
      icon: Icons.merge_type,
      color: Colors.red,
      progress: 0.80,
    ),
    LearningTopic(
      name: 'CI/CD',
      description: 'Automated build, test and deploy pipelines.',
      icon: Icons.autorenew,
      color: Colors.purple,
      progress: 0.35,
    ),
    LearningTopic(
      name: 'Kubernetes',
      description: 'Pods, deployments, services and kubectl.',
      icon: Icons.hub_outlined,
      color: Colors.indigo,
      progress: 0.10,
    ),
  ];
}

List<LearningTask> sampleTasks() {
  return [
    LearningTask(
      title: 'Launch a free-tier EC2 instance',
      topic: 'AWS',
      done: true,
    ),
    LearningTask(
      title: 'Write a Dockerfile for a small web app',
      topic: 'Docker',
    ),
    LearningTask(
      title: 'Practice chmod and chown on test files',
      topic: 'Linux',
      done: true,
    ),
    LearningTask(
      title: 'Open and merge a pull request',
      topic: 'Git/GitHub',
      done: true,
    ),
    LearningTask(
      title: 'Create a GitHub Actions workflow',
      topic: 'CI/CD',
    ),
    LearningTask(
      title: 'Read the Kubernetes Pods overview',
      topic: 'Kubernetes',
    ),
  ];
}

List<ProjectItem> sampleProjects() {
  return [
    ProjectItem(
      title: 'Deploy a PHP app on EC2',
      description: 'Serve a PHP app with Nginx and Apache2 on an EC2 server.',
      topic: 'AWS',
      status: ProjectStatus.completed,
    ),
    ProjectItem(
      title: 'Deploy a Flutter app on AWS Amplify',
      description: 'Build Flutter for the web and host it through GitHub.',
      topic: 'AWS',
      status: ProjectStatus.inProgress,
    ),
    ProjectItem(
      title: 'CI/CD pipeline for a Flask app',
      description: 'Run tests and deploy automatically with GitHub Actions.',
      topic: 'CI/CD',
      status: ProjectStatus.inProgress,
    ),
    ProjectItem(
      title: 'Automate backups with cron',
      description: 'Write a shell script and schedule it on a Linux server.',
      topic: 'Linux',
      status: ProjectStatus.completed,
    ),
    ProjectItem(
      title: 'Containerize a web app',
      description: 'Package an app with Docker and run it with Compose.',
      topic: 'Docker',
      status: ProjectStatus.notStarted,
    ),
    ProjectItem(
      title: 'Run a first app on Minikube',
      description: 'Create a local cluster and deploy a simple workload.',
      topic: 'Kubernetes',
      status: ProjectStatus.notStarted,
    ),
  ];
}
