@echo off
SET dgapikey=<YOUR-KEY-HERE>
SET hname=dg-release 
@echo on

@REM Install datadog helm chart
helm install --name %hname% --set datadog.apiKey=%dgapikey% stable/datadog

@REM Delete datadog helm chart
helm delete %hname%