FROM alpine:3

ARG TARGETARCH

# "v1.25.4"
ARG KUBE_VERSION
# "v3.10.2"
ARG HELM_VERSION

RUN apk add --update ca-certificates yq jq bash \
    && apk add -t deps \
    && apk add --update curl \
    && export ARCH="$(uname -m)" \
    && curl -L https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -sL -o- https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz | tar -xzv -C /usr/local/bin \
    && mv /usr/local/bin/linux-${ARCH}/helm /usr/local/bin/helm \
    && rm -rf /usr/local/bin/linux-${ARCH} \
    && apk del --purge deps \
    && rm /var/cache/apk/*
