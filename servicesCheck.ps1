#getting all the local services
Get-WmiObject win32_service | ForEach-Object {

	#getting the type of privilege on the service for the current user
	$SvcAccessLvl=.\accesschk64.exe /accepteula -uc $env:username $_.name | findstr.exe $_.name
	$SvcAccessLvlSplit=$SvcAccessLvl.Split(" ")[0]

	#checking if the current user has write access on the service
	if($SvcAccessLvlSplit -like '*W*')
	{
		#service name output
		write-host "--- SERVICENAME ---";
		write-host $_.name;

		#permissions on the associated binary
		write-host "--- ASSOCIATED BINARY FILE PERMISSIONS ---";
		icacls $_.pathname.Split(" ")[0];

		#displaying permissions of current user on the service
		write-host "--- CURRENT USER PERMISSION ON SERVICE ---";
		.\accesschk64.exe /accepteula -ucv $env:username $_.name;

		#displaying the user starting the service
		write-host "--- DISPLAY ACCOUNT STARTING THE SERVICE ---";
		sc.exe qc $_.name | findstr.exe "SERVICE_START_NAME";


		echo "============================================================================="
		echo "============================================================================="
		echo "============================================================================="
	}
}
