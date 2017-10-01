FROM microsoft/dotnet:latest

WORKDIR /app
 
COPY /bin/Debug/netcoreapp2.0/publish/ .
ENTRYPOINT ["dotnet", "printingservice.dll"]