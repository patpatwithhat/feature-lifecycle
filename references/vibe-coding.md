# Vibe Coding Mode

Use this mode for a faster end-to-end feature flow with one compact planning approval. “Vibe” means less ceremony, not blind implementation.

## Entry

1. Complete the shared repository, config, instruction, and capability preflight.
2. Derive a feature slug and create `docs/plans/<feature-slug>/00-status.md`.
3. Ensure local plans are excluded from commits.
4. Read enough existing code to avoid inventing patterns.

## Compact clarification and plan

Ask only essential questions about desired behavior, scope, edge cases, and success. Then write `01-vibe-plan.md`:

```markdown
# Vibe Plan: <feature name>

## Goal and user value
<desired outcome>

## Scope
<included behavior>

## Non-goals
<explicit exclusions>

## Existing code fit
<affected components and patterns found in the repository>

## Implementation outline
<small ordered steps>

## Risks and open assumptions
<items that could change the plan>

## Test plan
<tests and observable checks>

## Jira Story draft
<German title, summary, description, acceptance criteria, Definition of Done>

## Delivery preview
<base branch, proposed branch pattern, commit grouping, final checks>
```

Present the important decisions and path, and explain that approval authorizes Jira creation, branch preparation, and implementation. When Jira is disabled, explain that the Jira step is skipped. Ask:

**“Vibe-Plan freigeben oder was soll geändert werden?”**

Do not implement before clear approval.

## Delivery

After approval:

1. When Jira is enabled, create the Jira Story using [jira-story.md](jira-story.md). Otherwise skip Jira.
2. Create and check out the feature branch using [gitlab-delivery.md](gitlab-delivery.md), omitting the issue key when Jira is disabled.
3. Implement in small logical increments while following every relevant `AGENTS.md`.
4. Run focused tests as soon as behavior becomes testable; do not wait until the end for all feedback.
5. Keep `00-status.md` current with decisions, tests, and commits.
6. For each logical increment, show the affected files, concise change summary, complete Git diff, and focused test evidence. Wait for explicit review approval before generating an English commit message from that actual diff and committing. Use config strategy; default to logical commits rather than one giant commit.
7. Run final tests and inspect the complete branch diff.
8. Show the complete branch diff, final test evidence, Definition-of-Done status, and planned merge-request content. Ask for explicit delivery approval.
9. Only after delivery approval, push and create the merge request.
10. When Jira is enabled, verify acceptance criteria and Definition of Done with evidence, mark only proven Jira checklist items complete, and transition the Story to the configured ready-for-testing status.
11. When Jira is enabled, link Jira and GitLab when supported.

## Escalation rule

Pause and propose switching to Software Factory when any of these appears:

- The change expands across several architectural boundaries.
- A database/schema migration or external contract carries material risk.
- Product behavior remains disputed after implementation starts.
- The diff becomes difficult to review as a coherent unit.
- A discovered decision invalidates the compact plan.

Do not switch modes silently. Preserve current state and ask for confirmation.
