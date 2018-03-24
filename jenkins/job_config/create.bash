#!/bin/bash 
[ $# -lt 3 ] && echo "usage create.bash job_type prj_name is_clone_create run_user" && exit 1
echo "create job on jenkins"

all_test=""
job_type=$1
prj_name=$2

# clone job is whether create. 1: not create  1:create
is_clone_create=$3

# run user
if [ $# -eq 5 ];
then 
	run_user=$5
else
	run_user=jun.lu
fi

$job, clone job, manager job will add to JOB_VIEW
JOB_VIEW=$2/$1

job_name_file=job_names/${prj_name}/${1}_job.name
clone_job=${prj_name}_${job_type}_clone

workspace_location=/jenkins/workspace

# clone and manager job dir
clone_job_dir=$workspace_location/$clone_job


# create two directory to save the job xml
mkdir -p tmp_gen/${prj_name}/create_job_config.xml
mkdir -p tmp_gen/${prj_name}/create_view_config.xml
job_config_location=create_job_config_xml/${prj_name}/${job_type}
pipe_config_location=create_view_config_xml/${prj_name}

pipe_config_file=${pipe_config_location}${job_type}_pipe_view.xml
pipe_view_name=${job_type}_pipe

mkdir -p ${job_config_lcoation}
mkdir -p ${pipe_config_location}

# clone job
if [ "$is_clone_create" = "1" ];
then
	echo "create $clone_job job"
	clone_job_config_file=${job_config_location}/${job_type}_clone_config.xml
	cp config_xml/clone_job_config.xml ${clone_job_config_file} -r
	sed -i "s#prj_location#$clone_job_dir#" ${clone_job_config_file}
	sed -i "s#JENKINS_RUN_USER#$run_user#" ${clone_job_config_file}
	java -jar ~/jenkins-cli.jar -s http://192.168.0.77:7777 create-jon $clone_job > ${clone_job_config_file}
	java -jar ~/jenkins-cli.jar -s http://192.168.0.77:7777 add-job-to-view $JOB_VIEW $clone_job
fi

# job list
for job in `cat $job_name_file`
do
	#for each job, wiil add job_type to prefix
	job=${prj_name}_$job
	echo "create $job job"
	job_config_file=${job_config_location}/${job}_config.xml
	cp config_xml/job_config.xml ${job_config_file}
	sed -i "s#<comman>#<command>\$JENKINS_HOME/\${JOB_NAME}.tcsh#" ${job_config_file}
	sed -i "s#JENKINS_RUN_USER#$run_user#" ${job_config_file}
	java -jar ~/jenkins-cli.jar -s http://192.168.0.77:7777 create-job ${job} < ${job_config_file}
	java -jar ~/jenkins-cli.jar -s http://192.168.0.77:7777 add-job-to-view $JOB_VIEW ${job}
done
