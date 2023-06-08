# Get HP ILO servers
# You can use one of this variants

# 1
$srvILO2 = Find-HPiLO 10.1.1.1-255
$srvILO2 | Export-Csv D:\ILO\srvilo2.csv -Encoding UTF8


# 2
$username = "Administrator"
$password = read-host "Enter ILO password"
Get-HPiLOHealthSummary -Server srv2-ilo -Username $username -Password $password -DisableCertificateAuthentication

IP                 : *******
HOSTNAME           : srv2-ilo
STATUS_TYPE        : OK
STATUS_MESSAGE     : OK
DRIVE_STATUS       : OK
FANS               : {@{STATUS=OK}, @{REDUNDANCY=Redundant}}
POWER_SUPPLIES     : {@{STATUS=OK}, @{REDUNDANCY=Redundant}}
TEMPERATURE_STATUS : OK
VRM_STATUS         : OK


# 3
$username = "Administrator"
$password = read-host "Enter ILO password"
$str = "FQDN;IP;HOSTNAME;ILO_FIRMWARE_VERSION;FIRMWARE_DATE;SPN;PN;SerialNumber;UUID;DRIVES_PRODUCT_ID;MEMORY_STATUS;STORAGE_STATUS;FANS_STATUS;POWER_SUPPLIES_STATUS;PROCESSOR_STATUS;BIOS_HARDWARE_STATUS;NETWORK_STATUS;TEMPERATURE_STATUS
"
$srvILO = Import-Csv "D:\ILO\srvilo.csv"
foreach ($sILO in $srvILO) {

    $srv_IP = $sILO.IP
    $srv_HOSTNAME = $sILO.HOSTNAME
    $srv_SPN = $sILO.SPN
    $srv_FWRI = $sILO.FWRI
    $srv_PN = $sILO.PN
    $srv_SerialNumber = $sILO.SerialNumber
    $srv_UUID = $sILO.UUID

    $drive_pid = ""
    $srv_fqdn = ""
    $ilo_firm = ""
    $ilo_firm_v = ""
    $ilo_firm_date = ""
    $srv_status = ""
    $srvInfo = ""

    $srvInfo = Get-HPiLOServerInfo -Server $sILO -Username $username -Password $password -DisableCertificateAuthentication

    $drive_pid = $srvInfo.DRIVE.BACKPLANE.PRODUCT_ID
    $drive_pid = $drive_pid.PRODUCT_ID

    $srv_status = $srvInfo.HEALTH_STATUS

    $srv_health_memory = $srv_status.MEMORY_STATUS
    $srv_storage_status = $srv_status.STORAGE_STATUS
    $srv_fans_status = $srv_status.FANS.STATUS
    $srv_power_supplies_status = $srv_status.POWER_SUPPLIES.STATUS
    $srv_processor_status = $srv_status.PROCESSOR_STATUS
    $srv_bios_hardware_status = $srv_status.BIOS_HARDWARE_STATUS
    $srv_network_status = $srv_status.NETWORK_STATUS
    $srv_temp_status = $srv_status.TEMPERATURE_STATUS

    $srv_fqdn = (Get-HPiLOServerFQDN -Server $sILO -Username $username -Password $password -DisableCertificateAuthentication).SERVER_FQDN

    $ilo_firm = Get-HPiLOFirmwareVersion -Server $sILO -Username $username -Password $password -DisableCertificateAuthentication | select FIRMWARE_VERSION, FIRMWARE_DATE
    #$ilo_firm_v = $ilo_firm.FIRMWARE_VERSION
    $ilo_firm_date = $ilo_firm.FIRMWARE_DATE

    $str += "$srv_fqdn;$srv_IP;$srv_HOSTNAME;$srv_FWRI;$ilo_firm_date;$srv_SPN;$srv_PN;$srv_SerialNumber;$srv_UUID;$drive_pid;$srv_health_memory;$srv_storage_status;$srv_fans_status;$srv_power_supplies_status;$srv_processor_status;$srv_bios_hardware_status;$srv_network_status;$srv_temp_status
"

}
$str
$str > "d:\ilo\1.csv"
