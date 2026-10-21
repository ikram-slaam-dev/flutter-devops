# DevOps Learning Tracker (Flutter Web + AWS Amplify Hosting)

A beginner-friendly Flutter web app that tracks DevOps learning progress. It has a dashboard, topic cards with progress bars, a task form, a project list with statuses, and an About page. Data is sample data kept in memory: no backend, no database, no paid services.

## Project structure

```
devops_learning_tracker/
├── amplify.yml                  # Amplify build instructions
├── pubspec.yaml                 # Flutter project + dependencies
├── analysis_options.yaml        # Lint rules used by `flutter analyze`
├── .gitignore
├── README.md
├── lib/
│   ├── main.dart                # App entry point + theme
│   ├── models/models.dart       # Topic, Task, Project classes + ProjectStatus
│   ├── data/sample_data.dart    # Local sample data
│   ├── state/app_state.dart     # In-memory state (ChangeNotifier)
│   ├── screens/
│   │   ├── app_shell.dart       # Top bar + responsive navigation
│   │   ├── dashboard_screen.dart
│   │   ├── tasks_screen.dart    # "Learning Tasks" page with the add-task form
│   │   ├── projects_screen.dart
│   │   └── about_screen.dart
│   └── widgets/                 # Small reusable pieces (cards, chips, grid)
├── test/widget_test.dart
└── web/                         # index.html, manifest.json, favicon + icons
```

## 1. Run locally

Install Flutter ([docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)), then:

```bash
cd devops_learning_tracker
flutter doctor            # check Flutter + Chrome are ready
flutter pub get
flutter analyze
flutter run -d chrome
```

If you prefer not to open Chrome automatically: `flutter run -d web-server --web-port 8080`, then open http://localhost:8080.

This project only contains the `web/` platform. That is all Amplify needs.

## 2. Test the production build locally

```bash
flutter build web --release
```

The website is created in `build/web/`. Serve that folder (Python is enough):

```bash
# Linux / macOS / WSL
python3 -m http.server 8080 --directory build/web

# Windows PowerShell
python -m http.server 8080 --directory build\web
```

Open http://localhost:8080. This is exactly what Amplify will host.

## 3. Push to GitHub

Create an empty repository on GitHub first (no README, no .gitignore), for example `devops-learning-tracker`. Then:

```bash
cd devops_learning_tracker
git init
git branch -M main
git add .
git commit -m "Initial commit: DevOps Learning Tracker Flutter web app"
git remote add origin https://github.com/<YOUR-USERNAME>/devops-learning-tracker.git
git push -u origin main
```

`.gitignore` already excludes `build/`, `.dart_tool/`, and IDE files. Check with `git status` before committing that `build/` is not listed.

## 4. How `amplify.yml` works

Amplify's build image does **not** include Flutter, so `amplify.yml` downloads it:

| Phase | What it does |
|---|---|
| `preBuild` | Sets `FLUTTER_VERSION=3.35.0`, clones that exact tag from GitHub into `$HOME/flutter`, adds it to `PATH`, runs `flutter precache --web` and `flutter pub get` |
| `build` | Runs `flutter analyze --no-fatal-infos` (errors and warnings fail the build) then `flutter build web --release` |
| `artifacts` | Publishes everything in `build/web/` (`baseDirectory: build/web`, `files: '**/*'`) |

No custom build image is needed. The standard Amplify Linux image already has `git` and `curl`, which is all the Flutter download requires.

To change the Flutter version, edit `FLUTTER_VERSION` in `amplify.yml` to another release tag (list them with `git ls-remote --tags https://github.com/flutter/flutter.git`). Use a tag, not `stable`, so builds stay reproducible.

## 5. Deploy on AWS Amplify (Console)

1. Sign in to the AWS Console and open **AWS Amplify**.
2. Click **Create new app** (or **Deploy an app**).
3. Choose **GitHub** as the source and click **Next**. Authorize the AWS Amplify GitHub app when asked, and allow it to access your repository.
4. Select your repository (`devops-learning-tracker`) and the branch **main**. Click **Next**.
5. On the **App settings** page, give the app a name. Amplify finds `amplify.yml` in the repository root and uses it. If the build settings editor shows different commands, replace them with the contents of `amplify.yml`, or confirm the repository file is used (the console says it detected a build configuration file).
6. Click **Next**, review, then **Save and deploy**.
7. Watch the pipeline: **Provision → Build → Deploy → Verify**. The first build takes a few minutes because it downloads Flutter.

### Verify the build settings and artifact directory

- **Hosting → Build settings** (or **App settings → Build settings**) shows the active configuration. Confirm `baseDirectory` is `build/web`.
- Open the **Build** step logs. You should see `Flutter 3.35.0`, `Got dependencies!`, `No issues found!` from analyze, and `Built build/web`.
- In the **Deploy** step, Amplify reports the files it uploaded from the artifact directory.

### Verify the deployed website

1. Click the app's URL (like `https://main.xxxxxxxx.amplifyapp.com`).
2. You should see the Dashboard with six topic cards.
3. Click through Learning Tasks, Projects and About.
4. Add a task and check it appears in the list.
5. Resize the browser: a bottom navigation bar on phones, a side rail on tablets and desktops.
6. Refresh the page on any section: it reloads normally.

## 6. Routing: is a rewrite/redirect rule needed?

**No.** This app switches pages with a simple selected-tab variable, so the URL is always `/`. Refreshing never asks the server for a path that doesn't exist, so there is no Amplify 404 problem and no rule to add.

If you later add URL routing (for example `go_router` with `/projects`), add this single-page-app rule under **Hosting → Rewrites and redirects → Manage redirects**:

- **Source address:**
  ```
  </^[^.]+$|\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json|webp|wasm)$)([^.]+$)/>
  ```
- **Target address:** `/index.html`
- **Type:** `200 (Rewrite)`

Also consider Flutter's hash URL strategy as a simpler alternative.

## 7. Troubleshooting

**Flutter download fails in the build (`Remote branch 3.35.0 not found`)**
The tag doesn't exist. Check with `git ls-remote --tags https://github.com/flutter/flutter.git` and update `FLUTTER_VERSION`.

**`flutter: command not found` in the build phase**
`PATH` is set per phase. Make sure `export PATH="$HOME/flutter/bin:$PATH"` is the first command of the `build` phase.

**Dart SDK download is slow or times out**
Retry the build. It downloads about 200 MB the first time.

**"Running Flutter as root" warning**
Harmless. Amplify builds run as root.

**`pub get` fails: "version solving failed" or SDK constraint error**
Your Flutter version is older than `pubspec.yaml` requires (`sdk: ^3.6.0`). Use Flutter 3.27 or newer, locally and in `amplify.yml`. Delete `pubspec.lock` and run `flutter pub get` again if packages conflict.

**`flutter analyze` fails the build**
Read the log: lines marked `error` or `warning` must be fixed. Reproduce locally with `flutter analyze`. Info-level hints don't fail the build because of `--no-fatal-infos`.

**Build succeeds but the site shows a 404 or empty page**
Open **Build settings** and check `baseDirectory: build/web`. A wrong folder name, or a missing `web/index.html` in the repo, is the usual cause.

**Blank white page after deploy**
Open the browser DevTools console. Flutter web loads its rendering engine (CanvasKit) from Google's CDN by default, so the browser needs internet access. Also check the `<base href>` in `web/index.html` was left as `$FLUTTER_BASE_HREF`.

**GitHub repo not listed in Amplify**
In GitHub, open **Settings → Applications → AWS Amplify** and grant access to the repository, then refresh the Amplify page.

**Build is not triggered after `git push`**
Confirm the branch you pushed is the one connected in Amplify (`main`).

## 8. From source code to a live website

1. You write Dart files in `lib/`. Flutter widgets describe the UI.
2. `git push` sends the code to GitHub.
3. Amplify detects the push on `main` and starts a build in a temporary Linux container.
4. `amplify.yml` installs Flutter and downloads dependencies (`flutter pub get`).
5. `flutter analyze` checks the code for mistakes.
6. `flutter build web --release` compiles the Dart code to JavaScript and copies `index.html`, icons and the Flutter engine files into `build/web/`.
7. Amplify uploads the contents of `build/web/` to its hosting service (served through a CDN over HTTPS).
8. Visitors open the Amplify URL and their browser runs the compiled app.
Every later `git push` repeats the same steps automatically.
