#!/bin/bash
perf stat -e minor-faults \
    -e dTLB-loads     -e dTLB-load-misses     -e dTLB-stores     -e dTLB-store-misses     -e dtlb_load_misses.miss_causes_a_walk \
    -e dtlb_load_misses.walk_pending \
    -e dtlb_load_misses.walk_active \
    -e dtlb_store_misses.miss_causes_a_walk \
    -e dtlb_store_misses.walk_pending \
    -e dtlb_store_misses.walk_active \
    -e cycles \
    -e instructions \
    -- ./dfs --dataset /mnt/panzer/rahbera/graph_datasets/graphBIG/CL-10M-1d8-L5
