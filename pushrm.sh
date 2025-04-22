#!/bin/bash
set -e

readonly file="$1"
readonly registry_mappings="$2"
readonly registries="quay.io docker.io"

# install docker-pushrm plugin
if [ ! -d "$HOME/.docker/cli-plugins" ]; then
    sudo mkdir -p "$HOME/.docker/cli-plugins"
fi
if [ ! -f $HOME/.docker/cli-plugins/docker-pushrm ]; then
    if [ "$(uname)" = "Darwin" ]; then
        sys="darwin"
    elif [ "$(uname)" = "Linux" ]; then
        sys="linux"
    else
        echo "Unsupported system:" $(uname)
        exit 1
    fi
    if [ "$(uname -m)" = "x86_64" ]; then
        curl -fSL -o $HOME/.docker/cli-plugins/docker-pushrm https://github.com/christian-korneck/docker-pushrm/releases/download/v1.9.0/docker-pushrm_${sys}_amd64
    elif [ "$(uname -m)" == "aarch64" ]; then
        curl -fSL -o $HOME/.docker/cli-plugins/docker-pushrm https://github.com/christian-korneck/docker-pushrm/releases/download/v1.9.0/docker-pushrm_${sys}_arm64
    else
        echo "Unsupported architecture:" $(uname -m)
        exit 1
    fi
    sudo chmod +x $HOME/.docker/cli-plugins/docker-pushrm
fi 

# The format should be "registry1:namespace1/repo1,registry2:namespace2/repo2"
IFS=',' read -ra mappings <<< "$registry_mappings"
declare -A target_map
for mapping in "${mappings[@]}"; do
    IFS=':' read -r registry target <<< "$mapping"
    target_map[$registry]="$target"
done

# push readme to all specified registries
for registry in ${registries}; do
    if [[ -v target_map[$registry] ]]; then
        target="${target_map[$registry]}"
        docker login ${registry}
        docker pushrm -f ${file} ${registry}/${target}
        echo "Succeed to push README to" ${registry}/${target}
    else
        echo "No target specified for registry ${registry}, skipping"
    fi
done