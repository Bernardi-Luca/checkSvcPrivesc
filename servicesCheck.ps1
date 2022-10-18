#user to check for
$userCheck=$env:username
#$userCheck="username"

#getting all the local services
Get-WmiObject win32_service | ForEach-Object{
	
	#getting the type of privilege on the service for the current user
	$SvcAccessLvl=.\accesschk64.exe /accepteula -uc $userCheck $_.name | findstr.exe $_.name
	$SvcAccessLvlSplit=$SvcAccessLvl.Split(" ")[0]

	#checking if the current user has write access to the service
	if($SvcAccessLvlSplit -like '*W*')
	{
		
        write-host "!!!!! MODIFIABLE SERVICE !!!!!"

        #service name output
		write-host "--- SERVICENAME ---";
		write-host $_.name;

		#permissions on the service binary
		#write-host "--- ASSOCIATED BINARY FILE PERMISSIONS ---";
		#icacls $_.pathname.Split(" ")[0];

		#displaying permissions of current user on the service
		write-host "--- CURRENT USER PERMISSION ON SERVICE ---";
		.\accesschk64.exe /accepteula -ucv $userCheck $_.name;

		#displaying the user starting the service
		write-host "--- DISPLAY ACCOUNT STARTING THE SERVICE ---";
		sc.exe qc $_.name | findstr.exe "SERVICE_START_NAME";


		echo "-------------------"
	}

	$SvcFileAccessLvl=.\accesschk64.exe /accepteula -uwqs $userCheck $_.pathname.Split(" ")[0]
	$SvcFileAccessLvlSplit=$SvcFileAccessLvl.Split(" ")[0]
	
	if($SvcAccessLvlSplit -like '*W*'){

        write-host "!!!!! MODIFIABLE SERVICE BINARY !!!!!"

		#service name output
		write-host "--- SERVICENAME ---";
		write-host $_.name;
		
		#permissions of the current user on the service binary
		.\accesschk64.exe /accepteula -uwqs $userCheck $_.pathname.Split(" ")[0]
		
		#displaying the user starting the service
		write-host "--- DISPLAY ACCOUNT STARTING THE SERVICE ---";
		sc.exe qc $_.name | findstr.exe "SERVICE_START_NAME";
	}
}
