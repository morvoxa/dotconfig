function Invoke-VsEnvCmd {
    # 1. Define the path to your .bat file (Adjust this path if necessary)
    $batPath = "$HOME/Desktop/MSVC/setup_x64.bat"
    
    if (-not (Test-Path $batPath)) {
        Write-Error "The .bat file was not found at: $batPath"
        return
    }

    Write-Host "Initializing MSVC environment via CMD..." -ForegroundColor Cyan

    # 2. Run the .bat in CMD, then output all the resulting environment variables
    $envBlock = cmd.exe /c " `"$batPath`" && set "
    
    # 3. Capture and inject these variables into the active PowerShell session
    foreach ($line in $envBlock) {
        if ($line -match "^([^=]+)=(.*)$") {
            $varName  = $Matches[1]
            $varValue = $Matches[2]
            
            # Exclude specific internal CMD variables to prevent conflicts
            if ($varName -notin @('ALLUSERSPROFILE', 'APPDATA', 'COMPUTERNAME', 'ComSpec', 'HOMEDRIVE', 'HOMEPATH', 'LOCALAPPDATA', 'LOGONSERVER', 'NUMBER_OF_PROCESSORS', 'OS', 'PATHEXT', 'PROCESSOR_ARCHITECTURE', 'PROCESSOR_IDENTIFIER', 'PROCESSOR_LEVEL', 'PROCESSOR_REVISION', 'ProgramData', 'ProgramFiles', 'ProgramFiles(x86)', 'ProgramW6432', 'PSModulePath', 'PUBLIC', 'SystemDrive', 'SystemRoot', 'TEMP', 'TMP', 'USERDOMAIN', 'USERDOMAIN_ROAMING', 'USERNAME', 'USERPROFILE', 'windir')) {
                [Environment]::SetEnvironmentVariable($varName, $varValue, [EnvironmentVariableTarget]::Process)
            }
            # Handle the PATH variable separately to avoid overwriting standard system tools
            elseif ($varName -eq 'PATH') {
                $env:PATH = $varValue
            }
        }
    }
    Write-Host "Environment successfully loaded into this PowerShell session!" -ForegroundColor Green
}
Invoke-VsEnvCmd
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
