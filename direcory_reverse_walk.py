#!/usr/bin/env python
import sys

import re
from os.path import dirname, basename

def directory_reverse_walk(path, num=None, regex=None):
    """
    Walk backward up a directory path based on the path given.
  
    NOTE: Either num or regex must be supplied, and they do not work
          together. If they are both specified, num takes precedence.

    :param path: string, the path to walk backwards up.
    :param num: integer, if specified, walk backward this number of times.
    :param regex: string, if specidied, walk backwards until the basename
            matchees.
    :raises DirectoryReverseException: If the num is higher then can be rolled
            back or if the regex isn't matched.
    """
    def check_base_regex(base_name, base_regex):
        return re.compile(base_regex).match(base_name)

    if num:
        #NOTE: The dirname method will not error out once it gets to
        # the base directory ('/'). Instead it keeps returning the base.
        # So old path detects when it does.
        old_path = ""
        for i in range(num):
            old_path = path
            path = dirname(path)
            if old_path == path:
                raise DirectoryReverseException(
                    "%s cannot be rolled back %d times." % (
                        path, num))
        return path

    if regex:
        old_path = ""
        while path != old_path:
            old_path = path
            path = dirname(path)
            if check_base_regex(basename(path), regex):
                return path
        raise DirectoryReverseException("Regex %s not matched" % (regex))

class DirectoryReverseException(Exception):
    pass




if __name__ == '__main__':
  path='/tmp/1/objects-2/3/4/5'
  num=7
  regex="^objects"
  path = directory_reverse_walk(path, regex=regex)
  #path = directory_reverse_walk(path, num)
  print path
