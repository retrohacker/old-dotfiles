#!/usr/bin/env bash

COLOR_UNKNOWN="#303030"
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
i="0"
while :;
do
    (( i += 1 ))

    # First prime the bar with everything that is "nearly" instant
    # This runs every invocation
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
    WIFI_COLOR="$COLOR_UNKNOWN"

    # Now do all of the stuff that is async _only_ if this isn't the first invocation of the loop
    # This keeps the bar from hanging on first load.
    # TODO: move this to a background subshell and communicate over a socket so we don't block the
    # main loop.
    if (( i > 1 ))
    then
        if nc -w 1 -z 1.1.1.1 80
        then
            WIFI_COLOR="$COLOR_GOOD"
        else
            WIFI_COLOR="$COLOR_BAD"
        fi
    fi
    echo -n ','
    jq -cMn --arg percent " $PERCENT " --arg color "$COLOR" --arg wifi "$WIFI_COLOR" '[{"full_text":$percent,"background":$color},{"full_text": " \\/ ","background":$wifi}]'
    if (( i > 1 ))
    then
        sleep 5
    fi
done
