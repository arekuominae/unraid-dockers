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

#Enable SSH
RUN rm -rf /etc/service/sshd
 
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
 
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update Image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install build dependencies
RUN apt-get install -qy wget build-essential

# Install Open Java 8
RUN apt-get install openjdk-8-jre-headless -y && \ 
apt-get install locales -y && \ 
update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \ 
locale-gen en_US.UTF-8 && \ 
dpkg-reconfigure locales && \ 
apt-get clean all && \ 
rm -rf /var/lib/apt/lists/*

#Set environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

# Elasticsearch installation
# Start Elasticsearch by /elasticsearch/bin/elasticsearch. This will run on port 9200.
RUN wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/elasticsearch-2.1.1.tar.gz && \
	tar xf elasticsearch-2.1.1.tar.gz && \
	rm elasticsearch-2.1.1.tar.gz && \
	mv elasticsearch-2.1.1 elasticsearch 

ADD elasticsearch.yml /elasticsearch/config/

# Logstash installation
# Create a logstash.conf and start logstash by /logstash/bin/logstash agent -f logstash.conf
RUN wget https://download.elastic.co/logstash/logstash/logstash-2.1.1.tar.gz && \
	tar xf logstash-2.1.1.tar.gz && \
	rm logstash-2.1.1.tar.gz && \
	mv logstash-2.1.1 logstash

RUN mkdir -p /config/logstash
ADD logstash.conf /config/logstash/

# Kibana installation
RUN wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz && \
 	mkdir -p kibana && \
	tar -zx --strip-components=1 -C kibana -f kibana-4.3.1-linux-x64.tar.gz  && \
	rm kibana-4.3.1-linux-x64.tar.gz 

# Install curl utility just for testing
RUN apt-get update && \
	apt-get install -y curl

# Clean up
RUN apt-get purge -qq wget build-essential automake && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Initialize elk on boot
RUN mkdir -p /etc/my_init.d
ADD init_elk.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/init_elk.sh

#Start elk when container starts
RUN mkdir -p /etc/service/elk
ADD elk.sh /etc/service/elk/run
RUN chmod +x /etc/service/elk/run


VOLUME /config

# 5601=kibana, 9200=elasticsearch, 3333,3334=logstash tcp input, 514=logstash syslog utp input
EXPOSE 5601 9200 3333 3334 514
