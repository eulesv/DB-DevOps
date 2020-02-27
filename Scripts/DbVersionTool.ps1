[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    [bool]
    $update 
)
$current = Select-String -Path .\apply.sql -Pattern "EXEC cicd.SetCurrentVersion"
$current = $current.Line.Replace("EXEC cicd.SetCurrentVersion", "").Replace("'", "").Trim()
$previous = Select-String -Path .\apply.sql -Pattern "EXEC @check = cicd.CheckVersion "
$previous = $previous.Line.Replace("EXEC @check = cicd.CheckVersion ", "").Replace("'", "").Trim()
$next = (New-Guid).ToString()
Write-Host "`r`nDatabase Versioning Tool`r`n========================"
Write-Host "`r`nRollback Version: $previous"
Write-Host "Current Version : $current"
if ($update.IsPresent) {
    Write-Host "Next Version    : $next"

    Write-Host "`r`n`tUpdating apply..."
    [bool]$flag = $false
    [string]$file = ""
    [string]$tmp = ""
    Get-Content .\apply.sql | ForEach-Object {
        if (-not $_.ToString().StartsWith("--##!")) {
            if (-not $flag) {
                $file = $file + $_ + "`r`n"
            }
            elseif ($_.ToString().Trim() -ne "") {
                $tmp = $tmp + $_ + "`r`n"
            }
        }
        else {
            $flag = -not $flag
            if ($flag) {
                $file = $file + "--##!`r`n`r`n`r`n`r`n--##!`r`n"
            }
        }
    }
    if ($tmp.Trim() -eq "") {
        Write-Host "`tNothing to update... Aborting job!`r`n"
        return
    }
    $file.Replace($current, $next).Replace($previous, $current) | Set-Content .\apply.sql

    Write-Host "`tUpdating model..."
    $file = ""
    Get-Content .\model.sql | ForEach-Object {
        if (-not $_.ToString().StartsWith("--##!")) {
            $file = $file + $_ + "`r`n"
        }
        else {
            $file = $file + $tmp + "`r`n--##!`r`n"
        }
    }
    $file.Replace($previous, $current) | Set-Content .\model.sql
    
    Write-Host "`tUpdating undo...`r`n"
    $flag = $false
    $file = ""
    Get-Content .\undo.sql | ForEach-Object {
        if (-not $_.ToString().StartsWith("--##!")) {
            if (-not $flag) {
                $file = $file + $_ + "`r`n"
            }
        }
        else {
            $flag = -not $flag
            if ($flag) {
                $file = $file + "--##!`r`n`r`n`r`n`r`n--##!`r`n"
            }
        }
    }
    $file.Replace($current, $next).Replace($previous, $current) | Set-Content .\undo.sql

    Write-Host "`tClearing sampledata...`r`n"
    Clear-Content .\sampledata.sql
    
    Write-Host "Update Completed!`r`n"
}
else {
    Write-Host 
}