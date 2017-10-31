#! /bin/sh
dgapikey=<YOUR-KEY-HERE>
hname=dg-release 

# Install datadog helm chart
helm install --name $hname --set datadog.apiKey=$dgapikey stable/datadog

# REM Delete datadog helm chart
# helm delete dg-release
