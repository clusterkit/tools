#!/bin/bash

set -e

KUBE_VERSION="${1}"
HELM_VERSION=$(curl -sL https://api.github.com/repos/helm/helm/releases/latest | yq '.tag_name')

for arch in {arm64,amd64}; do
    arch_path="./binaries/${arch}"
    mkdir -p ${arch_path}

    # get kubectl
    curl -L https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${arch}/kubectl -o "${arch_path}/kubectl"

    # get helm bin
    curl -sL -o- https://get.helm.sh/helm-${HELM_VERSION}-linux-${arch}.tar.gz | tar -xzv -C "${arch_path}"
    mv "${arch_path}/linux-${arch}/helm" "${arch_path}/helm"
    rm -rf "${arch_path}/linux-${arch}"
done
