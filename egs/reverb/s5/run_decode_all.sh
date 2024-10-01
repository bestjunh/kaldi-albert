#!/usr/bin/env bash

AlgName=WPEOverIVA_v1.0.0
# AlgName=CDRWPEOverIVA_v2.3.0
# AlgName=CDRSVDWPEOverIVA_v0.0.0

for lambda_scale in 0.0001; do
    for lambda_unit in 0; do
        for lambda_null in 0; do
            for D in 2; do
                for L in 8; do
                    for delta in 1e-10 ; do
                        for wpe_delta in 1;do
                            for nIter in 1; do
                                for wavIter in 1 2;do
                                    ./run_decode_v2.sh $AlgName $wavIter 'lambda_scale_'$lambda_scale'_lambda_unit_'$lambda_unit'_lambda_null_'$lambda_null'_D_'$D'_L_'$L'_delta_'$delta'_wpe_delta_'$wpe_delta'_nIter_'$nIter
                                done
                            done
                        done
                    done
                done
            done
        done
    done
done


# AlgName=OfflineWPEOverIVA_v3.1.1
# for D in 2;do
#     for L in 8;do
#         for deltaWPE in 0.001;do
#             for deltaIVA in 0.001;do
#                 ./run_decode.sh $AlgName 'D_'$D'_L_'$L'_deltaWPE_'$deltaWPE'_deltaIVA_'$deltaIVA
#             done
#         done
#     done
# done

