#--------------------------------------------
# Lookup IP in Citrix and connect to via VNC
# 2014 Jeff VanNieulande
#--------------------------------------------
#Add Citrix snap-in
Asnp Citrix.*

echo " "
echo "This script will look up the IP for a user's Citrix session, and launch VNC."
$name = Read-host 'Username'
#Looking up the IP....
$ip = get-xasession -full -computer mmixencentral | select accountname, clientipv4 | Where-Object {$_.Accountname -like "milliken\"+"$name*"}
$ip
echo " "
echo "----------------------------------------------------------------"
echo " "
#Quick check if it's an array or not and handle accordingly
if ($ip.clientipv4 -is [array]) {
$connectip = $ip.clientipv4[0]
} else {
$connectip = $ip.clientipv4
}
#Really want to VNC?
$question = read-host 'VNC to' $connectip '[y/n]'
if ($question -eq "y") {
#This path may need to change depending on your VNC installation...
& "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" -connect $connectip
}
#Alternative IP if you'd like...
if ($question -eq "n") {
$newip = read-host 'IP to connect to'
& "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" -connect $newip
}