# Jira Story

Create Jira Cloud issues as Stories with German content. Use connected Jira tools when available; never invent a successful creation, issue key, or URL.

## Resolve the Jira project

Use this order:

1. `jira.project.key` when strategy is `fixed`.
2. A single, explicit project in the current ChatGPT project or conversation context.
3. A reliable repository-to-project mapping or repeated associated issue keys.
4. Ask the user when more than one project is plausible or no project is known.

Do not infer a project from a single incidental reference. Always create issue type `Story` unless the user explicitly changes the agreed workflow.

## Duplicate guard

Before creation, search the target project for a materially similar open Story when the connector supports search. Compare title, feature name, and core outcome. If a likely duplicate exists, show it and ask whether to use it or create a new Story.

## Story content

Use this structure. Keep acceptance criteria observable and testable.

```markdown
# Titel
<kurzer deutscher Ergebnistitel>

## Zusammenfassung
<2–4 Sätze zu Problem, Nutzerwert und gewünschtem Ergebnis>

## Beschreibung

### Kontext und Nutzen
<warum die Änderung benötigt wird>

### Umfang
<enthaltenes Verhalten>

### Nicht-Ziele
<bewusste Abgrenzung>

### Technische Hinweise
<nur relevante, freigegebene Hinweise; bei Bedarf "Keine">

## Akzeptanzkriterien
- [ ] <konkretes beobachtbares Ergebnis>
- [ ] <Fehler- oder Randfall>
- [ ] <Kompatibilitäts- oder Berechtigungsverhalten, falls relevant>

## Definition of Done
- [ ] Die freigegebenen Akzeptanzkriterien sind umgesetzt und nachgewiesen.
- [ ] Relevante automatisierte Tests wurden ergänzt und laufen erfolgreich.
- [ ] Vorgeschriebene Build-, Qualitäts- und CI-Prüfungen sind erfolgreich.
- [ ] Dokumentation, Konfiguration und Migrationen wurden bei Bedarf aktualisiert.
- [ ] Es befinden sich keine unbeabsichtigten Änderungen oder Geheimnisse im Diff.
- [ ] Der GitHub Pull Request oder GitLab Merge Request beschreibt Änderung, Tests und bekannte Einschränkungen.
```

Adapt the DoD to the feature; remove irrelevant generic items and add repository-specific requirements.

## Story quality check

Before presenting a Story draft for approval, verify that it contains all of the following:

- a short, German, outcome-oriented title;
- a two- to four-sentence summary covering problem, affected users or context, and desired result;
- context and scope;
- observable, testable acceptance criteria;
- a Definition of Done tailored to the Story.

Use non-goals only when they prevent a likely misunderstanding. Use technical hints only when they materially constrain implementation. Do not create the Story until the draft passes this check and the user approves the complete draft.

## Approval and creation timing

- Software Factory: include the full Story draft in Gate 3. Gate 3 approval authorizes creation.
- Vibe Coding: include the full Story draft in the compact plan. Plan approval authorizes creation.
- Delivery only: create only when explicitly requested or required by the requested branch workflow, and show the draft before creation unless the user already supplied complete approved content.

## Create and record

1. Map content to dedicated Jira fields when available.
2. Use the field mapping established during Jira capability discovery. If acceptance criteria or DoD fields are unavailable, maintain them as explicit checklists in the description only when that description is editable.
3. Create exactly one Story.
4. Apply the effective Jira delivery defaults: set an assignee only when `jira.assignee.account_id` is non-null; leave it unassigned otherwise. Leave the Story in the backlog when `jira.sprint.placement` is `backlog`; for `active_sprint`, assign the uniquely resolved active sprint or ask when it is missing or ambiguous.
5. Resolve and apply the project's available transition to `jira.status.on_create`, default `In Arbeit`. Do not hard-code a transition ID or claim success when the transition is unavailable.
6. Capture and report issue key, title, status, project, and URL.
7. Write key and URL to local status when one exists.
8. Use the actual key for the final branch name.

## Active sprint resolution

For `jira.sprint.placement: active_sprint`, query open sprints in the target Jira project. Read the resolved Sprint field from a returned project issue and use the sprint whose state is `active` and whose board belongs to that project. Assign that sprint only when the project-board relationship and the active sprint are both unambiguous. If the query returns no usable project issue, no active sprint, or more than one eligible board, do not assign a sprint and do not silently fall back to the backlog. Ask whether the Story should remain in the backlog or which concrete sprint should be used.

## Final Jira verification and handoff

After the merge request exists, verify every acceptance criterion and Definition-of-Done item against concrete evidence. Mark only proven items complete using the established, editable Jira field mapping. If the project has no editable location for individual checklist state, leave the original checklist intact and report the proven and remaining items explicitly rather than claiming they were checked off. If every required item is proven, resolve and apply the transition to `jira.status.on_ready_for_testing`, default `Testen`. Otherwise leave the Story in its current status and report the remaining items.

## Link delivery

After creating the GitHub pull request or GitLab merge request:

- Add the MR URL to Jira through a link or comment when supported.
- Include the Jira key and URL in the MR description.
- Do not transition the Story to Done unless the user requests it and the workflow's completion criteria are actually satisfied.
