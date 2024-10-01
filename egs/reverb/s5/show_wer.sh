#!/usr/bin/env bash

#optName1=WPEOverIVA_v0.1.4
# optName1=CDRWPEOverIVA_v2.3.0
optName1=CDRSVDWPEOverIVA_v0.0.0

for lambda_scale in 0.0001;do
    for lambda_unit in 0; do
        for lambda_null in 0; do
            for D in 2; do
                for L in 8; do
                    for delta in 1e-10; do
                        for wpe_delta in 1;do
                            for nIter in 1; do
                                optName2='lambda_scale_'$lambda_scale'_lambda_unit_'$lambda_unit'_lambda_null_'$lambda_null'_D_'$D'_L_'$L'_delta_'$delta'_wpe_delta_'$wpe_delta'_nIter_'$nIter
                                test_set=$optName1'_'$optName2
                                test_sets="et_real_8ch_${test_set}"
                                # cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_*
                                #echo $test_set
                                far_wer=$(cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_far_room1 | awk '/%WER/ {print $2}')
                                near_wer=$(cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_near_room1 | awk '/%WER/ {print $2}')
                                #echo -e "$far_wer\t$near_wer"
                                
                                echo -e "$far_wer"
                                echo -e "$near_wer"
                            done
                        done
                    done
                done
            done
        done
    done
done


# optName1=OfflineWPEOverIVA_v3.1.1
# for D in 2;do
#     for L in 8;do
#         for deltaWPE in 0.001;do
#             for deltaIVA in 0.001;do
#                 optName2='D_'$D'_L_'$L'_deltaWPE_'$deltaWPE'_deltaIVA_'$deltaIVA
#                 test_set=$optName1'_'$optName2
#                 test_sets="et_real_8ch_${test_set}"
#                 # cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_*
#                 #echo $test_set
#                 far_wer=$(cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_far_room1 | awk '/%WER/ {print $2}')
#                 near_wer=$(cat exp/chain_tr_simu_8ch/tdnn1a_sp/decode_test_tg_5k_$test_sets/scoring_kaldi/best_wer_near_room1 | awk '/%WER/ {print $2}')
#                 #echo -e "$far_wer\t$near_wer"

#                 echo -e "$far_wer"
#                 echo -e "$near_wer"
#             done
#         done
#     done
# done