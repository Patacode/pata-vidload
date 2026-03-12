# Changelogs

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]

### Added

- Gemfile to describe runtime and dev dependencies to be used along bundler

## [0.1.6] - 12/03/2026

### Fixed

- Closing quote (') in git commit command of `todo_task` rake task (causing
  Syntax error, now all is fine)

## [0.1.5] - 12/03/2026

### Added

- rake tasks to manage TODO.md

### Changed

- new pre-steps in typical workflow around todos

## [0.1.4] - 12/03/2026

### Added

- rake to manage project tasks
- some basic common rake tasks

### Changed

- new steps in typical workflow described in README.md around TODO.md

### Fixed

- exit status of release-dryrun.sh is now consistent (was always 1, now 0 in
  case of success and 0 otherwise)

## [0.1.3] - 12/03/2026

### Changed

- git push at the end of release.sh script

## [0.1.2] - 12/03/2026

### Changed

- add empty `[unreleased]` section when making new releases

## [0.1.1] - 12/03/2026

### Added

- todo file to list tasks to be done

## [0.1.0] - 12/03/2026

### Added

- display loading spinner during loading messages
- support download of mp2t videos
- init project
