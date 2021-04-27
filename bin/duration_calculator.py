#!/usr/bin/python3

import datetime
import sys

duration_sum_seconds = 0
args = sys.argv[1:]

for duration_str in args:
    duration_str_parts = duration_str.split(':')
    for i in range(len(duration_str_parts)):
        if duration_str_parts[i][0] == '0' and len(duration_str_parts[i]) > 1:
            duration_str_parts[i] = duration_str_parts[i][1]

    duration_sum_seconds += int(duration_str_parts[0]) * 3600  # hours
    duration_sum_seconds += int(duration_str_parts[1]) * 60    # minutes
    duration_sum_seconds += int(duration_str_parts[2])         # seconds

timedelta = datetime.timedelta(seconds=duration_sum_seconds)
print(timedelta)
