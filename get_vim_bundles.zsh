#!/usr/bin/env zsh

username=${1}

if [[ -z ${username} ]]; then
    echo "Usage:"
    echo "${0} username"
    exit
fi

pushd ${HOME}/.vim/bundle
for repo in $(get_vim_bundles.awk =(w3m -dump https://github.com/${username}/following)); do
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
