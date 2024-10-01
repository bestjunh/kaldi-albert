#!/usr/bin/env bash

# Copyright 2013-2014 MERL (author: Felix Weninger and Shinji Watanabe)
#                     Johns Hopkins University (author: Szu-Jui Chen)
#                     Johns Hopkins University (author: Aswin Shanmugam Subramanian)

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
# WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
# MERCHANTABLITY OR NON-INFRINGEMENT.
# See the Apache 2 License for the specific language governing permissions and
# limitations under the License.

# This is a shell script, but it's recommended that you run the commands one by
# one by copying and pasting into the shell.
# Caution: some of the graph creation steps use quite a bit of memory, so you
# should run this on a machine that has sufficient memory.

# Requirements) matlab and tcsh
if [ ! `which tcsh` ]; then
  echo "Install tcsh, which is used in some REVERB scripts"
  exit 1
fi
if [ ! `which matlab` ]; then
  echo "Install matlab, which is used to generate multi-condition data"
  exit 1
fi

. ./cmd.sh
. ./path.sh




. utils/parse_options.sh
# Set bash to 'debug' mode, it prints the commands (option '-x') and exits on :
# -e 'error', -u 'undefined variable', -o pipefail 'error in pipeline',
set -euxo pipefail

# please make sure to set the paths of the REVERB and WSJ0 data
# if [[ $(hostname -f) == *.clsp.jhu.edu ]] ; then
#   reverb=/export/corpora5/REVERB_2014/REVERB
#   export wsjcam0=/export/corpora3/LDC/LDC95S24/wsjcam0
#   # set LDC WSJ0 directory to obtain LMs
#   # REVERB data directory only provides bi-gram (bcb05cnp), but this recipe also uses 3-gram (tcb05cnp.z)
#   export wsj0=/export/corpora5/LDC/LDC93S6A/11-13.1 #LDC93S6A or LDC93S6B
#   # It is assumed that there will be a 'wsj0' subdirectory
#   # within the top-level corpus directory
# else
#   echo "Set the data directory locations." && exit 1;
# fi

reverb=/home/nas/user/byungjoon/DB/REVERB
export wsjcam0=/home/nas/user/byungjoon/DB/REVERB/wsjcam0
export wsj0=/home/nas/user/byungjoon/DB/REVERB/11-13.1 #LDC93S6A or LDC93S6B

#training set and test set
train_set=tr_simu_8ch

# test_path=/home/dev60-data-mount/albert/outputReverb2MIX/Noisy
# test_set=Noisy

optName1=$1
wavIter=$2
optName2=$3
test_path=/home/dev60-data-mount/albert/outputReverb2MIX/$optName1/$optName2/wavIter$wavIter
echo '================================================'
echo $test_path
echo '================================================'
test_set=$optName1'_'$optName2'_'$wavIter

# test_path=/home/dev60-data-mount/albert/outputReverb2MIX/CDRWPEOverIVA_v0.0.1/lambda_scale_1_lambda_unit_0_lambda_null_0_D_3_L_4
# test_set=CWO001_lambda_scale_1_lambda_unit_0_lambda_null_0_D_3_L_4

# 0 to run decode, 14 to get results
stage=0

test_sets="et_real_8ch_${test_set}"

# The language models with which to decode (tg_5k or bg_5k)
lm="tg_5k"

# number of jobs for feature extraction and model training
nj=24
# number of jobs for decoding
decode_nj=24


# wavdir=/home/dev60-data-mount/albert/kaldi_reverb_wav
wavdir=${PWD}/wav # If you gonna run stage 2, uncommentize this one.
pesqdir=${PWD}/local


if [ ${stage} -le 1 ]; then
  # data preparation
  echo "stage 0: Data preparation"
  # local/generate_data.sh --wavdir ${wavdir} ${wsjcam0}
  # local/prepare_simu_data.sh --wavdir ${wavdir} ${reverb} ${wsjcam0}
  # local/prepare_real_data.sh --wavdir ${wavdir} ${reverb}
  local/prepare_simu_data_decode.sh ${test_set} ${test_path} ${reverb} ${wsjcam0}
  local/prepare_real_data_decode.sh ${test_set} ${test_path} ${reverb}
fi

if [ $stage -le 5 ]; then
  for dset in ${test_sets}; do
    utils/copy_data_dir.sh data/${dset} data/${dset}_nosplit
    utils/data/modify_speaker_info.sh --seconds-per-spk-max 180 data/${dset}_nosplit data/${dset}
  done
fi

if [ $stage -le 6 ]; then
  # Extract MFCC features for train and test sets.
  mfccdir=mfcc
  for x in ${test_sets}; do
   steps/make_mfcc.sh --cmd "$train_cmd" --nj $nj \
     data/$x exp/make_mfcc/$x $mfccdir
   steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir
  done
fi

if [ $stage -le 10 ]; then
  # utils/mkgraph.sh data/lang_test_$lm exp/tri2 exp/tri2/graph
  for dset in ${test_sets}; do
    steps/decode.sh --nj $decode_nj --cmd "$decode_cmd"  --num-threads 4 \
		    exp/tri2/graph data/${dset} exp/tri2/decode_${dset} &
  done
  wait
fi

if [ $stage -le 12 ]; then
  # utils/mkgraph.sh data/lang_test_$lm exp/tri3 exp/tri3/graph
  for dset in ${test_sets}; do
    steps/decode_fmllr.sh --nj $decode_nj --cmd "$decode_cmd"  --num-threads 4 \
			  exp/tri3/graph data/${dset} exp/tri3/decode_${dset} &
  done
  wait
fi

if [ $stage -le 13 ]; then
  # chain TDNN

  for datadir in ${test_sets}; do
    utils/copy_data_dir.sh data/$datadir data/${datadir}_hires
  done

  for datadir in ${test_sets}; do
    steps/make_mfcc.sh --nj $nj --mfcc-config conf/mfcc_hires.conf \
      --cmd "$train_cmd" data/${datadir}_hires
    steps/compute_cmvn_stats.sh data/${datadir}_hires
    utils/fix_data_dir.sh data/${datadir}_hires
  done

  # Also extract iVectors for the test data, but in this case we don't need the speed
  # perturbation (sp).
  nnet3_affix=_${train_set}
  for data in ${test_sets}; do
    nspk=$(wc -l <data/${data}_hires/spk2utt)
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "${nspk}" \
      data/${data}_hires exp/nnet3${nnet3_affix}/extractor \
      exp/nnet3${nnet3_affix}/ivectors_${data}_hires
  done

  local/chain/run_tdnn_decode.sh --nj ${nj} --train-set ${train_set} --test-sets "$test_sets" --gmm tri3 --nnet3-affix _${train_set} \
  --lm-suffix _test_$lm
fi

echo $stage
if [ $stage -le 14 ]; then
  for dset in ${test_sets}; do    
    cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$dset/scoring_kaldi/best_wer_*
  done
fi