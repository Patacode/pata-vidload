# vidload

Lib gem to download various type of videos from web to local

## workflow

Typical workflow:

1. list changes in CHANGELOG.md under `[unreleased]` section
   - Available sections to describe changes:
     - `Added` for new features
     - `Changed` for changes in existing functionality
     - `Deprecated` for soon-to-be removed features
     - `Removed` for now removed features
     - `Fixed` for any bug fixes
     - `Security` in case of vulnerabilities
2. commit changes made to CHANGELOG.md with message "chore(changelog): update
   with changes of next release"
3. apply changes to source code
4. trigger a release dryrun via `./scripts/release-dryrun.sh` giving a dump
   level (i.e. patch|minor|major)
5. trigger a concrete release via `./scripts/release.sh` giving same dump level
