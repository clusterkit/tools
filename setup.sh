#!/bin/sh
set -xe

# used for fatal error messaging
function fatal()
{
   echo "error: $1" >&2
   exit 1
}

# must be defined during build
[ -z "${KUBE_VERSION}" ] && fatal "value for KUBE_VERSION must be set"
[ -z "${TARGETARCH}" ] && fatal "value for TARGETARCH must be set"

# remove leading v from KUBE_VERSION
KUBE_VERSION="${KUBE_VERSION#[[:alpha:]]}"

#--------------------------------------
# Required OS Packages
#--------------------------------------
apk add --update ca-certificates yq jq bash git
apk add -t deps
apk add --update curl
apk del --purge deps
rm /var/cache/apk/*

#--------------------------------------
# Get bin versions from the settings
#--------------------------------------
HELM_VERSION=$(yq '.helm.version | match("[0-9\.]+") | .string' /settings.yaml)
KUSTOMIZE_VERSION=$(yq '.kustomize.version | match("[0-9\.]+") | .string' /settings.yaml)
KUBECONFORM_VERSION=$(yq '.kubeconform.version | match("[0-9\.]+") | .string' /settings.yaml)

# get kubectl binary
curl -L https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/${TARGETARCH}/kubectl -o "/bin/kubectl"
chmod +x /bin/kubectl

# get helm binary
curl -sL -o- https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz | tar -xzv --strip-components=1 -C "/bin/" "linux-${TARGETARCH}/helm"
chmod +x /bin/helm

# get kustomize binary
curl -sL -o- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" | tar -xzv -C "/bin/" "kustomize"
chmod +x /bin/kustomize

# get kubeconform binary
curl -sL -o- "https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-${TARGETARCH}.tar.gz" | tar -xzv -C "/bin/" "kubeconform"
chmod +x /bin/kubeconform


#--------------------------------------
# Ensure binaries are actually executable
#--------------------------------------
echo testing installed binaries

# this is necessary because someone thought it was a good idea to remove flags
# for a command that should have been client-only to begin with
kubectl version --client || kubectl version --short || kubectl version

helm version
kustomize version
kubeconform -v

