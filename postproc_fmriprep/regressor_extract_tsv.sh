/#!/bin/bash
# this code will look for the tsv file in the derivatives folder; extract the interested columns and paste it in a text file
# v1- 24/09/2021
# v2- 29/10/2021- Checks for path, throws an error if the correct directory not present
# The code needs to placed in the code folder of BIDS format
# Will not work if ICA aroma is performed

cmd=$(eval "pwd")
echo "Current path $cmd"
cd ../derivatives
cmd=$(eval "pwd")
echo "Changing path to $cmd"
cmd_ls=$(eval "ls")
if [[ $cmd_ls != *"fmriprep"* ]]; then
  echo "code file not in the right place... place it in ./code folder and results in the ./derivatives/fmriprep folder/"
  exit 1
fi
der_path=$cmd/fmriprep
echo "$der_path"
read -p 'Enter task name (Example- CR, MIDT, rest) : ' taskname
#subjID=068
echo "entered task- $taskname"

# columns to extract- > specify the name of columns that you want to extract
colterms="trans_x trans_y trans_z rot_x rot_y rot_z trans_x_derivative1 trans_y_derivative1 trans_z_derivative1 rot_x_derivative1 rot_y_derivative1 rot_z_derivative1 csf"

#specify the derivatives path - use this for manual override. 
#der_path='/projects/cw84/arush/braincann/fmriprep/hannah_s/data/derivatives/fmriprep'

printcol()
{
    local FILE=${1}
    local COLUMNTITLE=${2} 

    # check if even there
    local ccc=$(head -1 $FILE | grep $COLUMNTITLE)
    if [[ -z $ccc ]] ; then
    	>&2 echo "$ccc not in file. error." 
    	rm -v $tmp_file_1
		rm -v $tmp_file_2
		rm -v $tmp_file_3 
    #	exit 1
    fi

    cut $FILE -f `head -1 $FILE | tr "\t" "\n" | grep -n "^$COLUMNTITLE"'$' | cut -f 1 -d :`
}

# remove se if you not have multiple sessions 
for n in ${der_path}/sub-*/se*/ ; do 

    sid="$basename ${n}"
    fname="${sid##*/}"
    echo ${sid}func

    inputfile=${sid}func/*-${taskname}_*.tsv
    outfile=${sid}func/tsv_task-${taskname}_conv_reg.txt

    tmp_file_1=$(mktemp /tmp/getcols.XXXXXX)
    tmp_file_2=$(mktemp /tmp/getcols.XXXXXX)
    tmp_file_3=$(mktemp /tmp/getcols.XXXXXX)

    > $tmp_file_1
    for CC in $colterms ; do
	printcol $inputfile $CC > ${tmp_file_2}
	if [[ -s ${tmp_file_1} ]] ; then
	    paste -d',' ${tmp_file_1} ${tmp_file_2} > ${tmp_file_3}
	    mv $tmp_file_3 $tmp_file_1
	else
	    mv $tmp_file_2 $tmp_file_1
	fi

    done
    sed -i 1d $tmp_file_1
    sed -i 's+n/a+0+g' $tmp_file_1
    mv $tmp_file_1 $outfile
    rm -v $tmp_file_2
done
