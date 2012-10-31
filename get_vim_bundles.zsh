#!/usr/bin/env zsh

this_dir=${0:h}
username=${1}

if [[ -z ${username} ]]; then
    echo "Usage:"
    echo "${0} username"
    exit
fi

bundle="${HOME}/.vim/bundle"

if [[ ! -d ${bundle} ]]; then
    mkdir -p ${bundle} || exit
fi

pushd ${HOME}/.vim/bundle
for repo in $(awk -f ${this_dir}/get_vim_bundles.awk =(w3m -dump https://github.com/${username}/following)); do
    dir=${repo:t:r}
    echo "${dir}..."
    if [[ -d ${dir} ]]; then
        pushd ${dir}
        git pull --rebase
        popd
    else
        git clone ${repo}
    fi
done
popd
