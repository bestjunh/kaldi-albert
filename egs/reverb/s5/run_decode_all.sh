#!/usr/bin/env bash

# #AlgName=WPEOverIVA_v0.1.4
# # AlgName=CDRWPEOverIVA_v1.3.1

# for lambda_scale in 0.0001; do
#     for lambda_unit in 0; do
#         for lambda_null in 0; do
#             for D in 2; do
#                 for L in 8; do
#                     for delta in 1e-06 ; do
#                         for nIter in 1; do                            
#                             ./run_decode.sh $AlgName 'lambda_scale_'$lambda_scale'_lambda_unit_'$lambda_unit'_lambda_null_'$lambda_null'_D_'$D'_L_'$L'_delta_'$delta'_nIter_'$nIter
#                         done
#                     done
#                 done
#             done
#         done
#     done
# done


AlgName=OfflineWPEOverIVA_v3.1.1
for D in 2 3;do
    for L in 8 12 20;do
        for deltaWPE in 0.001 0.0001 1e-05;do
            for deltaIVA in 0.001 1e-05 1e-10;do
                ./run_decode.sh $AlgName 'D_'$D'_L_'$L'_deltaWPE_'$deltaWPE'_deltaIVA_'$deltaIVA
            done
        done
    done
done

