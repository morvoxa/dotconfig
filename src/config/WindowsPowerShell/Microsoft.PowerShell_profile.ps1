function Remove-StubbornItem {
    param([string]$Path)
    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Recurse -Force
    }
}
Set-Alias -Name fdel -Value Remove-StubbornItem

function Invoke-GitConventionalCommit {
    param([string]$InputArgs)
    $MessageInput = $InputArgs
    if ([string]::IsNullOrEmpty($MessageInput)) {
        $MessageInput = Read-Host "Enter commit message"
    }
    $Scope = ($MessageInput -split ' ')[0]
    $Message = ($MessageInput -split ' ', 2)[1]
    $FormattedMsg = "[$Scope]: $Message"
    Write-Host "Proposed commit message:"
    Write-Host $FormattedMsg
    Write-Host ""
    $Confirm = Read-Host "Do you want to run git add, commit, and push? (y/n)"
    if ($Confirm -eq "y" -or $Confirm -eq "Y") {
        git add .
        git commit -m $FormattedMsg
        git push
        Write-Host "Git add, commit, and push completed." -ForegroundColor Green
    } else {
        Write-Host "Process aborted." -ForegroundColor Yellow
    }
}
Set-Alias -Name cmt -Value Invoke-GitConventionalCommit
