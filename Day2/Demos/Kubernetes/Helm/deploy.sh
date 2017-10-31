#! /bin/sh
hname=dg-release 

# install joomla with mariadb
helm install --name $hname stable/joomla

# delete joomla release
helm delete $hname