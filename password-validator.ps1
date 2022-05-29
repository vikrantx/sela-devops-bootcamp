#
# Author - vikrantbarde@gmail.com
#
# Script to validate password base on following conditions
#
# 1.Length – minimum of 10 characters.
# 2.Contain both alphabet and number.
# 3.Include both the small and capital case letters.
# 4.Color the output green if it passed the validation and red if it didn’t.
# 5.Return exit code 0 if it passed the validation and exit code 1 if it didn’t.
# 6.If a validation failed provide a message explaining why
#
# Usage
# password-validator.sh "<input-password>"
# password-validator.sh -f "<input-file-path>"
param(
    [Parameter()]
    [String]$password,
    [String]$f
	)

$errorMessges = @()
$passwordLength = 10

#printing errors from array on host console
function printErrors($errorMessges){
	foreach( $errorMessage in $errorMessges ){
		Write-Host $errorMessage  -ForegroundColor red
	}
}

#Function to validate password 
function validatePassword($password){
	if($password.length -lt $passwordLength){
		$errorMessges += ,@('Passwold length is less than '+ $passwordLength +' characters!')
	}
	
	if(! ($password -cmatch "[a-z]")){
		$errorMessges += ,@('Passwold does not have lowercase letters!')
	}
	
	if(! ($password -cmatch "[A-Z]")){
		$errorMessges += ,@('Passwold does not have uppercase letters!')
	}
	
	if(! ($password -match '\d')){
		$errorMessges += ,@('Passwold does not have digits!')
	}

	if($errorMessges.count -gt 0){
		printErrors($errorMessges);
		exit 1
	}else{
		Write-Host "Valid password"  -ForegroundColor green
		exit 0
	}
}

#check if file path and input password is empty
if( ($f.length -eq 0) -and ($password.length -eq 0)){
	Write-Host "Password is empty." -ForegroundColor red
		Write-Host "Usage : 
		password-validator <input-password>
		password-validator.sh -h
		password-validator.sh -f 
		
		-f  <password-file>   to validate password from specified file
		<input-password>	to validate password
		-h     help (this output)"
	exit 1
}elseif($password){
	validatePassword($password)
}elseif($f){
    Write-Host "Reading from file : $f"
	$password = Get-Content $f
	Write-Host "File contents : $password"
	validatePassword($password)
}else{
	Write-Host "Invalid input" -ForegroundColor red
	exit 1
}

