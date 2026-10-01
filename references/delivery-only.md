# Delivery Only Mode

Perform only the Jira, branch, test, commit, push, or GitLab merge-request work the user requests. Do not introduce Product, Architecture, Program Design, or Vertical Slice gates.

## Scope discipline

- Confirm the requested subset in one sentence when needed.
- Do not create a Jira Story unless requested or required to produce the requested branch. If `jira.enabled` is `false`, never create or update a Jira issue and omit the issue key from branch and merge-request content.
- Do not implement unrelated feature code.
- Do not create local plan documents for a one-step task. For a multi-step delivery operation that may span sessions, a minimal `00-status.md` is allowed with user approval.
- If `.feature-workflow.yaml` is missing, offer guided setup or session-only conventions; do not force a full repository configuration for a small task.

## Common operations

### Prepare a branch

1. When Jira is enabled, resolve an existing Jira key, or create a Story only if requested. When Jira is disabled, skip this step.
2. Read repository instructions and config.
3. Verify a clean worktree; never auto-stash or discard.
4. Discover the base branch and update it fast-forward only.
5. Create or check out the English feature branch according to repository convention.
6. Report the actual checked-out branch. If no local checkout exists, distinguish a remote branch from a checked-out branch.

### Create a commit message only

1. Inspect the relevant staged diff, or the user-specified changes.
2. Follow repository style, falling back to Conventional Commits when configured.
3. Produce an English message describing the actual change.
4. Do not stage or commit.

### Commit changes

1. Inspect status, staged diff, unstaged diff, and untracked files.
2. Exclude unrelated changes and local plan/config override files.
3. If staging is needed, state the intended file grouping before staging.
4. Run required focused checks when feasible.
5. Show the affected files, final staged diff, and available test evidence. Ask for explicit commit approval.
6. Only after explicit approval, generate the English message from the final staged diff.
7. Commit and report the hash and included files.

### Test changes

1. Discover commands in the configured order.
2. Run only commands appropriate to the requested scope, plus mandatory repository checks.
3. Report exact commands and outcomes.
4. Do not claim success for commands that could not run.

### Create a merge request

1. Verify branch, commits, worktree, tests, target branch, and push state.
2. Push without force.
3. Create the GitLab merge request using repository template and [gitlab-delivery.md](gitlab-delivery.md).
4. Link the Jira Story when Jira is enabled and a Story exists.
5. Report the URL and any unverified checks.

## Safety stops

Stop and ask before proceeding when:

- The worktree contains unrelated or ambiguous changes.
- The requested branch already exists with unexpected commits.
- Fast-forward update is impossible.
- A protected/default branch would be changed directly.
- Tests fail or cannot run and the next step would publish or merge work.
- Connector or local capabilities are insufficient for the claimed action.
