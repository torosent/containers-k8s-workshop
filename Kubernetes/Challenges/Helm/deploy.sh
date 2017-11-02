#! /bin/sh

# install joomla with mariadb
helm install stable/joomla

# delete joomla release
helm delete <releasename>