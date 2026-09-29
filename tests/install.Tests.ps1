# Copyright (c) 2026 DPSystems, LLC.
# ABOUTME: Pester tests for install.ps1: unit tests for Get-Plan, integration tests that
# ABOUTME: run the script in-process, and end-to-end runs in a fresh powershell.exe.

BeforeAll {
    $script:InstallScript = (Resolve-Path (Join-Path $PSScriptRoot '..\install.ps1')).Path
    $script:RepoRoot = Split-Path $InstallScript -Parent

    # Runs a new powershell.exe, as a user would. $HomeDir redirects the child's $HOME so
    # -Global runs never touch the real profile.
    function Invoke-ChildPowerShell {
        param([string]$Arguments, [string]$HomeDir)

        $psi = New-Object System.Diagnostics.ProcessStartInfo 'powershell.exe'
        $psi.Arguments = "-NoProfile -NonInteractive $Arguments"
        $psi.UseShellExecute = $false
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        if ($HomeDir) {
            $psi.EnvironmentVariables['USERPROFILE'] = $HomeDir
            $psi.EnvironmentVariables['HOMEDRIVE'] = Split-Path $HomeDir -Qualifier
            $psi.EnvironmentVariables['HOMEPATH'] = Split-Path $HomeDir -NoQualifier
        }
        $process = [System.Diagnostics.Process]::Start($psi)
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        [pscustomobject]@{ ExitCode = $process.ExitCode; StdOut = $stdout; StdErr = $stderr }
    }

    # Uses -Command rather than -File: -File passes 'a,b' as one string, not an array, so
    # -Tools claude,codex would fail validation. Users run the script from a prompt.
    function Invoke-Installer {
        param([string]$Arguments, [string]$HomeDir)

        Invoke-ChildPowerShell -Arguments "-Command `"& '$InstallScript' $Arguments`"" -HomeDir $HomeDir
    }
}

Describe 'Get-Plan (unit)' {
    BeforeAll {
        # Load only Get-Plan: running the whole script would install files.
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($InstallScript, [ref]$null, [ref]$null)
        $definition = $ast.Find({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-Plan'
            }, $true)
        . ([scriptblock]::Create($definition.Extent.Text))

        # Get-Plan reads $repo and $canonical from install.ps1's script scope.
        $script:repo = $RepoRoot
        $script:canonical = Join-Path $RepoRoot 'AGENTS.md'
        $script:root = 'C:\example\project'
    }

    It 'plans the Claude pointer and AGENTS.md at the project root' {
        $plan = Get-Plan -Tool 'claude' -Root $root -IsGlobal $false

        $plan.Count | Should -Be 2
        $plan[0].Src | Should -Be (Join-Path $RepoRoot 'pointers\CLAUDE.md')
        $plan[0].Dst | Should -Be 'C:\example\project\CLAUDE.md'
        $plan[1].Src | Should -Be $canonical
        $plan[1].Dst | Should -Be 'C:\example\project\AGENTS.md'
    }

    It 'plans the Gemini pointer and AGENTS.md at the project root' {
        $plan = Get-Plan -Tool 'gemini' -Root $root -IsGlobal $false

        $plan.Dst | Should -Be @('C:\example\project\GEMINI.md', 'C:\example\project\AGENTS.md')
    }

    It 'plans only AGENTS.md for Codex' {
        $plan = @(Get-Plan -Tool 'codex' -Root $root -IsGlobal $false)

        $plan.Count | Should -Be 1
        $plan[0].Dst | Should -Be 'C:\example\project\AGENTS.md'
    }

    It 'plans a full copy into .github for Copilot' {
        $plan = @(Get-Plan -Tool 'copilot' -Root $root -IsGlobal $false)

        $plan[0].Src | Should -Be $canonical
        $plan[0].Dst | Should -Be 'C:\example\project\.github\copilot-instructions.md'
    }

    It 'targets <Folder> under $HOME for a global <Tool> install' -ForEach @(
        @{ Tool = 'claude'; Folder = '.claude' }
        @{ Tool = 'gemini'; Folder = '.gemini' }
        @{ Tool = 'codex'; Folder = '.codex' }
    ) {
        $plan = Get-Plan -Tool $Tool -Root $root -IsGlobal $true

        foreach ($item in $plan) {
            Split-Path $item.Dst -Parent | Should -Be (Join-Path $HOME $Folder)
        }
    }

    It 'refuses a global Copilot install' {
        { Get-Plan -Tool 'copilot' -Root $root -IsGlobal $true } | Should -Throw '*no global instructions file*'
    }
}

Describe 'install.ps1 (integration)' {
    BeforeEach {
        $target = Join-Path $TestDrive ([guid]::NewGuid())
        New-Item -ItemType Directory -Path $target | Out-Null
    }

    It 'returns one result object per file written' {
        $results = & $InstallScript -Target $target -Tools claude

        $results.Count | Should -Be 2
        $results | ForEach-Object { $_.Tool | Should -Be 'claude'; $_.Action | Should -Be 'Wrote' }
        $results.Path | Should -Be @((Join-Path $target 'CLAUDE.md'), (Join-Path $target 'AGENTS.md'))
    }

    It 'copies each file byte-for-byte from its source' {
        & $InstallScript -Target $target -Tools claude, copilot | Out-Null

        (Get-FileHash (Join-Path $target 'CLAUDE.md')).Hash | Should -Be (Get-FileHash (Join-Path $RepoRoot 'pointers\CLAUDE.md')).Hash
        (Get-FileHash (Join-Path $target 'AGENTS.md')).Hash | Should -Be (Get-FileHash (Join-Path $RepoRoot 'AGENTS.md')).Hash
        (Get-FileHash (Join-Path $target '.github\copilot-instructions.md')).Hash | Should -Be (Get-FileHash (Join-Path $RepoRoot 'AGENTS.md')).Hash
    }

    It 'reports a file shared by two tools as already written' {
        $results = & $InstallScript -Target $target -Tools claude, codex

        $codex = $results | Where-Object Tool -EQ 'codex'
        $codex.Action | Should -Be 'AlreadyWritten'
        $codex.Path | Should -Be (Join-Path $target 'AGENTS.md')
    }

    It 'skips an existing file and warns, leaving it unchanged' {
        Set-Content -Path (Join-Path $target 'AGENTS.md') -Value 'keep me'

        $results = & $InstallScript -Target $target -Tools codex -WarningVariable warnings -WarningAction SilentlyContinue

        $results.Action | Should -Be 'Skipped'
        $warnings.Count | Should -Be 1
        $warnings[0].Message | Should -BeLike '*use -Force*'
        Get-Content (Join-Path $target 'AGENTS.md') | Should -Be 'keep me'
    }

    It 'overwrites an existing file with -Force' {
        Set-Content -Path (Join-Path $target 'AGENTS.md') -Value 'replace me'

        $results = & $InstallScript -Target $target -Tools codex -Force

        $results.Action | Should -Be 'Wrote'
        (Get-FileHash (Join-Path $target 'AGENTS.md')).Hash | Should -Be (Get-FileHash (Join-Path $RepoRoot 'AGENTS.md')).Hash
    }

    It 'writes nothing to the information stream' {
        $info = & $InstallScript -Target $target -Tools claude 6>&1 |
            Where-Object { $_ -is [System.Management.Automation.InformationRecord] }

        $info | Should -BeNullOrEmpty
    }

    It 'reports the target and the drift reminder as verbose messages' {
        $verbose = & $InstallScript -Target $target -Tools codex -Verbose 4>&1 |
            Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

        $verbose.Message | Should -Contain "Target project: $target"
        ($verbose.Message -join "`n") | Should -BeLike '*Re-run after editing AGENTS.md*'
    }

    It 'fails when the target directory does not exist' {
        { & $InstallScript -Target (Join-Path $target 'missing') -Tools codex } | Should -Throw
    }
}

Describe 'install.ps1 (end-to-end)' {
    BeforeEach {
        $target = Join-Path $TestDrive ([guid]::NewGuid())
        New-Item -ItemType Directory -Path $target | Out-Null
    }

    It 'installs every tool into a project and exits 0' {
        $run = Invoke-Installer -Arguments "-Target '$target' -Tools claude,gemini,codex,copilot"

        $run.ExitCode | Should -Be 0
        $run.StdErr | Should -BeNullOrEmpty
        foreach ($file in 'CLAUDE.md', 'GEMINI.md', 'AGENTS.md', '.github\copilot-instructions.md') {
            Join-Path $target $file | Should -Exist
        }
        $run.StdOut | Should -BeLike '*Wrote*'
    }

    It 'installs Claude into a redirected home with -Global' {
        $fakeHome = Join-Path $TestDrive ([guid]::NewGuid())
        New-Item -ItemType Directory -Path $fakeHome | Out-Null

        # Guard: never run a -Global install unless the child's $HOME is the fake one.
        $probe = Invoke-ChildPowerShell -Arguments '-Command "$HOME"' -HomeDir $fakeHome
        $probe.StdOut.Trim() | Should -Be $fakeHome

        $run = Invoke-Installer -Arguments '-Global -Tools claude' -HomeDir $fakeHome

        $run.ExitCode | Should -Be 0
        Join-Path $fakeHome '.claude\CLAUDE.md' | Should -Exist
        Join-Path $fakeHome '.claude\AGENTS.md' | Should -Exist
    }

    It 'exits non-zero when the target directory does not exist' {
        $run = Invoke-Installer -Arguments "-Target '$(Join-Path $target 'missing')' -Tools codex"

        $run.ExitCode | Should -Not -Be 0
        $run.StdErr | Should -Not -BeNullOrEmpty
    }
}
