import os
import sys

def get_newest_session(session_dir):
	def compare(x,y)
		stat_x	= os.stat(session_dir + '/' + x)
		stat_y	= os.stat(session_dir + '/' + y)
		if stat_x.st_ctime > stat_y.st_ctime:
			return -1
		elif stat_x.st_ctime < stat_y.st_ctime:
			return 1
		else:
			return 0
	iterms = os.listdir(session_dir)
	iterms.sort(compare)
	return iterms[0]

vm_project = xxx(should be modified)

cov_list_file = "cov_merge.list"
vm_run_file = "vmanager_run.tcsh"

vm_run_template = """#!/bin/tcsh
setenv SESSION_DIR   xxx(this is the session dir, should be modified)

# modify the TARGET_SESSION, this is the target session
setenv TARGET_SESSION %s
setenv TARGET_SESSION_COVERAGE "$SESSION_DIR/$TARGET_SESSION/chain_0/run_1/cov_work/scope/*"

setenv SOURCE_SESSION_COVERAGE "%s"

setenv VMGR_PROJECT %s
setenv COVERAGE_LOC "$TARGET_SESSION_DIR $SOURCE_SESSION_COVERAGE"
set vsif_file = ./%s
echo "vmanager begin to run"
vmanager -server  xxx(vmanager server url)  -execcmdn "launch -vsif $vsif_file"
echo "vmanager run finish"
"""

vsif_file_name = "autogen_merged.vsif"
vsif_file_context = """session %s_merge {
	top_dir : $ENV(SESSION_DIR);
	drm : serial local;
	output_mode : log_only;
}

group %s_group {
	scan_script : "vm_scan.pl ius.flt uvm.flt";
	// run
	run_script :
	<text> irun -64bit   hello_vmanager.sv -sv -coverage B -covoverwrite
	</text>;
	
	test %s_merge {
		// merge all coverage
		post_run_script :
		<text>
			echo imc -execcmd "merge $ENV(COVERAGE_LOC) -out $DIR(run)/cov_work1 -overwrite -message 1";
			imc -execcmd "merge $ENV(COVERAGE_LOC) -out $DIR(run)/cov_work1 -overwrite -message 1";
			cp $DIR(run)/cov_work1/icc*.ucm $DIR(session)/model_dir/icc_*_*.ucm -f;
			cp $DIR(run)/cov_work1/icc*.ucd $DIR(run)/cov_work/scope/test/icc_*_*.ucd -f
			exit 0;
		</text>
	}
}
"""%(vm_project, vm_project, vm_project)

source_cov_list = []

# read the cov_merge.list file, to get target cov session, source cov sessions

with open(cov_list_file, 'r') as cov_file:
	# get the target cov session name
	target_cov = cov_file.readline().strip()
	
	# if target is latest, select the newest session 
	if target_cov[0:6] == "latest":
		session_dir  = "xxx/%s" %s(sat_name)
		target_cov = get_newest_session(session_dir)
		print "seek the newest session [%s] in dir: %s" % ( target_cov, session_dir)
		
	for line in cov_file:
		source_cov_list.append(line.strip())
		

source_cov = ""
for cov in source_cov_list:
	source_cov += "$SESSION_DIR/%s/chain_0/run_1/cov_work/scope/*" % cov
	
# generate vsif file
with open(vsif_file_name, "w") as vsif_file:
	vsif_file.write(vsif_file_context)


vm_run_context = vm_run_template % (vm_project, target_cov, source_cov, vsif_file_name)
# generage vmanager run file
with open(vm_run_file, "w") as vm_file:
	vm_file.write(vm_run_context)

os.system("chmod a+x %s" % vm_run_file)