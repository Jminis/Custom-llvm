#!/usr/bin/python2
import sys, os

TESTCASE = ".cur_input"

unit = ''
with open(TESTCASE, 'rb') as f:
    unit = f.read()

# read-in coverages
COVERAGE_DIR = "coverages"
res = [] 
files = os.listdir( COVERAGE_DIR )
for filename in files:
    with open( COVERAGE_DIR + '/' + filename, 'rb') as f:
        data = f.read()
        raw_input('testcase: {0}, coverage:{1}'.format(unit.encode('hex'), repr(data)))


