# Clusterkit Tools
This container contains cluster tools.

## Tagging
The tools container does not have a `latest` tag. This is intentional, with the expectation that you should use either `x.y` or `x.y.z` which corresponds to the desired kubectl version (ex: `1.24` or `1.24.8`).

# Tools Included
- `bash` - default shell
- `kubectl` - cluster management tool
- `helm` -  package management tool
- `kustomize` - build tool for cluster manifests
- `kubeconform` - ci tool for cluster manifest validation
- `yq` - scripting tool for reading yaml, json, properties, and xml data
- `jq` - scriptiing tool for reading json

# Usage Examples
Spawning a shell locally, using your kubeconfig can be done like this. Keep in mind that anything over "localhost" wont work out of the box though.
```
# with read-only kubeconfig
docker run --rm -it -v "${HOME}/.kube:/home/tooluser/.kube:ro" ghcr.io/clusterkit/tools:1.23

# with read-write kubeconfig
docker run --rm -it -v "${HOME}/.kube:/home/tooluser/.kube:ro" ghcr.io/clusterkit/tools:1.23
```

Spawning a shell directly in a cluster with a specific service account can be done as follows.
```
# inside the cluster with specific service account
kubectl run --rm -it --overrides='{ "spec": { "serviceAccount": "<service-account-here>" }  }' --image ghcr.io/clusterkit/tools:1.23 -- bash

# admin inside of kind cluster
kubectl run -n kube-system --rm -it --overrides='{ "spec": { "serviceAccount": "kindnet" }  }' --image ghcr.io/clusterkit/tools:1.23 -- bash
```

Commands can be called like this.
```
docker run --rm -it ghcr.io/clusterkit/tools:1.23 kubectl version --client
docker run --rm -it ghcr.io/clusterkit/tools:1.23 helm version --client
```

# Building Locally
The Dockerfile expects the `TARGETARCH` to be set and binaries to be pre-fetched.
```
bash get-binaries.sh 1.23.14
docker build -t tools:1.23 . --build-arg TARGETARCH=arm64
```
