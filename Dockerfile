FROM python:3.8.5-buster as base

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN set -x \
	&& sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get -y install --no-install-recommends git locales sudo libtool \
	libffi-dev libssl-dev autoconf automake bison swig libglib2.0-dev \
	portaudio19-dev mpg123 screen flac curl libicu-dev pkg-config \
	libjpeg-dev libfann-dev build-essential jq pulseaudio  \
	pulseaudio-utils festival festvox-ca-ona-hts lame vlc mplayer \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN echo 'ca_ES.UTF-8 UTF-8' > /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=ca_ES.UTF-8
ENV LANG ca_ES.UTF-8
ENV LANGUAGE ca_ES
ENV LC_ALL ca_ES.UTF-8

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./mycroft-core/mycroft /opt/mycroft/mycroft
COPY ./mycroft-core/bin /opt/mycroft/bin
COPY ./mycroft-core/scripts /opt/mycroft/scripts
RUN chmod +x /opt/mycroft/bin/*
RUN mkdir -p /var/log/mycroft
RUN mkdir -p /opt/mycroft/skills

COPY ./init.sh /opt/mycroft/init.sh
RUN chmod +x /opt/mycroft/init.sh

COPY ./mycroft.conf /root/.mycroft/mycroft.conf

COPY ./docker-requirements.txt /opt/mycroft/docker-requirements.txt
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r /opt/mycroft/docker-requirements.txt


WORKDIR /opt/mycroft
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai
ENV PATH="/opt/mycroft/bin:$PATH"

EXPOSE 8181