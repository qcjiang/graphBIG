#!/bin/bash

output_file="performance_data.csv"
echo "Directory,Minor Faults,DTLB Load Misses,DTLB Load Misses Walk Pending,DTLB Store Misses,DTLB Store Misses Walk Pending,DTLB Load Averaged Overhead,DTLB Store Averaged Overhead,DTLB Miss Averaged Overhead,Time Elapsed,User Time,System Time" > "$output_file"

for dir in */ ; do
    if [[ -f "${dir}more-than-hour" ]]; then
        echo "${dir%,},it will take more than 1 hour,,,,,,,,," >> "$output_file"
    elif [[ -f "${dir}perf-result" ]]; then
        minor_faults=$(awk '/minor-faults/{print $1}' "${dir}perf-result")
        dtlb_load_misses=$(awk '/dtlb_load_misses.miss_causes_a_walk/{print $1}' "${dir}perf-result" | grep -o '[0-9]\+')
        dtlb_load_misses_walk=$(awk '/dtlb_load_misses.walk_pending/{print $1}' "${dir}perf-result" | grep -o '[0-9]\+')
        dtlb_store_misses=$(awk '/dtlb_store_misses.miss_causes_a_walk/{print $1}' "${dir}perf-result" | grep -o '[0-9]\+')
        dtlb_store_misses_walk=$(awk '/dtlb_store_misses.walk_pending/{print $1}' "${dir}perf-result" | grep -o '[0-9]\+')
        time_elapsed=$(awk '/seconds time elapsed/{print $1}' "${dir}perf-result")
        user_time=$(awk '/seconds user/{print $1}' "${dir}perf-result")
        sys_time=$(awk '/seconds sys/{print $1}' "${dir}perf-result")

        # Perform the calculations
        dtlb_load_avg_overhead="N/A"
        dtlb_store_avg_overhead="N/A"
        dtlb_miss_avg_overhead="N/A"

        # Check if the variables are numbers
        re='^[0-9]+$'
        if [[ $dtlb_load_misses =~ $re ]] && [[ $dtlb_load_misses_walk =~ $re ]] && [[ $dtlb_load_misses -gt 0 ]]; then
            dtlb_load_avg_overhead=$(echo "scale=6; $dtlb_load_misses_walk / $dtlb_load_misses" | bc)
        fi

        if [[ $dtlb_store_misses =~ $re ]] && [[ $dtlb_store_misses_walk =~ $re ]] && [[ $dtlb_store_misses -gt 0 ]]; then
            dtlb_store_avg_overhead=$(echo "scale=6; $dtlb_store_misses_walk / $dtlb_store_misses" | bc)
        fi

        if [[ $dtlb_load_misses =~ $re ]] && [[ $dtlb_load_misses_walk =~ $re ]] && [[ $dtlb_store_misses =~ $re ]] && [[ $dtlb_store_misses_walk =~ $re ]] && [[ $dtlb_load_misses -gt 0 || $dtlb_store_misses -gt 0 ]]; then
            dtlb_miss_avg_overhead=$(echo "scale=6; ($dtlb_load_misses_walk + $dtlb_store_misses_walk) / ($dtlb_load_misses + $dtlb_store_misses)" | bc)
        fi

        echo "${dir%,},$minor_faults,$dtlb_load_misses,$dtlb_load_misses_walk,$dtlb_store_misses,$dtlb_store_misses_walk,$dtlb_load_avg_overhead,$dtlb_store_avg_overhead,$dtlb_miss_avg_overhead,$time_elapsed,$user_time,$sys_time" >> "$output_file"
    fi
done
