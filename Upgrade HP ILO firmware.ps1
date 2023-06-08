# Upgrade HP ILO firmware 

$srv = Get-Content "\\fileserver\ILO\ilosrv.txt"
$username = "Administrator"
$password = read-host "Enter ILO password"

$ilo_3_pre = 1.28
$ilo_3_pre_fwr = "\\fileserver\HP\ilo\ilo3_128.bin"
$ilo_3_p = $ilo_3_pre - 0.01
$ilo_3_last = 1.89
$ilo_3_last_fwr = "\\fileserver\HP\ilo\ilo3_189.bin"
$ilo_4_last = 2.60
$ilo_4_last_fwr = "\\fileserver\HP\ilo\ilo4_260.bin"

$srvILO = Find-HPiLO $srv | Select IP, HOSTNAME, PN, FWRI | Sort PN, FWRI 
foreach ($sILO in $srvILO) {

    $sInfo = $sILO.IP + " - " + $sILO.HOSTNAME + " - " + $sILO.PN + " v " + $sILO.FWRI
    Write-Host "Check server $sInfo"

#ILO 3
    if (($sILO.PN -like "*iLO 3*") -and ($sILO.FWRI -lt $ilo_3_last)) {
        if ($sILO.FWRI -lt $ilo_3_pre) {

            Write-Host "Update process running. ILO 3 $ilo_3_pre..." -ForegroundColor Yellow
            $sILO | Update-HPiLOFirmware -Username $username -Password $password -DisableCertificateAuthentication -Location $ilo_3_pre_fwr
            Write-Host "Update process has been finished! Please, run the script again for ILO 3 1.89 update" -ForegroundColor Yellow

        } elseif (($sILO.FWRI -gt $ilo_3_p) -and ($sILO.FWRI -lt $ilo_3_last)) {
            
            Write-Host "Update process running. ILO 3 $ilo_3_last..." -ForegroundColor Yellow
            $sILO | Update-HPiLOFirmware -Username $username -Password $password -DisableCertificateAuthentication -Location $ilo_3_last_fwr
            Write-Host "Update process has been finished!" -ForegroundColor Yellow

        }
    }

#ILO 4
    if (($sILO.PN -like "*iLO 4*") -and ($sILO.FWRI -lt $ilo_4_last)) {

        
        Write-Host "Update process running. ILO 4 $ilo_4_last..." -ForegroundColor Yellow
        $sILO | Update-HPiLOFirmware -Username $username -Password $password -DisableCertificateAuthentication -Location $ilo_4_last_fwr
        Write-Host "Update process has been finished!" -ForegroundColor Yellow

    }

} #foreach

Find-HPiLO $srv | Select HOSTNAME, PN, FWRI | Sort PN, FWRI