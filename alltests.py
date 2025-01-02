#!/usr/bin/env python
'''
This script is based on the one found at http://vim.wikia.com/wiki/VimTip280
but has been generalised. It searches the current working directory for t_*.py
or test_*.py files and runs each of the unit-tests found within.

When run from within Vim as its 'makeprg' with the correct 'errorformat' set,
any failure will deliver your cursor to the first line that breaks the unit
tests.

Place this file somewhere where it can be run, such as ${HOME}/bin/alltests.py

It may also work from within Emacs.
'''

import os
import re
import sys
import traceback
import unittest


def is_test(filename):
    t_py_re = re.compile('^t(est)?_.*\.py$')
    return t_py_re.match(filename)


def drop_dot_py(filename):
    return filename[:-3]


def find_all_test_files():
    '''
    Returns a list of all unit-test files in the current working directory.
    These are identified as those matching t_*.py and those matching test_*.py.
    '''
    return [drop_dot_py(module) for module in os.listdir(os.curdir) if
            is_test(module)]


def suite():
    '''
    Imports and returns a list of all TestCases in the list returned by
    find_all_test_files().
    '''
    sys.path.append(os.curdir)

    modules_to_test = find_all_test_files()
    print('Testing', ', '.join(modules_to_test))

    alltests = unittest.TestSuite()
    for module in map(__import__, modules_to_test):
        alltests.addTest(unittest.findTestCases(module))

    return alltests


class fake_std_out(object):
    def write(self, _):
        pass


def silence_stdout():
    sys.stdout = fake_std_out()


def format_exceptions_for_vim():
    '''
    Reverse the Exception/Traceback printout order so Vim's quickfix works
    properly.
    '''

    exceptionType, exceptionValue, exceptionTraceback = sys.exc_info()

    sys.stderr.write("Exception:\n")
    ex = traceback.format_exception_only(exceptionType, exceptionValue)
    for line in ex:
        sys.stderr.write(line)

    sys.stderr.write("\nTraceback (most recent call first):\n")
    tb = traceback.format_tb(exceptionTraceback)
    for line in reversed(tb):
        sys.stderr.write(line)


def main():
    silence_stdout()
    try:
        unittest.main(defaultTest='suite')
    except SystemExit:
        pass
    except:
        format_exceptions_for_vim()


if __name__ == '__main__':
    main()
