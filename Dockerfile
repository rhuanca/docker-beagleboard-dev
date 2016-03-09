FROM debian:stable
RUN apt-get update

RUN apt-get install -y curl
RUN echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

RUN dpkg --add-architecture armhf
RUN apt-get update
RUN apt-get install -y crossbuild-essential-armhf


#RUN apt-get install -y binutils-arm-linux-gnueabi
#RUN apt-get install -y gcc-arm-linux-gnueabi
#RUN apt-get install -y openssh-server

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]
