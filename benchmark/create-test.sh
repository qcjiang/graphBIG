#!/bin/bash
for dir in bench_* ubench_*
do
    if [[ -d "$dir" ]]
    then
        cd "$dir"    
        executable=$(find . -maxdepth 1 -type f -executable | head -n 1)
        executable=${executable:2}
        cat << EOF > test.sh
#!/bin/bash
perf stat -e minor-faults \\
    -e dtlb_load_misses.miss_causes_a_walk \\
    -e dtlb_load_misses.walk_pending \\
    -e dtlb_load_misses.walk_active \\
    -e dtlb_store_misses.miss_causes_a_walk \\
    -e dtlb_store_misses.walk_pending \\
    -e dtlb_store_misses.walk_active \\
    -e cycles \\
    -- ./$executable --dataset /mnt/panzer/rahbera/graph_datasets/graphBIG/CL-10M-1d8-L5
EOF
        chmod +x test.sh
        cd ..
    fi
done
