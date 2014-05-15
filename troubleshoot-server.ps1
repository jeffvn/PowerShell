$exit = 1;
#cls
$hostname = read-host "Hostname"
write-host " "
write-host "Pinging $hostname..." -foreground "yellow"
test-connection $hostname
write-host " "
do {
write-host "Troubleshooting Menu" -foreground "yellow"
write-host "Current server: " -nonewline; write-host $hostname -foreground "red"
write-host "[1] Check disk space"
write-host "[2] Check uptime"
write-host "[3] Check system event log for recent erros"
write-host "[4] Launch Computer Management on remote system"
write-host "[C] Change server"
write-host "[X] Exit"
$choice = read-host "Please choose a menu item"
#Get-eventlog System | Where-Object {$_.entrytype -match "error" } | select-object message| sort message | more | Get-Unique -asstring | more
cls
# Check Diskspace...
if ($choice -eq 1) {
$disks = Get-WmiObject Win32_LogicalDisk -ComputerName $hostname | Select Name, Size, FreeSpace
$disks | foreach-object {
[int] $freespace / [int] 1028
}
}

# Uptime...
if ($choice -eq 2) {
$wmi = Get-WmiObject -Class Win32_OperatingSystem -Computername $hostname
$wmi.ConvertToDateTime($wmi.LocalDateTime) - $wmi.ConvertToDateTime($wmi.LastBootUpTime)
}

# Check event log for recent errors..
if ($choice -eq 3) {
Get-eventlog -logname system -computername $hostname -newest 200 | where-Object {$_.entrytype -match "error" } | select-object Timegenerated, source, message | format-table -wrap -auto | more
}

# Launch compmgmt.msc on remote system
if ($choice -eq 4) {
& compmgmt.msc /computer=mmifs1
}

#Change server
if ($choice -eq "C") { $hostname = read-host "Hostname"; echo "Hostname changed..." } 

#Exit
if ($choice -eq "X") { $exit = 2 }

if ($exit -eq 1) {read-host "Press Enter to continue..."}
} while ($exit -eq 1);