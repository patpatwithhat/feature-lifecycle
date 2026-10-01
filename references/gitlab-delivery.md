# Git and GitLab Delivery

Use repository conventions first, then config, then safe defaults. Distinguish local Git operations from remote GitLab operations.

## Discover repository conventions

Inspect:

- Relevant `AGENTS.md` and contribution guidance.
- GitLab default and protected branches.
- Repeated existing branch names.
- Recent commit messages.
- Merge-request templates and CI requirements.
- Configured test commands and repository scripts.

Do not infer a convention from one outlier.

## Resolve the base branch

- `gitlab_default`: use the GitLab project's current default branch.
- `fixed`: use the configured branch after verifying it exists.
- `repository_detected`: use a clearly documented repository development branch.

If repository instructions and GitLab metadata disagree materially, stop and ask. Never guess between `main`, `develop`, and `development`.

## Build the branch name

1. Use the actual Jira issue key when the pattern contains `{issue_key}`. If Jira is disabled, remove `{issue_key}` and any adjacent separator before validating the branch name.
2. Produce `{slug}` as concise lowercase English kebab-case.
3. Remove accents and unsupported punctuation.
4. Follow repository length and prefix conventions.
5. Validate the result against Git ref restrictions.

Default example:

```text
feature/ABC-123-add-configurable-import
```

If the branch exists locally or remotely, inspect its relationship to the intended base and ask whether to reuse it; do not overwrite it.

## Prepare and check out a local branch

When a local repository is available:

1. Inspect `git status` and require a clean worktree when configured.
2. Do not stash, discard, or move user changes automatically.
3. Fetch remotes.
4. Check out the resolved base branch.
5. Update it using fast-forward only, equivalent to `git pull --ff-only`.
6. Create and check out the feature branch.
7. Verify and report the current branch and base commit.

When only a GitLab connector is available, a remote branch may be created if supported, but do not describe it as locally checked out. Local builds, tests, and commits remain unavailable unless another execution environment exists.

## Discover and run tests

Use the configured order:

1. `AGENTS.md`.
2. Repository documentation.
3. Repository scripts or task runners.
4. GitLab CI configuration.
5. Explicit config commands.
6. Ask when no safe command can be determined.

Run focused tests during implementation and configured final checks before publication. Record:

- Exact command.
- Exit result.
- Relevant pass/fail counts when available.
- Material warnings or skipped tests.

Never call unexecuted checks successful. Never disable or weaken a test merely to pass.

## Stage and commit

Before every commit:

1. Inspect status, staged diff, unstaged diff, and untracked files.
2. Exclude local planning files, local overrides, credentials, generated noise, and unrelated user changes.
3. Group files by one coherent purpose.
4. Run the checks appropriate to that purpose.
5. Generate the message from the actual staged diff.

Use repository style. With `repository_or_conventional`, use the established style when clear; otherwise use Conventional Commits.

Examples:

```text
feat(import): add initial end-to-end import flow
fix(import): reject unsupported coordinate systems
test(import): cover invalid source file handling
chore(workflow): add feature workflow configuration
```

Do not include a body unless it adds useful rationale. Report commit hash and included scope.

## Push safely

- Before pushing an implementation branch or creating its merge request, apply the central delivery-review rule in `SKILL.md`. Do not treat a prior commit or slice approval as delivery approval.
- Push the current feature branch and set upstream when needed.
- Never force-push unless the user explicitly requests it, understands the impact, and repository policy permits it.
- Do not push directly to the protected/default branch.
- Report the remote branch actually updated.

## Create the GitLab merge request

Confirm that the central delivery review approved the complete branch diff, final test evidence, Definition-of-Done status, and planned merge-request content.

Create only after configured final tests, unless the user explicitly accepts a draft MR with clearly marked unverified checks.

Resolve target branch from config and verify it exists. Use the repository template when present. Otherwise use:

```markdown
## Summary
<what changed and why>

## Jira
<issue key and link, or "Not applicable — Jira is disabled">

## Changes
- <coherent change>
- <coherent change>

## Test evidence
- `<command>` — <result>

## Acceptance criteria
- [x] <verified criterion>
- [ ] <unverified criterion with reason>

## Known limitations and review focus
<limitations, risk areas, migration notes, or "None">
```

Write the merge-request title and description in English unless a repository rule explicitly requires otherwise. The title follows repository convention. When no convention exists, prefer:

```text
ABC-123 Add configurable import workflow
```

Apply configured squash and source-branch settings. Capture and report MR URL, IID, title, source branch, target branch, draft state, and pipeline status when available.

## Completion guard

Before reporting completion, verify:

- The worktree and branch are in the expected state.
- All intended commits are pushed.
- No local planning artifacts were committed.
- Test claims match actual evidence.
- Jira and MR links are recorded when Jira is enabled; otherwise Jira is explicitly marked not applicable.
- Known failures or missing capabilities are explicit.
