FROM ubuntu:16.04

# Java 8
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt-get install -y --allow-unauthenticated oracle-java8-installer oracle-java8-set-default

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_OPTS "-Xmx1024m"

# Build Essential
RUN apt-get update && apt-get install -y build-essential rake git git-crypt wget curl subversion mercurial

# install additional libraries
RUN apt-get update --fix-missing && \
    apt-get install -y -q dpkg libnss3-1d psmisc x11vnc unzip curl xdg-utils && \
    wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# install chrome driver
ADD chromedriver.sh /srv/chromedriver.sh
RUN wget http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip -P /srv/ && \
    unzip /srv/chromedriver_linux64.zip -d /srv && \
    rm /srv/chromedriver_linux64.zip && \
    chmod 755 /srv/chromedriver.sh && \
    ln -s /srv/chromedriver.sh /sbin/chromedriver

# install the framebuffer and the vnc server
RUN apt-get update --fix-missing && \
    apt-get install -q -y && \
    apt-get install -y --force-yes xvfb x11vnc

# set the display
ENV DISPLAY :20

# VNC Password
RUN mkdir -p /root/.vnc &&  \
    x11vnc -viewpasswd hello -storepasswd 1234 /root/.vnc/passwd && \
    mkdir -p /.vnc && \
    x11vnc -viewpasswd hello -storepasswd 1234 /.vnc/passwd

# install chrome
RUN curl -sSL -o /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --force-all -i /tmp/google-chrome-stable_current_amd64.deb
RUN apt-get -f -y install

RUN apt-get install -y ffmpeg

EXPOSE 5900
