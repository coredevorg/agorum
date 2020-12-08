#!/usr/bin/env python3
import sys
fname = sys.argv[1]
file = open(fname, encoding='unicode-escape')
content = file.read()
file.close()
_stdout = sys.stdout
file = open(fname, 'w')
sys.stdout = file
print(content)
sys.stdout = _stdout
print(fname)
