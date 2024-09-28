#!/bin/bash
#
# Copyright 2018 Johns Hopkins University (Author: Shinji Watanabe)
# Copyright 2018 Johns Hopkins University (Author: Aswin Shanmugam Subramanian)
# Apache 2.0
# This script is adapted from data preparation scripts in the Kaldi reverb recipe
# https://github.com/kaldi-asr/kaldi/tree/master/egs/reverb/s5/local

# Begin configuration section.
wavdir=${PWD}/wav
# End configuration section
. ./utils/parse_options.sh  # accept options.. you can run this run.sh with the

. ./path.sh

echo >&2 "$0" "$@"
# if [ $# -ne 2 ] ; then
#   echo >&2 "$0" "$@"
#   echo >&2 "$0: Error: wrong number of arguments"
#   echo -e >&2 "Usage:\n  $0 [opts] <reverb-dir> <wsjcam0-dir>"
#   echo -e >&2 "eg:\n  $0 /export/corpora5/REVERB_2014/REVERB /export/corpora3/LDC/LDC95S24/wsjcam0"
#   exit 1
# fi

set -e -o pipefail

test_sets=$1
test_path=$2
reverb=$3
wsjcam0=$4


# tool directory
tooldir=${PWD}/data/local/reverb_tools

# working directory
dir=${PWD}/data/local/data
mkdir -p ${dir}

# finally copy the above files to the data directory
for nch in 1; do
    for task in dt et; do
    
    # sed 'A'"$변수명"'B' 
	datadir=data/${task}_simu_8ch_${test_sets}
	mkdir -p ${datadir}
	sort ${dir}/${task}_simu_1ch_wav.scp | sed -e 's%'"$reverb"'%'"$test_path"'%'> ${datadir}/wav.scp
	sort ${dir}/${task}_simu_1ch.txt     > ${datadir}/text
	sort ${dir}/${task}_simu_1ch.utt2spk > ${datadir}/utt2spk
	sort ${dir}/${task}_simu_1ch.spk2utt > ${datadir}/spk2utt
	# ./utils/fix_data_dir.sh ${datadir}
	# if [ ${task} != 'tr' ]; then
	#     datadir=data/${task}_simu_${nch}ch_wpe
	#     mkdir -p ${datadir}
	#     sort ${dir}/${task}_simu_1ch_wpe_wav.scp | sed -e "s/WPE\/1ch/WPE\/${nch}ch/" > ${datadir}/wav.scp
	#     sort ${dir}/${task}_simu_1ch.txt     > ${datadir}/text
	#     sort ${dir}/${task}_simu_1ch.utt2spk > ${datadir}/utt2spk
	#     sort ${dir}/${task}_simu_1ch.spk2utt > ${datadir}/spk2utt
	#     ./utils/fix_data_dir.sh ${datadir}
	#     if [ ${nch} != 1 ]; then
	# 	datadir=data/${task}_simu_${nch}ch_beamformit
	# 	mkdir -p ${datadir}
	# 	sort ${dir}/${task}_simu_1ch_wpe_wav.scp | sed -e "s/ch1/bf${nch}/" | sed -e "s/WPE\/1ch/WPE\/${nch}ch/" > ${datadir}/wav.scp
	# 	sort ${dir}/${task}_simu_1ch.txt     > ${datadir}/text
	# 	sort ${dir}/${task}_simu_1ch.utt2spk > ${datadir}/utt2spk
	# 	sort ${dir}/${task}_simu_1ch.spk2utt > ${datadir}/spk2utt
	# 	./utils/fix_data_dir.sh ${datadir}
 #            else
	# 	datadir=data/${task}_cln
	# 	mkdir -p ${datadir}
	# 	sort ${dir}/${task}_cln_wav.scp > ${datadir}/wav.scp
	# 	sort ${dir}/${task}_cln.txt     > ${datadir}/text
	# 	sort ${dir}/${task}_cln.utt2spk > ${datadir}/utt2spk
	# 	sort ${dir}/${task}_cln.spk2utt > ${datadir}/spk2utt
	# 	./utils/fix_data_dir.sh ${datadir}
	#     fi
	# fi
    done
done
