# Global Codex Instructions

## Communication Defaults

- Default to shorter, simpler responses that are easy to skim.
- Start with the direct answer or result before adding context.
- Assume the user is a software engineer, but do not assume they know every tool, repo convention, or domain detail.
- Explain non-obvious terms, acronyms, and repo-specific concepts briefly the first time they matter.
- Keep plans compact: use a few clear steps, state the goal of each step, and avoid exhaustive implementation detail unless asked.
- For completed work, summarize what changed, how it was checked, and anything the user needs to decide next.
- Avoid long technical deep dives, broad background, and low-level mechanics unless the user asks for detail, a review, or debugging evidence.

## Skill Feedback

- When a skill request reveals avoidable inefficiency in that skill's instructions, workflow, scripts, state layout, or examples, finish the user's requested work and also call out the friction briefly.
- Phrase the improvement concretely, for example: `The skill would be more efficient if ...`.
- Ask whether the user wants the skill updated as a follow-up, and do not edit the skill unless the user explicitly agrees.

## Git Defaults

- Default to working directly on `main`.
- When the user asks for a code change in a repo, assume work should happen in a worktree under the repository's `./.worktrees/...` directory (unless the user says otherwise).
- Do not create branches, switch branches, or use feature branches unless the user explicitly asks.
- Before committing or pushing, verify the current branch with `git branch --show-current`.
- If the current branch is not `main` and the user did not explicitly ask to work on that branch, stop and ask before committing, merging, or pushing.
- When writing code, leave changes as raw unstaged diffs by default.
- Do not stage files, commit, or push unless the user explicitly asks.
- If the user asks to stage or commit, stage only the files relevant to the requested work and leave unrelated local changes untouched.

## Pull Requests

- When creating a PR with a multi-line description via `gh`, prefer `--body-file` with a temporary markdown file over inline `--body` text.
- Do not pass `\n` inside normal shell quotes for PR bodies; GitHub will receive literal backslash-n text instead of line breaks.
- After opening or editing a PR, verify the rendered body source with `gh pr view <number> --json body --jq .body` when formatting matters.
