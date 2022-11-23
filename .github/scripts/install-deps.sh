#!/bin/bash
set -e

# install yq
curl -L -o /bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_$(uname -m | sed -e's:'{aarch:arm,x86_:amd}':g')
chmod +x /bin/yq
