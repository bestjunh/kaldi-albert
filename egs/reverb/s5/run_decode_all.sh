#!/usr/bin/env bash

for lambda_scale in 1; do
    for lambda_unit in 0; do
        for lambda_null in 10; do
            for D in 2; do
                for L in 8; do
                    for delta in 1e-06; do
                        for nIter in 1; do
                            echo "delta: $delta"
                            ./run_decode.sh WPEOverIVA_v0.1.0 'lambda_scale_'$lambda_scale'_lambda_unit_'$lambda_unit'_lambda_null_'$lambda_null'_D_'$D'_L_'$L'_delta_'$delta'_nIter_'$nIter
                        done
                    done
                done
            done
        done
    done
done

