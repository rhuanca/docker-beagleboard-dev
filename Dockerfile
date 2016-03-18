FROM debian:stable

RUN apt-get update

# install curl
RUN apt-get install -y curl

# install wget
RUN apt-get install -y wget

# install git
RUN apt-get install -y git

# install vim
RUN apt-get install -y vim

# install lzop 
RUN apt-get install -y lzop

# Set the locale
COPY locale.gen /etc/locale.gen
RUN apt-get install -y locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
#RUN dpkg-reconfigure locales

# install tftp server
COPY policy-rc.d /usr/sbin/policy-rc.d
RUN apt-get install -y xinetd tftpd tftp
COPY tftp /etc/xinetd.d/
RUN mkdir /tftpboot
RUN chmod -R 777 /tftpboot
RUN chown -R nobody /tftpboot

# setup sshd
RUN apt-get install -y openssh-server

#RUN mkdir /var/run/sshd # Do not delete this line yet
# Important Note: Change password here when necessary.
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 69
CMD ["/usr/sbin/sshd", "-D"]

#CMD ["/usr/sbin/in.tftpd", "--foreground", "--user tftp", "--address", "0.0.0.0:69", "--secure", "/tftpboot"]



#code i want to make it work
#ENV LANGUAGE en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8
#RUN locale-gen en_US.UTF-8
#RUN dpkg-reconfigure locales
#http://daker.me/2014/10/how-to-fix-perl-warning-setting-locale-failed-in-raspbian.html
#https://people.debian.org/~schultmc/locales.html

