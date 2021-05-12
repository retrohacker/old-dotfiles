#!/usr/bin/env bash

COLOR_CHARGING="#30309b"
COLOR_GOOD="#66A11"
COLOR_BAD="#ff0090"

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

    COLOR="$COLOR_GOOD"
    if (( PERCENT < 25 ))
    then
	    COLOR="$COLOR_BAD"
    fi
    if (( CHARGING == 3 ))
    then
	    COLOR="$COLOR_CHARGING"
    fi
    WIFI_COLOR="$COLOR_BAD"
    if nc -z mullvad.net 80
    then
	    WIFI_COLOR="$COLOR_GOOD"
    fi
    echo -n ','
    jq -cMn --arg percent " $PERCENT " --arg color "$COLOR" --arg wifi "$WIFI_COLOR" '[{"full_text":$percent,"background":$color},{"full_text": " \\/ ","background":$wifi}]'
    sleep 5
done
