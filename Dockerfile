FROM alpine:3

ARG KUBE_VERSION
ARG TARGETARCH

COPY settings.yaml /settings.yaml
COPY setup.sh /usr/src/setup.sh
RUN /bin/sh /usr/src/setup.sh

# lock it down a bit
RUN adduser --disabled-password --gecos "" tooluser
USER tooluser
WORKDIR /home/tooluser

# easy to override the command when using cmd instead of entrypoint
CMD [ "/bin/bash" ]
