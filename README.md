
# Bootcamp task scheduler bonus assignment


## Features

- Create scheduled task in windows task scheduler
- Open notepad with text content specified in open.ps1 on every -TriggerSeconds until -WaitSeconds provided arguments
- Check scheduled task status and enable it before execution
- Print list of all scheduled task present with full path


## Usage/Examples

```shellscript
./Task-Generator.ps1 -TaskName "<Task Name>" -TriggerSeconds “<time in seconds>” -WaitSeconds "<time in seconds>”

eg. ./Task-Generator.ps1 -TaskName "VikrantTask" -TriggerSeconds “10” -WaitSeconds "30”
```


## Authors

- [@vikrantbarde](https://github.com/vikrantx/sela-devops-bootcamp)

