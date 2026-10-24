$ConfigList = @(
    @{ Title = "nvim";       Tujuan = "$env:USERPROFILE\AppData\Local"; IsFolder = $true }
    @{ Title = "WindowsPowerShell";       Tujuan = "$env:USERPROFILE\Documents"; IsFolder = $true }
    @{ Title = "gitconfig";  Tujuan = "";                               IsFolder = $false }
)
$SourceBase  = ".\src\config"
$HomeWindows = $env:USERPROFILE
$Mode        = $args
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
            $TargetFinal = Join-Path -Path $Conf.Tujuan -ChildPath $TitleStr
            if (Test-Path -Path $TargetFinal) {
                Write-Host "$Branch [del] path '$TargetFinal'..." -ForegroundColor DarkYellow
                Remove-Item -Path $TargetFinal -Recurse -Force
            } else {
                Write-Host "$Branch [skip] '$TitleStr' already cleared" -ForegroundColor Gray
            }
        } else {
            $DotFileName = "." + $TitleStr
            $TargetFinalFile = Join-Path -Path $HomeWindows -ChildPath $DotFileName
            if (Test-Path -Path $TargetFinalFile) {
                Write-Host "$Branch [del] file '$TargetFinalFile'..." -ForegroundColor DarkYellow
                Remove-Item -Path $TargetFinalFile -Force
            } else {
                Write-Host "$Branch [skip] '$DotFileName' already cleared" -ForegroundColor Gray
            }
        }
    }
    Write-Host "$GarisLurus" -ForegroundColor Gray
    Write-Host "$SimbolSukses Uninstall complete: generations cleared." -ForegroundColor Green
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
        $TargetFinal = Join-Path -Path $Conf.Tujuan -ChildPath $TitleStr
        Write-Host "$Branch [copy] '$TitleStr' -> '$TargetFinal'..." -ForegroundColor DarkCyan
        if (Test-Path -Path $TargetFinal) {
            Remove-Item -Path $TargetFinal -Recurse -Force
        }
        New-Item -ItemType Directory -Path $TargetFinal -Force | Out-Null
        Copy-Item -Path "$FullPathSource\*" -Destination $TargetFinal -Recurse -Force
    } else {
        $DotFileName = "." + $TitleStr
        $TargetFinalFile = Join-Path -Path $HomeWindows -ChildPath $DotFileName
        Write-Host "$Branch [copy] '$TitleStr' -> '$TargetFinalFile'..." -ForegroundColor DarkCyan
        Copy-Item -Path $FullPathSource -Destination $TargetFinalFile -Force
    }
}
Write-Host "$GarisLurus" -ForegroundColor Gray
Write-Host "$SimbolSukses Activation finished successfully." -ForegroundColor Green
