
PRJ := $(shell cat job_names/prj.name)
RUN_USER := $(shell cat job_names/runner.name)

create_clone := 1
delete_clone := 1


create_params = $(PRJ) $(create_clone)  $(RUN_USER)
delete_params = $(delete_clone) 

usage:
	echo "creat regression_job: make create_regression create_clone=1"
	echo "creat satity_job: make create_satity create_clone=1 "

create_regression:
	./create.bash regression $(create_params)
create_satity:
	./create.bash sanity $(create_params)
	
del_regression:
	./delete.bash regression $(delete_params)
del_sanity:
	./delete.bash sanity $(delete_sanity)