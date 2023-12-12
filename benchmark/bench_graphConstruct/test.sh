#!/bin/bash
perf stat -e minor-faults \
    -e dtlb_load_misses.miss_causes_a_walk \
    -e dtlb_load_misses.walk_pending \
    -e dtlb_load_misses.walk_active \
    -e dtlb_store_misses.miss_causes_a_walk \
    -e dtlb_store_misses.walk_pending \
    -e dtlb_store_misses.walk_active \
    -e cycles \
    -- ./graphconstruct --dataset /mnt/panzer/rahbera/graph_datasets/graphBIG/CL-10M-1d8-L5
