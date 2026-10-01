[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$FixturePath,
    [Parameter(Mandatory = $true)][string]$IssueKey
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$fixture = Get-Content -LiteralPath $FixturePath -Raw | ConvertFrom-Json
$boards = @($fixture.mock_project.boards)
$active = @($boards | ForEach-Object { $_.active_sprints } | Where-Object { $null -ne $_ })
if ($active.Count -ne 1) { throw 'Mock sprint assignment is ambiguous or missing.' }
$issue = $fixture.mock_issue
if ($issue.key -ne $IssueKey) { throw "Mock issue not found: $IssueKey" }
if ($issue.sprint.id -ne $active[0].id) { throw 'Mock issue sprint does not match the active sprint.' }
[pscustomobject]@{
    connector = 'mock-jira-sprint'
    issue_key = $IssueKey
    board_id = $boards[0].id
    sprint_id = $active[0].id
    sprint_name = $active[0].name
    assignment = 'simulated'
    external_action = $false
} | ConvertTo-Json -Depth 5
