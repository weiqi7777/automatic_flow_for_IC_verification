
all: gen run clean
	echo "merge finish"
	
run: 
	./vmanager_run.tcsh
	
gen: cov_merge.list
	python merge_session.py
	
clean:
	rm autogen_merged.vsif vmanager_run.tcsh *.log *.key -f 