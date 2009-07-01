#!/usr/bin/env python -tt -Wall
'''
This script is based on the one found at http://vim.wikia.com/wiki/VimTip280
but has been generalised. It searches the current working directory for
t_*.py or test_*.py files and runs each of the unit-tests found within.

When run from within Vim as its 'makeprg' with the correct 'errorformat' set,
any failure will deliver your cursor to the first line that breaks the unit
tests.

It may also work from within Emacs.
'''

import unittest
import sys
import os
import re

def find_all_test_files():
        '''
        Returns a list of all unit-test files in the current working directory.
        These are identified as those matching t_*.py and those matching
        test_*.py.
        '''
        t_py_re = re.compile('^t(est)?_.*\.py$')
        is_test = lambda filename: t_py_re.match(filename)
        drop_dot_py = lambda filename: filename[:-3]
        return [drop_dot_py(module) for module in filter(is_test, os.listdir(os.curdir))]


def suite():
        '''
        Imports and returns a list of all TestCases in the list returned by
        find_all_test_files(). 
        '''
        sys.path.append(os.curdir)

        modules_to_test = find_all_test_files()
        print 'Testing', ', '.join(modules_to_test)

        alltests = unittest.TestSuite()
        for module in map(__import__, modules_to_test):
                alltests.addTest(unittest.findTestCases(module))

        return alltests


def setup_redirection():
        '''
        Redirect noisy unit tests to /dev/null. 
        '''
        stdout = sys.stdout
        logfile = open('/dev/null', 'w')
        sys.stdout = logfile


def teardown_redirection():
        sys.stdout = logfile
        logfile.close


def main():
        setup_redirection()

        unittest.main(defaultTest='suite')

        teardown_redirection()

if __name__ == '__main__':
        main()


