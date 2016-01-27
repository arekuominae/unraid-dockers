FROM phusion/baseimage:latest
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
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
 
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update Image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install build dependencies
RUN apt-get install -qy wget build-essential

#Install Java
ENV CA_CERTIFICATES_JAVA_VERSION 20140324 
RUN add-apt-repository -y ppa:openjdk-r/ppa 
RUN set -x  && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
      libfontconfig1 \
      openjdk-7-jre-headless \
      ca-certificates-java

# see CA_CERTIFICATES_JAVA_VERSION notes above # debug
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

#Set environment variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre

#Install Jenkins
RUN apt-get install -y jenkins
RUN chown -R nobody:users /usr/share/java/jenkins/ /etc/conf.d/jenkins /var/cache/jenkins/
RUN chmod -R 775 /usr/share/java/jenkins/ /etc/conf.d/jenkins /var/cache/jenkins/

# Clean up
RUN apt-get purge -qq wget build-essential automake && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Initialize jenkins on boot
RUN mkdir -p /etc/my_init.d
ADD init_jenkins.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/init_jenkins.sh

#Start jenkins when container starts
RUN mkdir -p /etc/service/jenkins
ADD jenkins.sh /etc/service/jenkins/run
RUN chmod +x /etc/service/jenkins/run

# Volumes
VOLUME ["/config"]

# Exposed Ports 
# 8090 Jenkins
EXPOSE 8090