@REM tag image
docker tag myfirstapp torosent/myfirstapp:1.0.0

@REM login to hub
docker login

@REM push to hub
docker push torosent/myfirstapp:1.0.0
docker push torosent/myfirstapp