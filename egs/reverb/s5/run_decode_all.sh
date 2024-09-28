#!/usr/bin/env bash

for D in 1 2; do
    for L in 0 2 5 8; do
        for delta in 0.001 1e-06 1e-08; do
            echo "delta: $delta"
            ./run_decode.sh OfflineWPEOverIVA_v0.0.1 'lambda_scale_1_lambda_unit_0_lambda_null_0_D_'$D'_L_'$L'_delta_'$delta
        done
    done
done