#!/bin/tcsh

setenv VMGR_PROJECT xxx
setenv SESSION_DIR  xxx/xxx/$VMGR_PROJECT
setenv COVERAGE_LOC "xxx/xxx/*/cov_work/scope/*"
set vsif_file = ./collect_coverage.vsif
echo "vmanager begin to run"
vmanager -server xxx -execcmd "launch -vsif $vsif_file"
echo "vmanager run finish"