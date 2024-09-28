#!/usr/bin/env bash

optName1=OfflineWPEOverIVA_v0.1.0

for D in 2; do
    for L in 8 10 12; do
        for delta in 0.001 1e-06 1e-08; do
            optName2='lambda_scale_1_lambda_unit_0_lambda_null_0_D_'$D'_L_'$L'_delta_'$delta
            test_set=$optName1'_'$optName2
            test_sets="et_real_8ch_${test_set}"
            # cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_*
            echo $test_set
            cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_* | awk '/%WER/ {print $2}'
        done
    done
done


