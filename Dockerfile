FROM ubuntu:18.04

LABEL maintainer="Tomohisa Kusano <siomiz@gmail.com>"

ENV VNC_SCREEN_SIZE 1024x768

COPY copyables /

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	gnupg2 \
	fonts-noto-cjk \
	supervisor \
	x11vnc \
	socat

ADD https://dl.google.com/linux/linux_signing_key.pub \
	https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	/tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& apt install -y /tmp/google-chrome-stable_current_amd64.deb

RUN apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& usermod -s /bin/bash

VOLUME ["/home/chrome"]

EXPOSE 5900
EXPOSE 9222

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
