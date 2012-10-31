#!/usr/bin/env python

import json
import os
import subprocess
import sys
import urllib2


def get_repos(user):
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
    current_dir = os.getcwd()
    for repo in repos:
        name = repo['name']
        repo_dir = os.path.join(bundles, name)
        if os.path.isdir(repo_dir):
            print 'Pulling {0} into {1}...'.format(name, bundles)
            os.chdir(repo_dir)
            subprocess.check_output(['git', 'pull', '--rebase'])
            os.chdir(current_dir)
        else:
            print 'Cloning {0} into {1}...'.format(name, bundles)
            subprocess.check_output(['git', 'clone', repo['ssh_url'],
                                     repo_dir])


def main():
    username = get_username()
    repos = get_repos(username)
    bundle = get_bundle_directory()
    ensure_exists(bundle)
    update_bundles(repos, bundle)


if __name__ == '__main__':
    main()
