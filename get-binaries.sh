#!/bin/bash
set -ex


KUBE_VERSION="${1}"

HELM_VERSION=$(yq ".helm.version" settings.yaml)
KUSTOMIZE_VERSION=$(yq ".kustomize.version" settings.yaml)
KUBECONFORM_VERSION=$(yq ".kubeconform.version" settings.yaml)

for arch in {arm64,amd64}; do
    arch_path="./binaries/${arch}"
    arch_download_path="./binaries/downloads/${arch}"
    mkdir -p "${arch_path}" "${arch_download_path}"

    # get kubectl binary
    curl -L https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${arch}/kubectl -o "${arch_path}/kubectl"

    # get helm binary
    curl -sL -o- https://get.helm.sh/helm-${HELM_VERSION}-linux-${arch}.tar.gz | tar -xzv -C "${arch_download_path}"
    mv "${arch_download_path}/linux-${arch}/helm" "${arch_path}/helm"

    # get kustomize binary
    curl -sL -o- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${arch}.tar.gz" | tar -xzv -C "${arch_download_path}"
    mv "${arch_download_path}/kustomize" "${arch_path}/kustomize"

    # get kubeconform binary
    curl -sL -o- "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-${arch}.tar.gz" | tar -xzv -C "${arch_download_path}"
    mv "${arch_download_path}/kubeconform" "${arch_path}/kubeconform"

    # remove the download directory
    rm -rf "${arch_download_path}"
done
