# Global Codex Instructions

## Communication Defaults

- Default to shorter, simpler responses that are easy to skim.
- Start with the direct answer or result before adding context.
- Assume the user is a software engineer, but do not assume they know every tool, repo convention, or domain detail.
- Explain non-obvious terms, acronyms, and repo-specific concepts briefly the first time they matter.
- Keep plans compact: use a few clear steps, state the goal of each step, and avoid exhaustive implementation detail unless asked.
- For completed work, summarize what changed, how it was checked, and anything the user needs to decide next.
- Avoid long technical deep dives, broad background, and low-level mechanics unless the user asks for detail, a review, or debugging evidence.

## Git Defaults

- Default to working directly on `main`.
- Do not create branches, create worktrees, switch branches, or use feature branches unless the user explicitly asks.
- When the user explicitly asks to create a worktree, prefer creating it under the repository's `./.worktrees/...` directory.
- Before committing or pushing, verify the current branch with `git branch --show-current`.
- If the current branch is not `main` and the user did not explicitly ask to work on that branch, stop and ask before committing, merging, or pushing.
- When writing code, leave changes as raw unstaged diffs by default.
- Do not stage files, commit, or push unless the user explicitly asks.
- If the user asks to stage or commit, stage only the files relevant to the requested work and leave unrelated local changes untouched.
