# Repository Bootstrap

Use this flow when `.feature-workflow.yaml` is missing, invalid, outdated, or the user explicitly asks to configure the repository workflow.

## Goal

Produce an approved, runtime-independent repository configuration while asking only for information that cannot be inferred safely. Never place credentials or tokens in the config.

## 1. Inspect before asking

Locate the repository root and inspect, when available:

- Relevant `AGENTS.md` files.
- GitLab project metadata and default branch.
- Existing local and remote branch names.
- Recent commit messages.
- `CONTRIBUTING.md`, `README` files, merge-request templates, and release guidance.
- `.gitlab-ci.yml` and repository build/test scripts.
- Project manifests and solution/workspace files.
- Current ChatGPT project context and Jira issue keys associated with the repository.

Infer conventions only from repeated, unambiguous evidence. Do not select a Jira project from one incidental issue key or a branch pattern from one outlier branch.

## 2. Report detected and unresolved values

Present a compact result such as:

```text
Keine .feature-workflow.yaml gefunden.

Sicher erkannt:
- GitLab-Projekt: group/application
- Default-Branch: develop
- Branch-Muster: feature/{issue_key}-{slug}
- Commit-Stil: Conventional Commits
- Testeinstieg: dotnet test

Noch zu klären:
- Standardstrategie für das Jira-Projekt
- Jira-Standardwerte für Bearbeiter, Sprint und Statusübergänge
- Commit-Aufteilung
- Verhalten des Source Branch nach Merge
```

Mark each proposed value as one of:

- **Detected** — supported by repository or connector evidence.
- **Fixed requirement** — mandated by this workflow, such as Jira issue type `Story`.
- **Default** — proposed by the skill because no convention exists.
- **Needs user input** — unsafe or impossible to infer.

## 3. Ask only unresolved questions

Ask in small groups, covering only what remains unresolved:

1. **Jira**
   - Soll Jira für diesen Workflow verwendet werden? Bei `nein` werden alle Jira-Fragen und Jira-Schritte übersprungen; es wird kein Ticket angelegt.
   - Die folgenden Jira-Fragen nur bei `ja` stellen:
   - Fixed project key, or `context_or_ask`?
   - If fixed, which project key?
   - Soll eine Story standardmäßig unzugewiesen bleiben oder ist ein Standardbearbeiter gewünscht? Suche bei einem Namen den Jira-Nutzer, zeige den eindeutigen Treffer zur Bestätigung und speichere erst danach dessen Account-ID lokal. Verlange nie, dass ein Nutzer seine Account-ID kennt.
   - Soll eine Story standardmäßig im Backlog bleiben oder dem aktiven Sprint zugeordnet werden?
   - Welche Status sollen nach dem Anlegen und nach erfolgreicher Abschlussprüfung gelten? Schlage `In Arbeit` und `Testen` vor, wenn keine Projektvorgabe erkennbar ist.
2. **Git**
   - GitLab default branch or a fixed base branch?
   - Confirm the detected feature-branch pattern.
   - Commit style and grouping strategy.
3. **Tests**
   - Use discovered commands, supply explicit commands, or keep discovery-only behavior?
4. **GitLab merge request**
   - Target branch strategy, squash preference, and source-branch removal preference.
5. **Local plans**
   - Explain that feature plans always remain local. Confirm `docs/plans` and local exclusion through Git's local exclude mechanism.

Do not ask about values already fixed by the user's requirements:

- Mode selection is always confirmed for a new task.
- Jira issue type is `Story`.
- Jira content is German.
- Ohne abweichende Teamvorgabe sind Jira-Defaults: unzugewiesen, Backlog, `In Arbeit` nach Erstellung und `Testen` nach erfolgreicher Abschlussprüfung.
- Branch names and commit messages are English.
- Base-branch updates use fast-forward only.
- Wenn Jira deaktiviert ist, entfallen alle Jira-spezifischen Setup-Werte.

## Jira capability discovery

Skip this section entirely when `jira.enabled` is `false`.

Before the first Story is drafted for a project, inspect the Story field metadata and available workflow transitions. Establish and report:

- whether acceptance criteria and Definition of Done have dedicated, editable Jira fields;
- whether they must instead be maintained as checklists in the description;
- whether the Sprint field is editable and the active sprint can be resolved;
- whether the configured `on_create` and `on_ready_for_testing` status transitions are available.

Record the effective field mapping and any limitation in the local plan status. Do not promise Jira checklist updates that the project cannot support.

## 4. Offer persistence choices

Before writing anything, ask where the approved values should live:

1. **Shared repository config** — create `.feature-workflow.yaml`; recommended for stable team conventions.
2. **Local override** — create or update `.feature-workflow.local.yaml`; never commit it.
3. **Session only** — use the values for the current workflow without writing a config file.

When the shared config is missing during an active feature workflow, offer these safe paths:

- Create a dedicated configuration branch and merge request first; recommended.
- Include the config in the eventual feature branch; only after explicit selection.
- Continue session-only and configure the repository later.

For a configuration-only request, use a dedicated branch by default:

```text
Branch: chore/configure-feature-workflow
Commit: chore(workflow): add feature workflow configuration
```

Do not create a Jira Story for a configuration-only change unless the user asks for one or repository policy requires it.

## 5. Draft, approve, write, and re-read

1. Build the full config from [config-template.yaml](config-template.yaml).
2. Show the full draft and a short explanation of inferred versus user-selected values.
3. Obtain explicit approval before writing.
4. Apply [config-validation.md](config-validation.md).
5. Write the file using plain text; do not require a YAML library or external runtime.
6. Re-read the written file and compare all intended values.
7. If writing local-only files, add these entries to the repository's local Git exclude mechanism when possible:

```text
.feature-workflow.local.yaml
docs/plans/
```

Do not add local planning paths to the shared `.gitignore` unless the user explicitly chooses that team-wide behavior.

## 6. Handle existing or outdated config

- For invalid YAML or unsupported values, report each issue with its path and expected form.
- Offer repair or session-only operation; do not silently rewrite.
- For an unsupported `schema_version`, stop normal use and propose a migration.
- Show a focused diff before migration.
- Preserve unknown fields unless they are unsafe or incompatible.
- If config conflicts with `AGENTS.md`, surface the conflict and ask which source should be corrected. Do not proceed on an assumed winner.

## Security

Reject and remove proposed keys or values that contain credentials, tokens, passwords, private keys, cookies, or connection strings with secrets. Authentication belongs to connected apps, environment configuration, or approved secret stores, never `.feature-workflow.yaml`.
