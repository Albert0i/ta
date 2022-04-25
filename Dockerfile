
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

SHELL ["powershell"]

RUN New-Item -Path 'C:\inetpub\wwwroot\TA' -Type Directory; \
	New-Item -Path 'C:\writable' -Type Directory; \
	Remove-Website -Name 'Default Web Site'; \
    New-Website -Name 'DefaultWebSite' -PhysicalPath 'C:\inetpub\wwwroot' -Port 80 -Force; \
	New-WebApplication -Name 'TA' -Site 'DefaultWebSite' -PhysicalPath 'C:\inetpub\wwwroot\TA' -ApplicationPool '.NET v4.5 Classic'; 

EXPOSE 80

RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' \
    -Name ServerPriorityTimeLimit -Value 0 -Type DWord

COPY TA /inetpub/wwwroot/TA
