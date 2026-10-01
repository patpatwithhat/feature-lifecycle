# Recovery and Resume

Preserve local workflow state so a fresh session can continue without relying on chat history.

## Plan location

Use:

```text
docs/plans/<feature-slug>/
```

Software Factory:

```text
00-status.md
01-product.md
02-architecture.md
03-program-design.md
04-slices.md
mockups/
```

Vibe Coding:

```text
00-status.md
01-vibe-plan.md
```

Plans are always local. Exclude `docs/plans/` through the repository's local Git exclude mechanism and verify before every commit that plan files are absent from the diff.

## Status template

Create `00-status.md` first:

```markdown
# Status: <feature name>

- Mode: software_factory | vibe_coding
- State: planning | delivery_setup | implementing | verifying | merge_request | completed | blocked
- Repository: <group/project>
- Feature slug: <slug>
- Jira: not_applicable | not_created | <KEY and URL>
- Base branch: <name or unknown>
- Feature branch: not_created | <name>
- Merge request: not_created | <URL>

## Approvals
- Product: pending | in_progress | APPROVED <date> | not_applicable
- Architecture: pending | in_progress | APPROVED <date> | not_applicable
- Program Design: pending | in_progress | APPROVED <date> | not_applicable
- Slice plan: pending | in_progress | APPROVED <date> | not_applicable
- Vibe plan: pending | in_progress | APPROVED <date> | not_applicable

## Slices or implementation steps
- [ ] <step and expected proof>

## Test evidence
- <date> — `<command>` — <result>

## Commits
- <hash> — <message> — <scope>

## Blockers and recovery point
<last successful action, failed action, exact safe next step>

## Notes for a fresh session
<all decisions that exist only in the current context unless copied here>
```

Never put credentials, tokens, secret values, or sensitive customer data into status files.

## Resume procedure

1. Identify the matching plan directory by slug, Jira key, branch, or explicit user selection.
2. Read `00-status.md` and every existing document in that directory.
3. Read current repository status, branch, recent commits, and configured base branch.
4. Read the current Jira Story only when Jira is enabled and a link exists; read the GitLab merge request when a link exists and the connector is available.
5. Reconcile recorded state with actual state. Actual repository and connector state wins over stale status, but record the discrepancy.
6. Summarize:
   - Last approved boundary.
   - Completed code and commits.
   - Test evidence.
   - Current blocker or next step.
7. Continue from the first unapproved gate, incomplete slice, failed verification, or missing delivery action.

Do not redo an approved gate unless the user asks or a later discovery invalidates it.

## Boundary compaction

At every gate approval, slice completion, material commit, and delivery action:

- Update all affected plan documents.
- Record the exact next step.
- Capture decisions that would otherwise live only in chat.
- Keep summaries concise but sufficient for another session.
- Tell the user when the boundary is a safe fresh-session resume point.
- If context is becoming constrained before a boundary, update status and plans immediately before continuing.

## Backtracking

When later work invalidates an earlier decision:

1. Stop implementation.
2. Mark affected gate or plan `in_progress` again.
3. Explain the contradiction.
4. Update the earlier document and dependent documents.
5. Obtain the required approval again.
6. Reconcile Jira scope, branch plan, implemented code, and tests before continuing.

## Failure recovery

For a failed Jira, Git, test, commit, push, or MR action:

- Record the exact action and error.
- Record whether any partial mutation occurred.
- Inspect actual state before retrying.
- Do not repeat a mutating action blindly.
- Offer one safe recovery path and ask when user choice is required.

Examples:

- Jira creation timed out: search for a duplicate before retrying.
- Branch creation reported failure: verify local and remote branch existence.
- Commit failed: inspect index and hooks before retrying.
- Push failed: fetch and inspect divergence; never force by default.
- MR creation failed: search for an existing MR from the same source branch before retrying.

## Completion

Mark `completed` only when the requested lifecycle is actually complete and all unverified checks are explicitly accepted or resolved. Keep the local plans available for later review unless the user asks to remove them.
