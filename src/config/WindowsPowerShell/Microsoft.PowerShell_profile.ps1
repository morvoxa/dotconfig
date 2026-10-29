function Invoke-VsEnvCmd {
    # 1. Tentukan path ke file .bat Anda (Sesuaikan path jika berbeda)
    $batPath = "$HOME/Desktop/MSVC/setup_x64.bat"
    
    if (-not (Test-Path $batPath)) {
        Write-Error "File .bat tidak ditemukan di: $batPath"
        return
    }

    Write-Host "Menginisialisasi lingkungan MSVC via CMD..." -ForegroundColor Cyan

    # 2. Jalankan .bat di CMD, lalu cetak semua environment variable yang dihasilkan
    $block = cmd.exe /c " `"$batPath`" && set "
    
    # 3. Tangkap dan injeksikan variabel tersebut ke dalam sesi PowerShell aktif
    foreach ($line in $block) {
        if ($line -match "^([^=]+)=(.*)$") {
            $name = $Matches[1]
            $value = $Matches[2]
            
            # Abaikan beberapa variabel internal bawaan CMD agar tidak konflik
            if ($name -notin @('ALLUSERSPROFILE', 'APPDATA', 'COMPUTERNAME', 'ComSpec', 'HOMEDRIVE', 'HOMEPATH', 'LOCALAPPDATA', 'LOGONSERVER', 'NUMBER_OF_PROCESSORS', 'OS', 'PATHEXT', 'PROCESSOR_ARCHITECTURE', 'PROCESSOR_IDENTIFIER', 'PROCESSOR_LEVEL', 'PROCESSOR_REVISION', 'ProgramData', 'ProgramFiles', 'ProgramFiles(x86)', 'ProgramW6432', 'PSModulePath', 'PUBLIC', 'SystemDrive', 'SystemRoot', 'TEMP', 'TMP', 'USERDOMAIN', 'USERDOMAIN_ROAMING', 'USERNAME', 'USERPROFILE', 'windir')) {
                [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Process)
            }
            # Khusus untuk PATH, gabungkan agar tool bawaan Anda tidak hilang
            elseif ($name -eq 'PATH') {
                $env:PATH = $value
            }
        }
    }
    Write-Host "Lingkungan berhasil dimuat ke sesi PowerShell ini!" -ForegroundColor Green
}

# 4. Membuat Alias agar bisa dipanggil dengan cepat
Set-Alias -Name vscmd -Value Invoke-VsEnvCmd

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
