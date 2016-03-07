FROM phusion/baseimage:0.9.18
MAINTAINER codechimp-org

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Set the locale
RUN locale-gen en_US.UTF-8

# Configure user nobody to match unRAID's settings
RUN usermod -u 99 nobody && \
	usermod -g 100 nobody && \
	usermod -d /home nobody && \
	chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
 
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update Image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install build dependencies
RUN apt-get install -qy wget build-essential curl

#Install Java
ENV CA_CERTIFICATES_JAVA_VERSION 20140324 
RUN add-apt-repository -y ppa:openjdk-r/ppa 
RUN set -x  && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
      libfontconfig1 \
      openjdk-8-jre-headless \
      ca-certificates-java

# see CA_CERTIFICATES_JAVA_VERSION notes above # debug
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

#Set environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

RUN curl -o opensearchserver.deb -L http://sourceforge.net/projects/opensearchserve/files/Stable_release/1.5.10/opensearchserver-1.5.10-b893.deb/download

RUN dpkg -i opensearchserver.deb
RUN sed -e 's/OPENSEARCHSERVER_DATA=\/var\/lib\/opensearchserver\/data/OPENSEARCHSERVER_DATA=\/config\/opensearchserver\/data/' -i /etc/opensearchserver

RUN chown -R nobody:users /usr/share/opensearchserver && \
	chmod -R 0777 /usr/share/opensearchserver

# Initialize oss on boot
RUN mkdir -p /etc/my_init.d
ADD init_oss.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/init_oss.sh

#Start oss when container starts
RUN mkdir -p /etc/service/oss
ADD oss.sh /etc/service/oss/run
RUN chmod +x /etc/service/oss/run
RUN tail -F /var/log/opensearchserver/server.out

# Volumes
VOLUME ["/config"]
WORKDIR /config

# Exposed Ports 
EXPOSE 9090
