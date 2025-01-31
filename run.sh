hash=00008030-001C050E0EBB802E # set device backup hash
docker pull public.ecr.aws/lambda/python:latest # pull docker image
docker stop $(docker ps -q) # stop all running containers
docker rm $(docker ps -a -q) # remove all containers
docker build --build-arg DEVICE_HASH=$hash -t docker-image:test . # build container
docker run -d -p 9000:8080 docker-image:test # run new container in background
curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}' -w '' # check if success or fail
rm -rf ~/Library/SMS/ # remove decrypted backup in user's Library dir
docker cp $(docker ps -q):/var/task/Library/SMS/ ~/Library/SMS/ # copy decrypted backup to user's Library dir
rm -rf export*/ # remove export dir
imessage-exporter -f html -c full -p ~/Library/SMS/sms.db -o export/ # export messages to html