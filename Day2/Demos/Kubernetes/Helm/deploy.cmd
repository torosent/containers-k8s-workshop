@echo off
SET hname=dg-release 
@echo on

@REM Install joomla with mariadb
helm install --name %hname% stable/joomla

@REM Delete joomla release
helm delete %hname%
