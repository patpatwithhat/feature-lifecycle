[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
if ($config.include_headers -ne $true) { throw 'include_headers must be true after slice-2.' }
if ($config.delimiter -ne ',') { throw 'slice-2 must preserve delimiter.' }
if ($config.encoding -ne 'utf-8') { throw 'slice-2 must preserve encoding.' }

[pscustomobject]@{
    result = 'passed'
    verified_slice = 'slice-2'
    include_headers = [bool]$config.include_headers
} | ConvertTo-Json
