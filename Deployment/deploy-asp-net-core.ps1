$dotNetCoreHostingBundleUrl = "https://download.visualstudio.microsoft.com/download/pr/dd119832-dc46-4ccf-bc12-69e7bfa61b18/990843c6e0cbd97f9df68c94f6de6bb6/dotnet-hosting-3.1.2-win.exe"
$tempSpace = "C:\temp"
$webRoot = "C:\inetpub\wwwroot\mywebsite"
$siteRoot = '/'
$appCmd = "$Env:SystemRoot\system32\inetsrv\appcmd.exe"
$artifact = "https://github.com/lalitadithya/HelloWorldASPDotNetCore/releases/download/v1.0/v1.0.zip"
$siteName = "www_mywebsite_com"
$appPoolName = "MyWebsiteAppPool"
$siteId = 2
$sitePort = 8080

New-Item -ItemType Directory -Force -Path $tempSpace

Add-WindowsFeature Web-Server

if((Get-Command dotnet -ErrorAction SilentlyContinue).Name -eq $null) 
{
	Invoke-WebRequest -Uri $dotNetCoreHostingBundleUrl -OutFile "$($tempSpace)\dotnetcore.exe"
	Start-Process -FilePath "C:\temp\dotnetcore.exe" -ArgumentList "/quiet","/install" -Wait
	IISReset
}

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $appCmd
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.CreateNoWindow = $true
$pinfo.Arguments = "list site /name:`"$($siteName)`""
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()

if($p.ExitCode -eq 1) 
{
	New-Item -ItemType Directory -Force -Path $webRoot
	Start-Process -FilePath $appCmd -ArgumentList "add apppool /name:`"$($appPoolName)`" /managedRuntimeVersion:`"`"" -NoNewWindow -PassThru -Wait 
	Start-Process -FilePath $appCmd -ArgumentList "add site /name:$($siteName) /id:$($siteId) /physicalPath:$webRoot /bindings:http/*:$($sitePort):" -NoNewWindow -PassThru -Wait 
	Start-Process -FilePath $appCmd -ArgumentList "set site /site.name:`"$($siteName)`" /[path='$siteRoot'].applicationPool:`"$($appPoolName)`"" -NoNewWindow -PassThru -Wait 
	New-NetFirewallRule -DisplayName "Allow 8080 Inbound" -Direction Inbound -LocalPort $sitePort -Protocol TCP -Action Allow
}

iisreset.exe /stop

Remove-Item -Path "$($webRoot)\*" -Recurse

Invoke-WebRequest -Uri "$($artifact)" -OutFile "$($tempSpace)\artifact.zip"

Expand-Archive "$($tempSpace)\artifact.zip" -DestinationPath $webRoot

Remove-Item -Path "$($tempSpace)" -Recurse

iisreset.exe /start