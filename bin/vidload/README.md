# vidload

Lib gem to download various type of videos from web to local

## workflow

Typical workflow:

1. Look at tasks in TODO.md
2. Add any new desired tasks
3. Pick tasks to achieve in next release
4. list changes in CHANGELOG.md under `[unreleased]` section
   - Available sections to describe changes:
     - `Added` for new features
     - `Changed` for changes in existing functionality
     - `Deprecated` for soon-to-be removed features
     - `Removed` for now removed features
     - `Fixed` for any bug fixes
     - `Security` in case of vulnerabilities
5. commit changes made to CHANGELOG.md with message "chore(changelog): update
   with changes of next release"
6. apply changes to source code
7. format code using rubocop
8. checkmark related tasks in TODO.md
9. commit changes made to TODO.md with message "chore(todo): checkmark achieved
   tasks"
10. trigger a release dryrun via `./scripts/release-dryrun.sh` giving a dump
    level (i.e. patch|minor|major)
11. trigger a concrete release via `./scripts/release.sh` giving same dump level

```bash
rake todo_task # optional
rake changelog
rake format
rake todo
rake gem_release_dryrun # optional bump_level, from $BUMP_LEVEL or task arg, default to patch
rake gem_release # same as dryrun
```
