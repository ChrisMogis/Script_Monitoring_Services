#Function create Log folder
    Function CreateLogsFolder
{
    If(!(Test-Path C:\Logs))
    {
    New-Item -Force -Path "C:\Logs\" -ItemType Directory
		}
		else 
		{ 
    Write-Host "Le dossier "C:\Logs\" existe déjà !"
    }
}

#Create Log Folder
    CreateLogsFolder

#Declaration of script variables
    $Client = "ClientName"
    $Server = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
    $Date = Get-Date
    $ServiceName = "XboxGipSvc"
    $LogPath = "C:\Logs\$ServiceName.log"

#Get Gervice Status Information
    $Service = Get-Service | Where-Object { $_.Name -eq $serviceName }

#Restart service and wait 15s before checking if the service restarted
 If ($service.status -eq "Stopped")
 {
    Start-Service $serviceName

    Write-Output "$($Date) Service Status is $($service.status)" | Tee-Object -FilePath $LogPath -Append

    Start-Sleep -Seconds 15
 }

#Get Gervice Status Information
    $Service = Get-Service | Where-Object { $_.Name -eq $serviceName }

    Write-Output "$($Date) Service Status is $($service.status)" | Tee-Object -FilePath $LogPath -Append

#Send email if service still isn't running
 If ($service.status -eq "Stopped")
 {
    Write-Output "$($Date) Sending Alert email..." | Tee-Object -FilePath $LogPath -Append
    
    $smtpServer = "SMTP_Server"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)  
    $msg.From = "noreply@domainname.extension"
    $msg.To.Add("username@domainname.extension")
    #$msg.CC.Add("username@domainname.extension")
    $msg.Attachments.Add("$LogPath")
    $msg.subject = $Client + " $Server"  + " Service " + $serviceName + " is " + $service.status
    $msg.body = ([string]$date) + " Service " + $serviceName + " is " + $service.status 
    $smtp.send($msg)
}
    Write-Host "$($Date) Sending Alert email OK"
