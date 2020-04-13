@ECHO OFF
C:\windows\system32\inetsrv\appcmd.exe add apppool /name:"MyWebsiteAppPool" /managedRuntimeVersion:""
C:\windows\system32\inetsrv\appcmd.exe add site /name:www_mywebsite_com /id:2 /physicalPath:C:\inetpub\wwwroot\mywebsite /bindings:http/*:8080:
C:\windows\system32\inetsrv\appcmd.exe set site /site.name:"www_mywebsite_com" /[path='/'].applicationPool:"MyWebsiteAppPool"
