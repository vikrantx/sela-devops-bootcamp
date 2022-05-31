$FILE_NAME
echo "Create new txt file and add content in it"

#create txt file and put "Hello Bootcamp!" text in it

#create new file <prefix>-<hhmmssfff>.txt and put text content in it
$FILE_NAME = $env:TEMP +"\"+"bonus-$(get-date -f hhmmssfff).txt"
echo $FILE_NAME
New-Item -Path ($FILE_NAME) -value "Hellow Bootcamp!"

#open file in notepad
notepad.exe $FILE_NAME