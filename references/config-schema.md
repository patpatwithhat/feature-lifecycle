# Configuration Schema

Use this schema for `.feature-workflow.yaml` and optional `.feature-workflow.local.yaml`. Keep the YAML deliberately simple: mappings, lists, strings, booleans, integers, and `null` only.

## Root

### `schema_version`

Required integer. Supported value: `1`.

## `workflow`

- `mode_selection`: required; `always_ask`.
- `jira_creation_after`: required; `program_design` for Software Factory. Vibe Coding creates Jira after `vibe_plan` approval by workflow rule.
- `modes.software_factory`: boolean.
- `modes.vibe_coding`: boolean.
- `modes.delivery_only`: boolean.
- `approvals.product`: `required` or `optional`.
- `approvals.architecture`: `required` or `optional`.
- `approvals.program_design`: `required` or `optional`.
- `approvals.slice_plan`: `required` or `optional`.
- `approvals.vibe_plan`: `required` or `optional`.

At least one mode must be enabled. For this user's intended setup, keep all three enabled and all listed approvals `required`.

## `plans`

- `directory`: repository-relative path; default `docs/plans`.
- `storage`: `local` only. Feature-planning files never enter the repository.
- `exclude_method`: `git_info_exclude`, `gitignore`, or `none`. For local storage, prefer `git_info_exclude`.

A path must not be absolute and must not contain `..` traversal. Do not allow a local override to change `plans.storage`.

## `jira`

- `enabled`: boolean; default `true`. When `false`, Jira is not required for the workflow. Skip Jira setup questions, capability discovery, Story drafting and creation, Jira transitions, checklist updates, and Jira/GitLab linking.

When Jira is disabled, all other `jira` values are ignored and may remain at their template defaults. A branch pattern containing `{issue_key}` must omit that placeholder and any adjacent separator when building the branch name.

### `project`

- `strategy`: one of:
  - `fixed` — always use `key`.
  - `context_or_ask` — use clear ChatGPT/project/repository context; ask when ambiguous.
  - `always_ask` — ask for every new Story.
- `key`: Jira project key for `fixed`; otherwise may be `null`.

### Other Jira fields

- `issue_type`: required; `Story`.
- `content_language`: required; `de`.
- `fields.title`: boolean.
- `fields.summary`: boolean.
- `fields.description`: boolean.
- `fields.acceptance_criteria`: boolean.
- `fields.definition_of_done`: boolean.

When the Jira connector lacks dedicated fields, put enabled content sections into the Story description.

### Jira delivery defaults

All fields in this section are optional and have the defaults below. They may be overridden in `.feature-workflow.local.yaml`.

- `assignee.account_id`: Jira account ID string or `null`; default `null` (leave the Story unassigned).
- `sprint.placement`: `backlog` or `active_sprint`; default `backlog`.
- `status.on_create`: target Jira status after Story creation; default `In Arbeit`.
- `status.on_ready_for_testing`: target Jira status after successful final verification; default `Testen`.

For `active_sprint`, resolve the active sprint of the selected project. Proceed only when exactly one eligible sprint can be determined; otherwise ask the user. Resolve configured status names through the project's available Jira transitions; never assume a transition ID or silently accept a missing transition.

## `git`

### `base_branch`

- `strategy`: `gitlab_default`, `fixed`, or `repository_detected`.
- `name`: required for `fixed`; otherwise may be `null`.

### Update and cleanliness

- `update_strategy`: required; `ff_only`.
- `require_clean_worktree`: boolean; recommended `true`.

### `branch`

- `pattern`: branch template. Supported placeholders:
  - `{issue_key}` — Jira key, for example `ABC-123`.
  - `{slug}` — lowercase English kebab-case description.
- `language`: required; `en`.

Feature patterns should contain both `{issue_key}` and `{slug}` unless repository policy mandates another form.

### `commit`

- `language`: required; `en`.
- `style`: `repository`, `conventional`, or `repository_or_conventional`.
- `strategy`: `per_slice`, `logical`, or `single`.

`per_slice` is the Software Factory default. `logical` is the Vibe Coding default when repository config does not specify otherwise.

## `gitlab`

### `target_branch`

- `strategy`: `base_branch`, `gitlab_default`, or `fixed`.
- `name`: required for `fixed`; otherwise may be `null`.

### `merge_request`

- `create`: boolean.
- `create_after`: `final_tests` or `manual`.
- `title_language`: `repository`, `en`, or `de`.
- `remove_source_branch`: boolean or `repository_default`.
- `squash`: boolean or `repository_default`.

## `tests`

### `discovery_order`

List containing any of:

- `agents`
- `repository_documentation`
- `repository_scripts`
- `gitlab_ci`

### `commands`

- `build`: list of command strings.
- `test`: list of command strings.
- `final`: list of command strings.

Empty lists mean discover commands from the repository. Never invent a passing result when no command can be run.

## Local overrides

`.feature-workflow.local.yaml` may contain only the fields it overrides. Merge mappings recursively; replace lists as complete values. Local overrides must not override mandatory `AGENTS.md` rules or contain secrets.
