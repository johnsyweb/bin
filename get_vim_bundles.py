#!/usr/bin/env python

import json
import os
import subprocess
import sys
import urllib2


def get_starred_vim_repos(user):
    url = 'https://api.github.com/users/{0}/starred'.format(user)
    result = urllib2.urlopen(url)
    stream = json.load(result)
    return (repo for repo in stream if repo['language'] == 'VimL')


def get_username():
    try:
        return sys.argv[1]
    except IndexError:
        print 'Usage:'
        print '\t{0} username'.format(sys.argv[0])
        sys.exit(0)


def get_bundle_directory():
    return os.path.join(os.environ['HOME'], '.vim', 'bundle')


def ensure_exists(bundle):
    try:
        os.makedirs(bundle)
    except OSError:
        assert(os.path.isdir(bundle))


def update_bundles(repos, bundles):
    for repo in repos:
        name = repo['name']
        repo_dir = os.path.join(bundles, name)
        if os.path.isdir(repo_dir):
            git_pull(name, repo_dir)
        else:
            git_clone(name, repo_dir, repo)


def git_pull(name, repo_dir):
    print 'Pulling {0} into {1}...'.format(name, repo_dir)
    current_dir = os.getcwd()
    os.chdir(repo_dir)
    try:
        subprocess.check_call(['git', 'pull', '--rebase'])
    except subprocess.CalledProcessError, e:
        print e
    os.chdir(current_dir)


def git_clone(name, repo_dir, repo):

    def do_clone(url, repo_dir):
        try:
            subprocess.check_call(['git', 'clone', url, repo_dir])
        except subprocess.CalledProcessError:
            return False
        return True

    print 'Cloning {0} into {1}...'.format(name, repo_dir)
    for url in 'ssh_url', 'git_url', 'clone_url':
        if do_clone(repo[url], repo_dir):
            break


def main():
    username = get_username()
    repos = get_starred_vim_repos(username)
    bundle = get_bundle_directory()
    ensure_exists(bundle)
    update_bundles(repos, bundle)


if __name__ == '__main__':
    main()
