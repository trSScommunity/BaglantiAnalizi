$Host.UI.RawUI.WindowTitle = "Gelişmiş Ağ Bilgileri - TR SS Community"
Clear-Host
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " TR SS Community: https://discord.gg/mdM5cDNudZ" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Windows Hotspot durumu:" -ForegroundColor Yellow
$hotspotAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match "Microsoft Wi-Fi Direct Virtual Adapter" }

if ($hotspotAdapter) {
    Write-Host "-> Durum: Bir Windows Hotspot aktif!" -ForegroundColor Red
} else {
    Write-Host "-> Durum: Aktif bir Hotspot bulunamadı." -ForegroundColor Green
}
Write-Host ""
Write-Host "Aktif Ağ Profilleri ve MAC Adresleri:" -ForegroundColor Yellow
$networkProfiles = Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq "Public" -or $_.NetworkCategory -eq "Private" }

if ($networkProfiles) {
    foreach ($profile in $networkProfiles) {
        $adapter = Get-NetAdapter -InterfaceIndex $profile.InterfaceIndex
        
        if ($adapter) {
            $macAddress = $adapter.MacAddress
            Write-Host "------------------------------------------------------"
            Write-Host "Ağ Adı      :" $profile.Name
            Write-Host "Arayüz Adı  :" $adapter.Name
            # MAC adresi varsa göster
            if ($macAddress) {
                Write-Host "Bulunan MAC Adresi:" $macAddress -ForegroundColor Green
                Write-Host "Bu site ile inceleyebilirsiniz: https://macvendors.com/"
            } else {
                Write-Host "Bu adaptör için MAC adresi bulunamadı." -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "-> Aktif bir ağ profili (Public/Private) bulunamadı." -ForegroundColor Red
}
Write-Host "------------------------------------------------------"
Write-Host ""
Write-Host "Kayıtlı Wi-Fi Profilleri:" -ForegroundColor Yellow
$savedProfiles = netsh wlan show profiles | Select-String -Pattern ": "

if ($savedProfiles) {
    foreach ($profileLine in $savedProfiles) {
        $profileName = ($profileLine -split ":")[1].Trim()
        Write-Host " -> $profileName"
    }
} else {
    Write-Host "-> Kayıtlı Wi-Fi profili bulunamadı." -ForegroundColor Red
}
Write-Host ""
Write-Host "Script tamamlandı. Kapatmak için bir tuşa basınız." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")