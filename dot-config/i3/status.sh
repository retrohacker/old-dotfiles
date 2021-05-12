#!/usr/bin/env bash

COLOR_CHARGING="#30309b"
COLOR_HIGH="#66A11"
COLOR_LOW="#ff0090"

# Send the header so that i3bar knows we want to use JSON:
echo '{ "version": 1 }'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[]'

# Now send blocks with information forever:
while :;
do
    PERCENT="$(apm -l)"
    CHARGING="$(apm -b)"

    COLOR="$COLOR_HIGH"
    if (( PERCENT < 25 ))
    then
	    COLOR="$COLOR_LOW"
    fi
    if (( CHARGING == 3 ))
    then
	    COLOR="$COLOR_CHARGING"
    fi
    echo -n ','
    jq -cMn --arg percent " $PERCENT " --arg color "$COLOR" '[{"full_text":$percent,"background":$color}]'
    sleep 1
done
