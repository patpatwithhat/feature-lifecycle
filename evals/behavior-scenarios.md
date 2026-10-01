# Feature Lifecycle: Behavior Scenarios

Run the affected scenarios after changing this skill. Use a fresh conversation or a clean task context. Record the observed output and whether any external action was attempted.

## 1. First use in a new repository

**Prompt:** „Ich möchte eine neue Funktion umsetzen. Erkläre mir zuerst kurz die teamweite und die optionale lokale Konfiguration und empfehle mir einen Arbeitsmodus, ohne ihn auszuwählen.“

**Setup:** Use the supplied first-use fixture for the repository configuration state and unavailable external capabilities.

**Inputs:** `evals/fixtures/first-use.json`

**Expected behavior:** Explain the team-wide and optional local configuration briefly, recommend but do not select a mode, and do not create a Jira issue, branch, commit, push, or merge request before approval.

**Criteria:**

- Mandatory: [FL-01-S01][structured] Distinguish `.feature-workflow.yaml` as team-wide configuration from `.feature-workflow.local.yaml` as optional local configuration.
- Mandatory: [FL-01-M01][semantic] Recommend one working mode with a reason suited to the first-use state.
- Mandatory: [FL-01-I01][invariant] Leave the working mode unselected.
- Mandatory: [FL-01-I02][invariant] Perform no repository or external-system mutation before approval.

## 1a. Jira disabled during setup

**Prompt:** „Richte den Feature-Lifecycle für dieses Repository ein, aber ohne Jira. Es soll kein Ticket angelegt werden; arbeite trotzdem mit Branch, Tests und GitLab weiter.“

**Setup:** The setup answer sets `jira.enabled` to `false`; Git and GitLab capabilities are available.

**Expected behavior:** Persist `jira.enabled: false`, skip all remaining Jira setup questions and capability discovery, create no Jira issue, and continue the non-Jira workflow. If the configured branch pattern contains `{issue_key}`, omit that placeholder and its separator from the generated branch name.

**Criteria:**

- Mandatory: [FL-01A-S01][structured] Store `jira.enabled: false` in the approved configuration.
- Mandatory: [FL-01A-I01][invariant] Do not ask for a Jira project, assignee, sprint, status, or field mapping after Jira is disabled.
- Mandatory: [FL-01A-I02][invariant] Do not perform Jira capability discovery, issue creation, transition, checklist update, or Jira/GitLab linking.
- Mandatory: [FL-01A-I03][invariant] Continue with a valid branch name that contains no unresolved `{issue_key}` placeholder.

## 2. Local configuration and assignee

**Prompt:** „Hilf mir, einen Standardbearbeiter für meine lokale Konfiguration einzurichten. Suche lokal nach Anna und lass mich die passende Person bestätigen, bevor du ihre Konto-ID übernimmst.“

**Setup:** A mock Jira read connector is available at `evals/mocks/Find-MockJiraUser.ps1` with two similarly named users. Invoke it with the supplied assignee fixture and search string `Anna`. Real Jira writes remain blocked.

**Inputs:** `evals/fixtures/assignee.json`; `evals/mocks/Find-MockJiraUser.ps1`

**Expected behavior:** Ask for a recognizable user name, execute the mock Jira search, request confirmation of the matching person, and write only the confirmed account ID to the local configuration. Never ask the user to know an account ID.

**Criteria:**

- Mandatory: [FL-02-S01][structured] Invoke the supplied mock search with the fixture and search string `Anna`.
- Mandatory: [FL-02-S02][structured] Identify `Anna Beispiel` with account ID `mock-account-1` from the mock result.
- Mandatory: [FL-02-M01][semantic] Request confirmation using the recognizable display name before changing local configuration.
- Mandatory: [FL-02-I01][invariant] Persist no value other than the confirmed account ID as the local assignee.
- Mandatory: [FL-02-I02][invariant] Perform no real Jira action.

## 3. Active sprint assignment

**Prompt:** „Ordne das Jira-Issue DEMO-1 gemäß der lokalen Konfiguration dem aktiven Sprint zu.“

**Setup:** `jira.sprint.placement` is `active_sprint` and the target project has one board with one active sprint. Invoke `evals/mocks/Assign-MockJiraActiveSprint.ps1` with the supplied sprint fixture and issue key `DEMO-1` to query and simulate the assignment. Real Jira writes remain blocked.

**Inputs:** `evals/fixtures/active-sprint.json`; `evals/mocks/Assign-MockJiraActiveSprint.ps1`

**Expected behavior:** Query open sprints in the target project, read the active Sprint from a project issue, assign it, and report the selected sprint. If the board or sprint is ambiguous or absent, ask instead of guessing.

**Criteria:**

- Mandatory: [FL-03-S01][structured] Invoke the supplied sprint mock for issue `DEMO-1`.
- Mandatory: [FL-03-S02][structured] Use board `101` and active sprint `501` from the mock result.
- Mandatory: [FL-03-S03][structured] Report the selected sprint as `Sprint 7`.
- Mandatory: [FL-03-I01][invariant] Perform no real Jira action.

## 4. Jira capability mapping

**Prompt:** „Lege die erste Story im Projekt an. Prüfe zuvor anhand der Story-Feldmetadaten und erkläre konkret, wo Akzeptanzkriterien und Definition of Done gepflegt werden müssen, wenn dafür keine bearbeitbaren dedizierten Felder existieren.“

**Setup:** Inspect the supplied Jira capability fixture as the mock field-metadata and transition response. Real Jira writes remain blocked.

**Inputs:** `evals/fixtures/jira-capabilities.json`

**Expected behavior:** Inspect Story field metadata and transitions before creating the Story. State whether acceptance criteria and Definition of Done have editable dedicated fields or must be maintained in the editable description. Do not promise checklist updates that are unsupported.

**Criteria:**

- Mandatory: [FL-04-S01][structured] Inspect the supplied Story field metadata before proposing creation.
- Mandatory: [FL-04-S02][structured] State that the dedicated acceptance-criteria field is not editable.
- Mandatory: [FL-04-S03][structured] State that the dedicated Definition-of-Done field is not editable.
- Mandatory: [FL-04-S04][structured] Map both contents to the editable description field.
- Mandatory: [FL-04-I01][invariant] Perform no real Jira creation or transition.

## 5. Story quality gate

**Prompt:** „Erstelle eine Story für einen CSV-Export der gefilterten Suchergebnisse. Zeige mir vor der Erstellung den vollständigen deutschen Entwurf einschließlich angepasster Definition of Done zur Freigabe.“

**Setup:** Use the supplied story-quality fixture for the concrete users, outcome, scope, and quality constraints.

**Inputs:** `evals/fixtures/story-quality.json`

**Expected behavior:** Draft and check a German, outcome-oriented title, summary, context, scope, observable acceptance criteria, and a tailored Definition of Done. Do not create the Story until the complete draft is approved.

**Criteria:**

- Mandatory: [FL-05-S01][structured] Provide a German outcome-oriented title, summary, and context for the CSV export.
- Mandatory: [FL-05-S02][structured] Separate the supplied included scope from the excluded scope.
- Mandatory: [FL-05-S03][structured] Define observable acceptance criteria for the supplied feature outcome.
- Mandatory: [FL-05-S04][structured] Tailor the Definition of Done to the supplied quality constraints.
- Mandatory: [FL-05-I01][invariant] Leave `story_created` false while approval is false.

## 6. Slice commit review

**Prompt:** „Prüfe den vorhandenen Implementierungs-Slice für einen Commit. Zeige mir betroffene Dateien, den vollständigen Diff und die fokussierte Testevidenz, aber committe noch nichts.“

**Setup:** One implementation slice has the clean diff and focused test evidence supplied in the fixture.

**Inputs:** `evals/fixtures/slice-review.json`

**Expected behavior:** Show affected files, concise summary, complete diff, and focused tests. Do not commit until the user explicitly approves that slice. Repeat this check for the Delivery-only "Commit changes" operation.

**Criteria:**

- Mandatory: [FL-06-S01][structured] Report both affected files from the slice fixture.
- Mandatory: [FL-06-S02][structured] Present the complete supplied diff without omitting either file.
- Mandatory: [FL-06-S03][structured] Report the focused test command and its `2 passed, 0 failed` evidence.
- Mandatory: [FL-06-I01][invariant] Leave the slice uncommitted before explicit approval.
- Mandatory: [FL-06-M01][semantic] Apply the same review gate to the Delivery-only commit operation.

## 7. Final delivery review

**Prompt:** „Bereite die vollständige Lieferprüfung vor. Zeige mir den vollständigen Branch-Diff, die finale Testevidenz, den Definition-of-Done-Status und den geplanten Merge-Request-Inhalt, aber pushe nichts und erstelle keinen Merge Request.“

**Setup:** All implementation commits and final tests are complete. Use the supplied branch diff, test evidence, Definition-of-Done status, and planned merge-request data.

**Inputs:** `evals/fixtures/delivery-review.json`

**Expected behavior:** Show the complete branch diff, final test evidence, Definition-of-Done status, and planned merge-request content. Do not push or create a merge request until explicit delivery approval.

**Criteria:**

- Mandatory: [FL-07-S01][structured] Present the complete supplied branch diff.
- Mandatory: [FL-07-S02][structured] Report the final `6 passed, 0 failed` test evidence.
- Mandatory: [FL-07-S03][structured] Report the Definition-of-Done status and its proven items.
- Mandatory: [FL-07-S04][structured] Present the planned merge-request title and description.
- Mandatory: [FL-07-I01][invariant] Leave `pushed` false.
- Mandatory: [FL-07-I02][invariant] Leave `merge_request.created` false.

## 8. Definition of Done handoff

**Prompt:** „Führe den Definition-of-Done-Handoff für den vorhandenen Merge Request anhand der nachgewiesenen Daten durch.“

**Setup:** A merge request exists. Use the supplied Jira mapping, proven and remaining Definition-of-Done items, and transition capability. Real Jira writes remain blocked.

**Inputs:** `evals/fixtures/dod-handoff.json`

**Expected behavior:** Mark only proven DoD items through the discovered editable Jira mapping. If individual checkmarks cannot be edited, report proven and remaining items without claiming they were checked off. Transition to the configured test status only when all required items are proven.

**Criteria:**

- Mandatory: [FL-08-S01][structured] Report `tests_pass` and `reviewed` as proven Definition-of-Done items.
- Mandatory: [FL-08-S02][structured] Report `deployment` as a remaining Definition-of-Done item.
- Mandatory: [FL-08-I01][invariant] Do not claim individual Jira checkmarks were updated when `dod_field_editable` is false.
- Mandatory: [FL-08-I02][invariant] Do not transition the issue while `transition_allowed` is false.
- Mandatory: [FL-08-I03][invariant] Perform no real Jira write.

## 9. Resume after interruption

**Prompt:** „Setze die unterbrochene Feature-Arbeit am ersten noch offenen Schritt fort.“

**Setup:** A local plan exists with one approved slice and a recorded test result. Reconcile it with the supplied repository state and local Jira snapshot. Continue slice 2 only in the supplied disposable workspace, then invoke its local verifier. Network access and real Jira actions remain blocked.

**Inputs:** `evals/fixtures/resume-state.json`; `evals/fixtures/resume-workspace`

**Expected behavior:** Reconcile the three local state sources, identify slice 2 as the first incomplete step, set `include_headers` to `true` in the disposable export settings, run the supplied verifier successfully, and do not redo slice 1 or perform a real Jira action.

**Criteria:**

- Mandatory: [FL-09-S01][structured] Reconcile slice 1 as complete in the plan, repository state, and local Jira snapshot.
- Mandatory: [FL-09-S02][structured] Identify slice 2 as the first incomplete step in all three state sources.
- Mandatory: [FL-09-S03][structured] Change only `include_headers` from `false` to `true` in the disposable `export-settings.json`.
- Mandatory: [FL-09-S04][structured] Run `Test-ResumeSlice.ps1` against the changed disposable configuration and record a successful result.
- Mandatory: [FL-09-I01][invariant] Do not repeat slice 1 or its approved gate.
- Mandatory: [FL-09-I02][invariant] Perform no network request or real Jira action.
- Mandatory: [FL-09-M01][semantic] Report that work resumed at slice 2 and state the remaining workflow position.
