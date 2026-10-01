[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$FixturePath,
    [Parameter(Mandatory = $true)][string]$SearchString
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$fixture = Get-Content -LiteralPath $FixturePath -Raw | ConvertFrom-Json
$matches = @($fixture.mock_jira.users | Where-Object { $_.displayName -like "*$SearchString*" })
[pscustomobject]@{
    connector = 'mock-jira-read'
    query = $SearchString
    result_count = $matches.Count
    users = $matches
    external_action = $false
} | ConvertTo-Json -Depth 5
