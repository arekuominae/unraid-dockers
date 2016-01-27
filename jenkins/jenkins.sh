#!/bin/bash
umask 000

# set env variables for jenkins
export JAVA=/usr/bin/java
export JAVA_ARGS=-Xmx512m
export JAVA_OPTS=
export JENKINS_USER=nobody
export JENKINS_HOME=/config
export JENKINS_WAR=/usr/share/java/jenkins/jenkins.war
export JENKINS_WEBROOT=--webroot=/var/cache/jenkins
export JENKINS_PORT=--httpPort=8090
export JENKINS_AJPPORT=--ajp13Port=-1
export JENKINS_OPTS=
export JENKINS_COMMAND_LINE="$JAVA $JAVA_ARGS $JAVA_OPTS -jar $JENKINS_WAR $JENKINS_WEBROOT $JENKINS_PORT $JENKINS_AJPPORT $JENKINS_OPTS"

export ANDROID_HOME=/config/android-sdk-linux
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# run jenkins
/bin/sh -c 'eval $JENKINS_COMMAND_LINE'
