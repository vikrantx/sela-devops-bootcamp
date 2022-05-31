#command line arguments with default values
param(
    [Parameter()]
    [String]$TaskName = "BootCampTask",
    [int]$TriggerSeconds = 60,
    [int]$WaitSeconds = 120
)

$taskFolderName = "bootcamp";

#STEP 1 : Create Folder in Task Scheduler

#Steps to create folder in task manager

#1.Create the Schedule.Service object.
#2.Connect to the schedule service.
#3.Check if folder exists
#4.If not create new.
#4.If yes skip it with console message.

$scheduleObject = New-Object -ComObject schedule.service

$scheduleObject.connect()

$rootFolder = $scheduleObject.GetFolder("\")

$bootcampFolder = $rootFolder.GetFolder($taskFolder)

if(! $bootcampFolder ) {
    $bootcampFolder = $rootFolder.CreateFolder($taskFolder)
}


#STEP 2 : check if task exists, if yes then check status and enable it
#1.Get folder path where task should be present there
#2.Get task by providing task name and folder name

$bootCampTask = Get-ScheduledTask -TaskName $TaskName -TaskPath ($bootcampFolder.Path+"\") -ErrorAction SilentlyContinue -OutVariable task

#If task is in disabled state enabled it
if($bootCampTask.State -eq 'Disabled')
{
    $bootCampTask | Enable-ScheduledTask
}

#STEP 3 : Create task in Task Scheduler if not exists
#1.Get current user machine_name/user_name
$User= [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

#Existing task check
if(! $bootCampTask){ 
    #Action to perform : running powershell script 
    $actions = New-ScheduledTaskAction -Execute 'powershell' -Argument 'D:\DevOpsBootCamp\password-validator\open.ps1'

    #scheduler trigger 
    $trigger = New-ScheduledTaskTrigger -Daily -At '12:00 AM'
    
    #user principle to authentication
    $principal = New-ScheduledTaskPrincipal -UserId $User -RunLevel Highest

    #setting for task followed by -<paramenter>
    $settings = New-ScheduledTaskSettingsSet
    
    #create task
    $task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings
    
    #register new task in taskscheduler (create new task)
    $bootCampTask = Register-ScheduledTask $TaskName -InputObject $task -TaskPath ($bootcampFolder.Path+"\")
}

#loop untill trigger seconds less than wait seconds
while(($TriggerSeconds -lt $WaitSeconds) -or ($TriggerSeconds -eq $WaitSeconds)){

    #triggering task
    $bootCampTask | Start-ScheduledTask

    #pause execution for xx seconds
    sleep $TriggerSeconds

    #substract trigger seconds from wait seconds to break loop
    $WaitSeconds -= $TriggerSeconds
}

#disable task
Disable-ScheduledTask -TaskPath ($bootcampFolder.Path+"\") -TaskName $TaskName

#Get all task with path and show on console
function getAllTasks{
   
   $allTasks = Get-ScheduledTask -TaskPath "\*"
   
   forEach($task in $allTasks){
       Write-Host "$(($task.TaskPath+$task.TaskName))"
   }
}

getAllTasks

Exit 0
