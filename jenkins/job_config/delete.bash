#!/bin/bash
[ $# -ne 3 ] && echo "usage delete.bash job_type prj_name is_delete_clone" && exit 1

job_type=$1
prj_name=$2
is_delete_clone=$3

workspace=/jenkins/workspace

clone_job=${prj_name}_${job_type}_clone

clone_job_dir=$workspace/$clone_job

config_xml_dir=tmp_gen/${prj_name}/create_job_config_xml/${job_type}

# delete job_type
for job_name in `cat job_names/${prj_name}/${job_type}_job.name`
do
	job_name=${prj_name}_$job_name
	echo "delete $job_name"
	java -jar ~/jenkins-cli.jar -s -s http://192.168.0.77:7777  delete-job ${job_name}
	rm $config_xml_dir/${job_name}_config.xml -f
	rm $workspace/$job_name -rf 
done

# delete clone_job
if [ "$is_delete_clone" = "1" ];
then 
	echo "delete ${prj_name}_${job_type}_clone"
	java -jar ~/jenkins-cli.jar -s -s http://192.168.0.77:7777  delete-job ${clone_job}
	rm $config_xml_dir/${job_type}_clone_config.xml -f 
	rm $clone_job_dir -rf
fi
 
