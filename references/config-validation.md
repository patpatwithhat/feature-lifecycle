# Configuration Validation

Apply every check before using or writing `.feature-workflow.yaml` or `.feature-workflow.local.yaml`. Do not require an external parser or runtime.

For a partial local override, validate only supplied fields first, then validate the fully merged configuration against all required-field rules.

## Syntax subset

- Exactly one YAML document.
- Spaces only; no tab indentation.
- Mappings, lists, strings, booleans, integers, and `null` only.
- No anchors (`&`), aliases (`*`), merge keys (`<<`), custom tags (`!`), executable expressions, or environment-variable substitution.
- Quote strings that contain braces, colons, leading special characters, or values that YAML could coerce unexpectedly.

## Required shared-config fields

Verify:

- `schema_version` exists and equals `1`.
- `workflow.mode_selection` equals `always_ask`.
- At least one workflow mode is enabled.
- Every configured approval is `required` or `optional`.
- `plans.directory` is repository-relative and contains no `..`.
- `plans.storage` equals `local`.
- `jira.enabled`, when supplied, is a boolean.
- When `jira.enabled` is `true` (or omitted), `jira.issue_type` equals `Story`, `jira.content_language` equals `de`, and a fixed Jira project has a non-empty project key.
- When `jira.enabled` is `false`, do not require Jira project, field, assignee, sprint, or status values; preserve them if present and ignore them at runtime.
- `jira.assignee.account_id`, when supplied and non-null, is a non-empty string.
- `jira.sprint.placement`, when supplied, is `backlog` or `active_sprint`.
- `jira.status.on_create` and `jira.status.on_ready_for_testing`, when supplied, are non-empty strings.
- `git.provider`, when supplied, is `auto`, `github`, or `gitlab`.
- `git.base_branch.strategy` is `provider_default`, legacy `gitlab_default`, `fixed`, or `repository_detected`.
- `gitlab.target_branch.strategy`, when supplied, is `base_branch`, `gitlab_default`, or `fixed`.
- `github.target_branch.strategy`, when supplied, is `base_branch`, `github_default`, or `fixed`.
- `git.update_strategy` equals `ff_only`.
- `git.branch.language` and `git.commit.language` equal `en`.
- A fixed base or target branch has a non-empty name.
- Test command values are lists of strings.

## Branch pattern

- Only use documented placeholders.
- Prefer both `{issue_key}` and `{slug}` for feature branches.
- Reject whitespace, backslashes, control characters, `..`, `@{`, a trailing dot, repeated slashes, or a leading/trailing slash.
- Compare the pattern with mandatory repository rules and repeated existing branch conventions.

## Repository checks

When a local repository or hosting-provider metadata is available:

- Confirm a fixed base branch exists.
- Confirm the target branch is valid.
- Check for conflicts with relevant `AGENTS.md`, `CONTRIBUTING.md`, and protected-branch policies.
- Verify that local planning storage is excluded from commits.
- Do not execute configured commands merely to validate their syntax. Show unfamiliar commands before first execution.

## Secret scan

Reject values or keys that appear to contain:

- Tokens, passwords, API keys, private keys, session cookies, or secret-bearing connection strings.
- Jira, GitHub, or GitLab credentials.
- Personal access tokens.

Names of environment variables are allowed; secret values are not.

## Unknown or newer fields

- Preserve unknown fields and warn about them.
- Do not claim they are supported.
- Stop on unsupported `schema_version` and offer a migration.
- Never silently delete unknown fields during repair.

## Conflict handling

If configuration conflicts with a current explicit instruction or mandatory repository policy, identify both values and stop for resolution. Do not silently choose a winner.

## Write verification

After writing:

1. Re-read the complete file.
2. Compare every intended scalar and list value.
3. Confirm no secrets were added.
4. Confirm local-only paths remain excluded.
5. Show the final path and a focused diff when modifying an existing file.
