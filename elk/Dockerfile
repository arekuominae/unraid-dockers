FROM phusion/baseimage:0.9.16
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

#Disable the SSH server
#RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update Image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
	
# Install build dependencies
RUN apt-get install -qy wget build-essential

# Install Oracle Java 8, accept license command is required for non interactive mode
RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
	DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer

# Elasticsearch installation
# Start Elasticsearch by /elasticsearch/bin/elasticsearch. This will run on port 9200.
RUN wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/elasticsearch-2.1.1.tar.gz && \
	tar xf elasticsearch-2.1.1.tar.gz && \
	rm elasticsearch-2.1.1.tar.gz && \
	mv elasticsearch-2.1.1 elasticsearch 

ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml	

# Logstash installation
# Create a logstash.conf and start logstash by /logstash/bin/logstash agent -f logstash.conf
RUN wget https://download.elastic.co/logstash/logstash/logstash-2.1.1.tar.gz && \
	tar xf logstash-2.1.1.tar.gz && \
	rm logstash-2.1.1.tar.gz && \
	mv logstash-2.1.1 logstash

ADD config/logstash/logstash.conf /config/logstash/logstash.conf

# Kibana installation
RUN wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz && \
	tar xf kibana-4.3.1-linux-x64.tar.gz kibana && \
	rm kibana-4.3.1-linux-x64.tar.gz 

# Install curl utility just for testing
RUN apt-get update && \
	apt-get install -y curl

# Clean up
RUN apt-get purge -qq wget build-essential automake && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Pre-Initialize elk
ADD pre_init_elk.sh /home/pre_init_elk.sh
RUN chmod +x /home/pre_init_elk.sh
RUN /home/pre_init_elk.sh

# Initialize elk on boot
RUN mkdir -p /etc/my_init.d
ADD init_tor.sh /etc/my_init.d/init_elk.sh
RUN chmod +x /etc/my_init.d/init_elk.sh

#Start elk when container starts
RUN mkdir -p /etc/service/elk
ADD elk.sh /etc/service/elk/run
RUN chmod +x /etc/service/elk/run


VOLUME /config

# 80=nginx, 9200=elasticsearch, 3333,3334=logstash tcp input, 5601=kibana
EXPOSE 80 3333 3334 9200 49021, 5601
