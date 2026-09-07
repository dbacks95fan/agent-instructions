# ABOUTME: Copies the canonical AGENTS.md and any per-tool pointer file into a target
# ABOUTME: project directory (or the global tool config dirs), so an agent picks up the
# ABOUTME: canonical rules without hand-copying files each time.

[CmdletBinding(DefaultParameterSetName = 'Project')]
param(
    # Project directory to install into. Defaults to the current directory.
    [Parameter(ParameterSetName = 'Project', Position = 0)]
    [string]$Target = (Get-Location).Path,

    # Install into the tools' global config locations instead of a project.
    [Parameter(ParameterSetName = 'Global', Mandatory)]
    [switch]$Global,

    # Which tools to wire. Any of: claude, gemini, codex, copilot.
    [Parameter(Mandatory)]
    [ValidateSet('claude', 'gemini', 'codex', 'copilot')]
    [string[]]$Tools,

    # Overwrite existing files without prompting.
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$canonical = Join-Path $repo 'AGENTS.md'

if (-not (Test-Path $canonical)) {
    throw "Canonical file not found: $canonical"
}

# Resolve where each tool's files go.
#  - codex/copilot read AGENTS.md-style files directly and have no import syntax, so the
#    canonical content is copied in full.
#  - claude/gemini read their own filename; they get a pointer file plus a copy of
#    AGENTS.md beside it so the pointer's @import resolves.
function Get-Plan {
    param([string]$Tool, [string]$Root, [bool]$IsGlobal)

    switch ($Tool) {
        'claude' {
            $dir = if ($IsGlobal) { Join-Path $HOME '.claude' } else { $Root }
            @(
                @{ Src = Join-Path $repo 'pointers\CLAUDE.md'; Dst = Join-Path $dir 'CLAUDE.md' }
                @{ Src = $canonical;                            Dst = Join-Path $dir 'AGENTS.md' }
            )
        }
        'gemini' {
            $dir = if ($IsGlobal) { Join-Path $HOME '.gemini' } else { $Root }
            @(
                @{ Src = Join-Path $repo 'pointers\GEMINI.md'; Dst = Join-Path $dir 'GEMINI.md' }
                @{ Src = $canonical;                            Dst = Join-Path $dir 'AGENTS.md' }
            )
        }
        'codex' {
            $dir = if ($IsGlobal) { Join-Path $HOME '.codex' } else { $Root }
            @( @{ Src = $canonical; Dst = Join-Path $dir 'AGENTS.md' } )
        }
        'copilot' {
            if ($IsGlobal) { throw "copilot has no global instructions file; use -Target on a repo." }
            @( @{ Src = $canonical; Dst = Join-Path $Root '.github\copilot-instructions.md' } )
        }
    }
}

$isGlobal = $PSCmdlet.ParameterSetName -eq 'Global'
if (-not $isGlobal) {
    $Target = (Resolve-Path $Target).Path
    Write-Host "Target project: $Target"
} else {
    Write-Host "Target: global tool config under $HOME"
}

# Track destinations already written this run so overlapping tool plans (e.g. claude and
# codex both wanting AGENTS.md at the repo root) don't warn about a file we just created.
$written = @{}

foreach ($tool in $Tools) {
    Write-Host "`n[$tool]"
    foreach ($item in Get-Plan -Tool $tool -Root $Target -IsGlobal $isGlobal) {
        if ($written.ContainsKey($item.Dst)) {
            Write-Host "  already written this run: $($item.Dst)"
            continue
        }
        $dstDir = Split-Path $item.Dst -Parent
        if (-not (Test-Path $dstDir)) {
            New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
        }
        if ((Test-Path $item.Dst) -and -not $Force) {
            Write-Warning "  exists, skipping (use -Force): $($item.Dst)"
            continue
        }
        Copy-Item -Path $item.Src -Destination $item.Dst -Force
        $written[$item.Dst] = $true
        Write-Host "  wrote $($item.Dst)"
    }
}

Write-Host "`nDone. Re-run after editing AGENTS.md so full copies (codex/copilot) don't drift."
