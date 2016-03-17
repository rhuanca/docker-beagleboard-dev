build:
docker build -t devbb . 

run:
docker run -d -p 9022:22 -p 9069:69/udp devbb

connect:
ssh root@localhost -p 9022 

