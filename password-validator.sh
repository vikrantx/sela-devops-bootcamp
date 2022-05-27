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
# password-validator.sh -h
# password-validator.sh "<input-password>"
# password-validator.sh -f "<input-file-path>"

INPUT_PASSWORD=$1
PASSWORD_LENGHT=10
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
errorArr=()

if [ $# -eq 0 ]
then
	echo "Missing options!"
	echo "(run $0 -h for help)"
	echo ""
	exit 0
fi

while getopts ":hf:" OPTION; do
	case $OPTION in

		f)
			FILE_PATH=$OPTARG
			;;
		h)
			echo "Usage:"
			echo "password-validator \"<input-password>\""
			echo "password-validator.sh -h "
			echo "password-validator.sh -f "
			echo ""
			echo "   -f  <password-file>   to validate password from specified file"
			echo "   <input-password>	to validate password"
			echo "   -h     help (this output)"
			exit 1
			;;
	esac
done

printMessage() {
	#print error messages from array
	for i in "${errorArr[@]}"; do
		printf ${red}'%s\n' "$i"
	done
	
	#reset array
	errorArr=()
}

validatePassword(){
	#check if password file provided, if yes read file content into variable
	if [ ! -z "$FILE_PATH" ]
	then
		INPUT_PASSWORD=$(<$FILE_PATH)
	fi
	
	if (( ${#INPUT_PASSWORD} < $PASSWORD_LENGHT )); then
		errorArr+=("Should be $PASSWORD_LENGHT character long!")
	fi
	if [[ $INPUT_PASSWORD != *[[:lower:]]* ]]; then
		errorArr+=("Should contain atleast one lower character")
	fi 
	if [[ $INPUT_PASSWORD != *[[:upper:]]* ]]; then
		errorArr+=("Should contain atleast one upper character")
	fi
	if [[ $INPUT_PASSWORD != *[[:digit:]]* ]]; then
		errorArr+=("Should contain atleast one digit")
	fi
	
	if (( ${#errorArr[@]} > 0 )); then
		printMessage
		exit 1
	else
		echo ${green}"valid password" ${reset}
		exit 0
	fi
}

validatePassword