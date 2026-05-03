# Global Codex Instructions

## Git Defaults

- Default to working directly on `main`.
- Do not create branches, create worktrees, switch branches, or use feature branches unless the user explicitly asks.
- When the user explicitly asks to create a worktree, prefer creating it under the repository's `./.worktrees/...` directory.
- Before committing or pushing, verify the current branch with `git branch --show-current`.
- If the current branch is not `main` and the user did not explicitly ask to work on that branch, stop and ask before committing, merging, or pushing.
- When writing code, leave changes as raw unstaged diffs by default.
- Do not stage files, commit, or push unless the user explicitly asks.
- If the user asks to stage or commit, stage only the files relevant to the requested work and leave unrelated local changes untouched.
