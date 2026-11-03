param(
    [string]$Mode = "install"
)

# Define exactly what items to manage within target paths
$ConfigList = @(
    @{ Title = "nvim";              Tujuan = "$env:USERPROFILE\AppData\Local";    IsFolder = $true;  TargetItems = @("*") }
    @{ Title = "Code";              Tujuan = "$env:USERPROFILE\AppData\Roaming";  IsFolder = $true;  TargetItems = @("User\settings.json", "User\keybindings.json") }
    @{ Title = "WindowsPowerShell"; Tujuan = "$env:USERPROFILE\Documents";        IsFolder = $true;  TargetItems = @("Microsoft.PowerShell_profile.ps1") }
    @{ Title = "gitconfig";         Tujuan = "";                                  IsFolder = $false; TargetItems = @() }
)

$SourceBase  = ".\src\config"
$HomeWindows = $env:USERPROFILE
$TotalItems  = $ConfigList.Count
$SimbolPlay  = [char]0x25B5  
$GarisLurus  = [char]0x2502  
$CabangTengah = "$([char]0x251C)$([char]0x2500)$([char]0x2500)" 
$CabangAkhir  = "$([char]0x2514)$([char]0x2500)$([char]0x2500)" 
$SimbolSukses = [char]0x2714  

if ($Mode -eq "uninstall") {
    Write-Host "$SimbolPlay Removing profile configurations" -ForegroundColor Cyan
    Write-Host "$GarisLurus" -ForegroundColor Gray
    for ($i = 0; $i -lt $TotalItems; $i++) {
        $Conf = $ConfigList[$i]
        $Branch = if ($i -eq $TotalItems - 1) { $CabangAkhir } else { $CabangTengah }
        $TitleStr = $Conf.Title
        
        if ($Conf.IsFolder -eq $true) {
            $TargetRoot = Join-Path -Path $Conf.Tujuan -ChildPath $TitleStr
            foreach ($SubItem in $Conf.TargetItems) {
                if ($SubItem -eq "*") {
                    if (Test-Path -Path $TargetRoot) {
                        Write-Host "$Branch [del] path '$TargetRoot'..." -ForegroundColor DarkYellow
                        cmd /c "rd /s /q `"$TargetRoot`"" 2>$null
                    }
                } else {
                    $TargetFile = Join-Path -Path $TargetRoot -ChildPath $SubItem
                    if (Test-Path -Path $TargetFile) {
                        Write-Host "$Branch [del] file '$TargetFile'..." -ForegroundColor DarkYellow
                        Remove-Item -Path $TargetFile -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        } else {
            $DotFileName = "." + $TitleStr
            $TargetFinalFile = Join-Path -Path $HomeWindows -ChildPath $DotFileName
            if (Test-Path -Path $TargetFinalFile) {
                Write-Host "$Branch [del] file '$TargetFinalFile'..." -ForegroundColor DarkYellow
                Remove-Item -Path $TargetFinalFile -Force -ErrorAction SilentlyContinue
            } else {
                Write-Host "$Branch [skip] '$DotFileName' already cleared" -ForegroundColor Gray
            }
        }
    }
    Write-Host "$GarisLurus" -ForegroundColor Gray
    Write-Host "$SimbolSukses Uninstall complete: targeted configurations cleared." -ForegroundColor Green
    Exit
}

Write-Host "$SimbolPlay Building profile configurations" -ForegroundColor Cyan
Write-Host "$GarisLurus" -ForegroundColor Gray
for ($i = 0; $i -lt $TotalItems; $i++) {
    $Conf = $ConfigList[$i]
    $Branch = if ($i -eq $TotalItems - 1) { $CabangAkhir } else { $CabangTengah }
    $TitleStr = $Conf.Title
    $FullPathSource = Join-Path -Path $SourceBase -ChildPath $TitleStr
    
    if (-not (Test-Path -Path $FullPathSource)) {
        Write-Host "$Branch [skip] source '$TitleStr' not found" -ForegroundColor DarkRed
        continue
    }
    
    if ($Conf.IsFolder -eq $true) {
        $TargetRoot = Join-Path -Path $Conf.Tujuan -ChildPath $TitleStr
        
        foreach ($SubItem in $Conf.TargetItems) {
            if ($SubItem -eq "*") {
                Write-Host "$Branch [copy] '$TitleStr\*' -> '$TargetRoot'..." -ForegroundColor DarkCyan
                if (Test-Path -Path $TargetRoot) { cmd /c "rd /s /q `"$TargetRoot`"" 2>$null }
                New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null
                Copy-Item -Path "$FullPathSource\*" -Destination $TargetRoot -Recurse -Force
            } else {
                $SourceFile = Join-Path -Path $FullPathSource -ChildPath $SubItem
                $TargetFile = Join-Path -Path $TargetRoot -ChildPath $SubItem
                
                if (Test-Path -Path $SourceFile) {
                    Write-Host "$Branch [copy] '$TitleStr\$SubItem' -> '$TargetFile'..." -ForegroundColor DarkCyan
                    $ParentDir = Split-Path -Path $TargetFile -Parent
                    if (-not (Test-Path -Path $ParentDir)) { New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null }
                    Copy-Item -Path $SourceFile -Destination $TargetFile -Force
                }
            }
        }
    } else {
        $DotFileName = "." + $TitleStr
        $TargetFinalFile = Join-Path -Path $HomeWindows -ChildPath $DotFileName
        Write-Host "$Branch [copy] '$TitleStr' -> '$TargetFinalFile'..." -ForegroundColor DarkCyan
        Copy-Item -Path $FullPathSource -Destination $TargetFinalFile -Force
    }
}
Write-Host "$GarisLurus" -ForegroundColor Gray
Write-Host "$SimbolSukses Activation finished successfully." -ForegroundColor Green