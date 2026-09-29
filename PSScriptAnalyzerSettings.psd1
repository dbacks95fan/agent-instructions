# Copyright (c) 2026 DPSystems, LLC.
# ABOUTME: PSScriptAnalyzer settings for this repo: all default analyzer rules plus the
# ABOUTME: OTBS formatting preset, so Invoke-ScriptAnalyzer and Invoke-Formatter agree.
@{
    IncludeDefaultRules = $true

    # Copied from PSScriptAnalyzer's built-in CodeFormattingOTBS preset.
    Rules               = @{
        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $false
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable              = $true
            Kind                = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize     = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $true
            CheckOpenParen                          = $true
            CheckOperator                           = $true
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $false
            CheckSeparator                          = $true
            CheckParameter                          = $false
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }

        PSUseCorrectCasing         = @{
            Enable = $true
        }
    }
}
