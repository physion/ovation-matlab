#!/bin/bash

export OVATION_ROOT=test
export OVADDUSER=test/ovadduser.jar

echo "Running tests with $MATLAB..."

export PATH=$MATLAB_ROOT/bin:$PATH

matlab -nodisplay -nodesktop -r "runtests test; exit"

if [[ -f TEST_FAILED ]]; then
    rm TEST_FAILED
    exit(1)
fi
exit(0)
