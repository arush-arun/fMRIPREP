#!/bin/s

#Preprpocessing of functional and strucurual data. Steps followed as mentioned in fmriprep.org
#Edits by Arush Arun, Australian Catholic University, 11-08-2021
# runs for docker container fmriprep/20.2.3
#note to edit JSON file for phase difference map. fMRIprep 20.2.3 doesn't recongnise phase difference unless it is explicittly mentioned in the JSON file.


while read p; do

#enter the BIDS format root directory.
#User inputs:
	bids_root_dir=/home/aarun/cw84/arush/braincann/fmriprep/data/
	subj=$p 
	nthreads=8 
	mem=64 #gb

	echo "########## Processing ${p} ###################"
#Convert virtual memory from gb to mb
	mem=`echo "${mem//[!0-9]/}"` #remove gb at end
	mem_mb=`echo $(((mem*1000)-5000))` #reduce some memory for buffer space during pre-processing

#export TEMPLATEFLOW_HOME=$HOME/.cache/templateflow
	export FS_LICENSE=/home/aarun/cw84/arush/braincann/fmriprep/data/derivatives/license.txt

#Run fmriprep
	fmriprep $bids_root_dir $bids_root_dir/derivatives \
		participant \
		--participant-label $subj \
		--skip-bids-validation \
		--md-only-boilerplate \
		--fs-license-file /home/aarun/cw84/arush/braincann/fmriprep/data/derivatives/license.txt \
		--fs-no-reconall \
		--output-spaces MNI152NLin2009cAsym:res-2 \
		--nthreads $nthreads \
		--stop-on-first-crash \
		--mem_mb $mem_mb
done </projects/cw84/arush/braincann/fmriprep/subjlist.txt

# subjlist is a text file containing all the subject file names. For eg. sub-001, sub-002...
