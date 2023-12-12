for dir in bench_* ubench_*
do
    if [ "$dir" = "bench_betweennessCentr" ] || [ "$dir" = "bench_gibbsInference" ] || [ "$dir" = "bench_graphUpdate" ] || [ "$dir" = "ubench_delete" ] || [ "$dir" = "ubench_find" ]; then #they will take more than two hours
        continue
    fi

    if [ -d "$dir" ] && [ -f "$dir/test.sh" ]; then
        echo "Running test.sh in $dir..."

        if timeout 1h bash -c "cd $dir && ./test.sh > perf-result 2>&1"; then
            echo "Completed test.sh in $dir."
        else
            echo "test.sh in $dir exceeded one hour."
            touch "$dir/more-than-hour"
        fi
    fi
done
