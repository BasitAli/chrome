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
	fluxbox \
	socat

ADD https://dl.google.com/linux/linux_signing_key.pub \
	https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	/tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& apt install -y /tmp/google-chrome-stable_current_amd64.deb

RUN apt-get install -y --no-install-recommends xvfb
RUN apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& useradd -m chrome \
	&& usermod -s /bin/bash chrome \
	&& mkdir -p /home/chrome/.fluxbox \
	&& echo ' \n\
		session.screen0.toolbar.visible:        false\n\
		session.screen0.fullMaximization:       true\n\
		session.screen0.maxDisableResize:       true\n\
		session.screen0.maxDisableMove: true\n\
		session.screen0.defaultDeco:    NONE\n\
	' >> /home/chrome/.fluxbox/init \
	&& chown -R chrome:chrome /home/chrome/.fluxbox

VOLUME ["/home/chrome"]

EXPOSE 5900
EXPOSE 9222

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
