---
name: feature-lifecycle
description: Orchestrate end-to-end software feature work with optional Jira Cloud, GitLab, and a repository checkout. Use for feature clarification, the four-gate Software Factory workflow, faster vibe-coding delivery, focused branch or commit tasks, tests, optional Jira Stories, GitLab merge requests, or repository setup through .feature-workflow.yaml. Guide the user through one main workflow without requiring named subskills, always respect relevant AGENTS.md files, and support delivery-only tasks without forcing full feature planning.
---

# Feature Lifecycle

Guide software work from an idea to a Jira Story, implementation, tests, English Git commits, and a GitLab merge request. Operate as one orchestrator with three internal modes; never require the user to invoke internal modules by name or in sequence.

## Non-negotiable behavior

- For every new feature or delivery task, present and confirm exactly one mode before taking mutating action:
  1. **Software Factory** — four approval gates, vertical slices, complete delivery.
  2. **Vibe Coding** — compact planning, one approval, complete delivery.
  3. **Delivery only** — only the requested Jira, branch, test, commit, push, or merge-request steps.
- If the user already named a mode, ask for a one-line confirmation instead of silently assuming it.
- If the user has not named a mode, recommend one after a short initial clarification, state the concrete reasons in one or two sentences, and let the user choose or override the recommendation. Recommend Vibe Coding for clearly bounded, low-risk changes; recommend Software Factory for cross-cutting changes, material uncertainty, migrations, external contracts, or disputed behavior. Never select a mode automatically.
- For an explicit configuration-only request, run the repository bootstrap directly; do not force a feature mode.
- Jira is optional. When `jira.enabled` is `false`, skip Jira setup questions, capability discovery, Story drafting and creation, Jira transitions, Jira checklist updates, and Jira/GitLab linking. Continue the Git, test, commit, and GitLab workflow without an issue key.
- When resuming an existing local workflow, read its status and continue from the first incomplete step instead of asking for a new mode.
- Read every relevant `AGENTS.md` before planning or changing files. Nested `AGENTS.md` files apply to their subtrees.
- Use the user's conversational language for questions and summaries. Jira title, summary, description, acceptance criteria, and Definition of Done are German. Branch names, commit messages, GitLab merge-request titles, and GitLab merge-request descriptions are English unless a repository rule explicitly requires otherwise.
- Do not write implementation code before the required planning approval for the selected mode.
- Do not create Jira issues, branches, commits, pushes, or merge requests until the applicable approval and capability checks have passed. When Jira is disabled, no Jira capability check or issue creation is applicable.
- Never force-push, hard-reset, discard changes, auto-stash, weaken tests, delete branches, expose secrets, or write directly to a protected/default branch without explicit authorization.
- Never create a commit automatically. Before every implementation commit, show the actual Git diff and relevant test evidence, then wait for the user's explicit review approval.
- At an approval boundary, present the concrete evidence in the response: affected files, concise change summary, complete available diff, and focused test command/result. Do not merely state that this evidence would be shown later.
- For a Story quality gate, show the complete German draft itself before asking for approval: outcome-oriented title, summary, context, scope, observable acceptance criteria, and tailored Definition of Done. Listing the required fields without their draft content is insufficient.
- Before pushing an implementation branch or creating its merge request, show the complete branch diff, final test evidence, Definition-of-Done status, and planned merge-request content. Wait for the user's explicit delivery approval before either external action.
- Base commit messages on the actual diff, never only on a pre-implementation plan.
- Keep feature-planning files local and prevent them from entering commits.

## Start or resume

1. Identify the repository, current branch, working-tree state, available local execution tools, and connected Jira/GitLab capabilities.
2. Find and read relevant repository instructions, including `AGENTS.md`, `CONTRIBUTING.md`, merge-request templates, CI configuration, and documented build/test commands.
3. At the repository root, read `.feature-workflow.yaml` and optional `.feature-workflow.local.yaml` when present.
4. Look for a matching `docs/plans/<feature-slug>/00-status.md`.
   - If found, follow [recovery-and-resume.md](references/recovery-and-resume.md).
   - If more than one plan could match, ask the user to select one.
5. For a new task, recommend and then confirm the mode before mutation.
6. If the shared config is missing, invalid, or uses an unsupported schema, follow [repository-bootstrap.md](references/repository-bootstrap.md) before continuing. Allow session-only values so a small delivery task is not blocked by repository setup.

## Instruction and configuration precedence

Apply these sources in order while preserving higher-level safety and tool constraints:

1. The user's explicit instruction for the current task.
2. Relevant `AGENTS.md` and other mandatory repository policies.
3. `.feature-workflow.local.yaml`.
4. `.feature-workflow.yaml`.
5. Reliably observed repository and GitLab conventions.
6. Defaults in this skill.

If the current request conflicts with `AGENTS.md` or a mandatory repository policy, stop and surface the conflict instead of choosing silently.

## Capability preflight

Before a mutating phase, verify the exact capabilities it needs:

- Jira write access for Story creation or updates, when `jira.enabled` is `true`.
- Jira Story field metadata and workflow transitions when `jira.enabled` is `true` and the project has no recorded capability mapping, so acceptance criteria, Definition of Done, sprint assignment, and configured statuses are not assumed.
- GitLab write access for remote branches, pushes, or merge requests.
- A local repository checkout and command execution for checkout, builds, tests, and local commits.
- Permission to modify the current branch or create a new one.

A connected GitLab app does not prove that a local checkout exists. Never claim that a branch is checked out or tests passed unless those actions were actually performed. If a required capability is missing, explain the blocked step and ask for one safe alternative, such as using a remote branch, creating a draft merge request with unverified tests, or continuing after a local checkout becomes available.

## Route to the selected mode

### Software Factory

Read [software-factory.md](references/software-factory.md). Run Product, Architecture, Program Design, and Vertical Slices in order. After Program Design approval, create the Jira Story when Jira is enabled and prepare the branch. Do not implement until the slice plan is approved.

### Vibe Coding

Read [vibe-coding.md](references/vibe-coding.md). Create a compact plan, obtain one approval, then create the Jira Story when Jira is enabled and prepare the branch, implement, test, commit, and create the merge request. Escalate to Software Factory if the scope or uncertainty grows materially.

### Delivery only

Read [delivery-only.md](references/delivery-only.md). Perform only the subset requested by the user. Do not introduce Product, Architecture, or Program Design gates.

## Shared delivery modules

- For Jira resolution, drafting, duplicate checks, creation, and updates, read [jira-story.md](references/jira-story.md) only when `jira.enabled` is `true`.
- For base-branch discovery, safe branch creation, tests, commits, pushes, and GitLab merge requests, read [gitlab-delivery.md](references/gitlab-delivery.md).
- For config fields and allowed values, read [config-schema.md](references/config-schema.md) and use [config-template.yaml](references/config-template.yaml).
- Before using or writing config, apply [config-validation.md](references/config-validation.md).

## Runtime independence

Run the core workflow without requiring Python, Node.js, Bash, PowerShell, `jq`, `yq`, or any other optional runtime or package. Create and validate the YAML through the documented template and checklist.

Repository-provided tooling may be used only when its runtime is already available, its use is documented or clearly appropriate, and a safe manual fallback exists. Never install a runtime or package without explicit approval, and never block the workflow solely because an optional validator is unavailable.

## Skill maintenance

When changing this skill's workflow or configuration behavior, validate every affected case in [behavior scenarios](evals/behavior-scenarios.md). Treat a scenario as failed when the workflow performs an external action before its required approval or claims an unavailable Jira capability.

## Interaction style

- At the first use of this skill in a repository, briefly tell inexperienced users that `.feature-workflow.yaml` contains team-wide defaults and `.feature-workflow.local.yaml` is an optional, local-only override for personal settings. Do not overwhelm them with every field unless they ask.
- When a user asks how this skill works, how to configure it, whether a local YAML file exists, or which YAML values are allowed, read `README.md` and explain the relevant part in the user's language and level of experience.
- Ask only for values that cannot be derived safely from repository, Jira, GitLab, or current conversation context.
- Group unresolved setup questions into small batches.
- At each approval boundary, summarize the important decisions and the local document path instead of pasting every document in full.
- During implementation, report concrete evidence early: changed areas, failing or passing tests, commit hashes, Jira key, branch, and merge-request link.
- In isolated evaluations, use the supplied mock connector for read-only Jira or GitLab lookups when it is available. Treat the mock result as observed evidence and record the lookup and its result. Never turn a mock lookup into a real external action; real writes remain capability- and approval-gated.
- If the isolated fixture supplies a local mock-connector command, invoke that command directly instead of routing the lookup to a real external connector.
- For mock-only evaluations, simulated writes such as sprint assignment may be performed through the supplied mock command and must be recorded as simulated; they must never be sent to the real service.
- Preserve enough state in local plan files that a fresh session can continue without relying on chat history.
