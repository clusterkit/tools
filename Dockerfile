FROM alpine:3

ARG TARGETARCH

COPY ./binaries/${TARGETARCH}/kubectl /bin/kubectl
COPY ./binaries/${TARGETARCH}/helm /bin/helm

RUN apk add --update ca-certificates yq jq bash \
    && apk add -t deps \
    && apk add --update curl \
    && apk del --purge deps \
    && rm /var/cache/apk/* \
    && chmod +x /bin/kubectl /bin/helm
