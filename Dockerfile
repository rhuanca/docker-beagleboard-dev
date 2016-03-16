FROM debian:stable

RUN apt-get update

# install curl
RUN apt-get install -y curl

# install wget
RUN apt-get install -y wget

# install git
RUN apt-get install -y git

# prepare for arm cross compiler installation
RUN echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
RUN dpkg --add-architecture armhf

# update sources
RUN apt-get update

# install arm cross compiler
RUN apt-get install -y crossbuild-essential-armhf

# install lzop
RUN apt-get install -y lzop

# install libssl-dev
RUN apt-get install -y libssl-dev

# install tftp server
#RUN apt-get install -y xinetd tftpd tftp
#COPY tftp /etc/xinetd.d/
#RUN mkdir /tftpboot
#RUN chmod -R 777 /tftpboot
#RUN chown -R nobody /tftpboot
#RUN service xinetd restart

# Install u-boot
RUN wget ftp://ftp.denx.de/pub/u-boot/u-boot-2016.01.tar.bz2
RUN tar -xjf u-boot-2016.01.tar.bz2
RUN cd u-boot-2016.01; make sandbox_defconfig tools-only; install tools/mkimage /usr/local/bin

# Get beagle board kernel
# RUN git clone git://github.com/beagleboard/linux.git

# setup sshd
RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
# Important Note: Change password here when necessary.
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 69
CMD ["/usr/sbin/sshd", "-D"]
