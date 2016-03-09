build:
docker build -t devbbb . 

run:
docker run -d -p 9022:22 devbbb

connect:
ssh root@localhost -p 9022

