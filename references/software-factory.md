# Software Factory Mode

This mode adapts the four-gate workflow described in the user-provided Software Factory Playbook: Product, Architecture, Program Design, and Vertical Slices. Make hard decisions before implementation, preserve state locally, and keep every code increment reviewable.

Source inspiration: https://gist.github.com/Maciejdziuba/88890d7e0eeefa5a8738bbe9fd5e20b8

## Entry conditions

Before Gate 1:

1. Complete the shared start, config, repository-instruction, and capability preflight from `SKILL.md`.
2. Derive a stable English kebab-case feature slug.
3. Create the local plan directory and `00-status.md` using [recovery-and-resume.md](recovery-and-resume.md).
4. Ensure the plan directory is locally excluded from Git when `plans.storage` is `local`.
5. Record the selected mode, repository, base branch, and unresolved connector limitations.

Do not create Jira, create a branch, or write implementation code yet. If Jira is disabled, do not draft or create a Jira Story; the Jira part is skipped.

## Approval protocol

Run this protocol at every gate:

1. Write or update the gate document on disk.
2. Ensure all important chat decisions are represented in the document.
3. Present no more than 5–10 key decisions, open questions, and the local document path.
4. Ask in the user's language: **“Gate N freigeben oder was soll geändert werden?”**
5. Treat only a clear approval as approval. Revise and ask again for any other response.
6. On approval, update `00-status.md` with the date and proceed.
7. If a later gate invalidates an earlier decision, stop, reopen the earlier gate, revise its document, and obtain approval again.

## Gate 1 — Product

Write `01-product.md`. Keep this gate user- and outcome-focused; park technical implementation details for Gate 2.

Use this structure:

```markdown
# Product: <feature name>

## Problem
<problem in the end user's words>

## Users and context
<who experiences it and when>

## Desired outcome
<observable user or business result>

## Success metric
<one measurable signal and how it is measured>

## Announcement
<3–6 sentences announcing the feature to users>

## Scope
<included behavior>

## Non-goals
<explicit exclusions>

## User flow
<main path and important alternatives>

## Screens
<one line per mockup, or "No UI">

## Open product questions
<remaining decisions>
```

Rules:

- Do not discuss databases, files, classes, endpoints, or implementation architecture in this gate.
- For a user interface, create one plain HTML mockup per relevant screen under `mockups/`. Use no framework or build step. Treat mockups as disposable planning artifacts.
- Iterate until the user confirms the behavior and flow, then run the approval protocol.

## Gate 2 — Architecture

Read the relevant existing code and repository instructions before designing. Never design against an imagined codebase.

Write `02-architecture.md`:

```markdown
# Architecture: <feature name>

## Existing fit
<services, modules, layers, and established patterns affected>

## Components and responsibilities
<what changes where and why>

## Interfaces and endpoints
<route, verb, contract, or "None">

## Data
<entities, storage changes, migrations, and query outlines>

## End-to-end flow
<ordered call/data flow for each main path>

## External dependencies
<APIs, webhooks, environment-variable names, or "None">

## Security, privacy, and permissions
<relevant controls or "No material change">

## Compatibility and rollout
<migration, feature flag, backward compatibility, rollback>

## Risks and trade-offs
<key risks and chosen trade-offs>

## Open architecture questions
<remaining decisions>
```

Cite concrete repository paths in the document. Run the approval protocol.

## Gate 3 — Program Design

Translate the approved architecture into decisions that would otherwise be made silently during implementation.

Write `03-program-design.md`:

```markdown
# Program Design: <feature name>

## Files
<every file to create or change, with its responsibility>

## Types and signatures
<types, interfaces, method/function signatures, and data shapes; no implementation bodies>

## Call stacks
<top-to-bottom call order for each main flow>

## Error handling and observability
<errors, logging, metrics, tracing, and user feedback>

## Test plan
<test names/scenarios and exactly what each proves>

## Migration and rollout steps
<ordered steps or "None">

## Least-confident decisions
<numbered decisions most worth challenging before code exists>

## Jira Story draft
<German title, summary, description, acceptance criteria, Definition of Done>

## Delivery preview
<base branch, proposed branch pattern, likely commit grouping, final test scope>
```

Rules:

- Do not include implementation bodies.
- Use actual repository paths and existing type names where possible.
- Test cases must be capable of failing against pre-change behavior.
- When Jira is enabled, the Jira draft must follow [jira-story.md](jira-story.md), and tell the user that approving Gate 3 authorizes creation of the Jira Story and branch preparation using the shown draft and delivery preview.
- When Jira is disabled, omit the Jira draft and tell the user that Gate 3 approval authorizes branch preparation without creating a Jira issue.

Run the approval protocol.

## Delivery setup after Gate 3 approval

After Gate 3 is approved:

1. When Jira is enabled, create the Jira Story according to [jira-story.md](jira-story.md) and record its key and link in `00-status.md`. When Jira is disabled, record Jira as not applicable.
2. Build the final English branch name using the actual issue key when available; otherwise omit the issue-key placeholder.
3. Prepare and check out the branch according to [gitlab-delivery.md](gitlab-delivery.md).
5. Record the branch and base branch in `00-status.md`.
6. Stop on any capability, permission, dirty-worktree, branch, or connector failure. Record the failure and do not continue to implementation.

## Gate 4 — Vertical Slices

Write `04-slices.md` before implementation:

```markdown
# Vertical Slices: <feature name>

## Slice 1 — Tracer bullet
<smallest observable end-to-end path and proof>

## Slice 2 — Happy path
<replace the tracer's mocks/stubs with one real working path>

## Slice 3+
<one business rule, error path, edge case, integration, or polish item per slice>

## Final verification
<full relevant test suite, manual checks, acceptance criteria, and Definition of Done>
```

Slice rules:

- Slice 1 is the thinnest useful end-to-end path. It may be a stubbed UI plus mocked endpoint, a callable API response, a CLI path, or another observable tracer appropriate to the repository.
- Slice 2 delivers one real happy path.
- Later slices each add one coherent capability or risk reduction.
- Do not build horizontally across all persistence, all services, all API, and all UI before anything works.
- Each slice must end in a working, reviewable, testable state.

Run the approval protocol. Do not implement before Gate 4 approval.

## Implement each slice

For every approved slice:

1. Re-read relevant `AGENTS.md` and the approved design documents.
2. Implement only that slice.
3. Run the narrowest real tests that prove it, plus any required repository checks.
4. Show concrete evidence: command, result, observable behavior, and remaining limitations.
5. Never skip, comment out, or weaken a failing test to obtain green status.
6. Show the affected files, a concise change summary, the complete actual Git diff, and the test evidence for review. Ask for explicit approval to commit this slice.
7. Only after explicit approval, create an English commit following repository conventions. Default to one logical commit per slice.
8. Record test evidence and commit hash in `00-status.md` and check off the slice.
9. Ask: **“Mit dem nächsten Slice fortfahren oder neu ausrichten?”**
9. If redirected, update affected plans and approvals before continuing.

## Complete the lifecycle

After all slices:

1. Run configured final tests and all checks required by `AGENTS.md` or CI conventions.
2. Inspect the complete branch diff for unrelated changes, secrets, generated artifacts, and accidental local plan files.
3. Show the complete branch diff, final test evidence, Definition-of-Done status, and planned merge-request content. Ask for explicit delivery approval.
4. Only after delivery approval, push safely and create the GitLab merge request using [gitlab-delivery.md](gitlab-delivery.md).
5. When Jira is enabled, link Jira and GitLab in both directions when the connectors support it, then complete the final Jira verification and handoff described in [jira-story.md](jira-story.md). Otherwise skip the Jira handoff.
6. Record the merge-request URL and final status in `00-status.md`.
7. Report completed work, test evidence, commits, known limitations, and review focus.

## Durable decisions and external context

When an architecture decision will outlive the feature, offer to add a repository ADR under the repository's established ADR location, commonly `docs/adr/`, only after explicit approval. Never rewrite an accepted historical ADR; supersede it according to repository convention.

When future work depends on non-secret setup outside the repository, offer to document its existence under the repository's established external-context location, commonly `docs/external/`. Record environment-variable names, dashboard purpose, test-account purpose, or setup steps, but never secret values or credentials.

Local feature plans remain local. ADRs and external-context documents are separate repository changes and must follow repository conventions.
