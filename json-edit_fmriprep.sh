#!/bin/s


#code to edit phasediff map jSON file to accomade for fmriprep to run

#Author- Arush arun

# v1.0 20-08-2021

# output- edits the phasedifference map in fmap to includ 'IntendedFor:'

# enter the path where the BIDS folder arrives 
path='/home/aarun/cw84/arush/braincann/fmriprep/data'

func_path='/home/aarun/cw84/arush/braincann/fmriprep/data'

for n in ${func_path}/*/*/fmap/*phasediff.json ; do

	sid="$basename ${n}"
        fname="${sid##*/}"
	echo "Processing subject- ${fname}"

# extract the subjectID
	sub_cutstring=${fname::-21}

#extract the sessID
	sess_cutstring=${fname::-15}
	sess_cutstring=$(echo ${sess_cutstring[@]:8})

	new_path="${func_path}/${sub_cutstring}/${sess_cutstring}/func"

#        echo "${new_path}"
#	echo "${sess_cutstring}"

	lineout=26
	array=()
	array=(`find ${new_path}/*bold.nii.gz -type f`)
	var=$( IFS=$'\n'; printf "\"${array[*]}"\" )
	filenames=$(echo $var | sed 's/ /", "/g')
	textin=$(echo -e '\t' '"IntendedFor": ['$filenames'],')
	sed -i "${lineout}i $textin " ${sid}


done


