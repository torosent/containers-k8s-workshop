#! /bin/sh

# install datadog helm chart

helm install --name dg-release --set datadog.apiKey=YOUR-KEY-HERE stable/datadog

# helm delete dg-release
