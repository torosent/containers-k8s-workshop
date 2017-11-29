@REM You must have Helm installed on your Windows machine prior to running these commands.  You can download the TAR binaries at https://github.com/kubernetes/helm/releases
@REM Unpack the TAR file using WinZip, 7Zip or similar.  Place the files in a known location, such as C:\bin.
@REM Register the path the file location in your environment variables and reopen any CMD windows.

@REM install joomla with mariadb
helm install stable/joomla

@REM delete joomla release
helm delete <releasename>