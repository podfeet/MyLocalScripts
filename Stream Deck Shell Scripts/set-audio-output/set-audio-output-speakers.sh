#!/bin/zsh
# Switch the Mac's sound output to the CalDigit speakers.
#
# Why this one shouldn't break when the Elgato Wave XLR is unplugged:
#   - It picks the device by NAME, never by its position in a list or its
#     numeric ID. Both of those shift whenever a device is added or removed.
#   - It calls SwitchAudioSource by its full path, because Stream Deck runs
#     scripts without Homebrew on the PATH.
#   - It retries for a few seconds, because right after a device is plugged
#     or unplugged macOS can take a moment to settle its device list.
#   - It checks the result instead of assuming it worked.
#
# Requires: brew install switchaudio-osx

TARGET="CalDigit Thunderbolt 3 Audio"
SAS="/opt/homebrew/bin/SwitchAudioSource"

# Fall back to the Intel Homebrew location if needed
[[ -x "$SAS" ]] || SAS="/usr/local/bin/SwitchAudioSource"
if [[ ! -x "$SAS" ]]; then
    osascript -e 'display notification "SwitchAudioSource not found. Run: brew install switchaudio-osx" with title "Audio Output"'
    exit 1
fi

for attempt in {1..10}; do
    # Only try to switch once the speakers actually show up in the list
    if "$SAS" -a -t output | grep -Fxq "$TARGET"; then
        "$SAS" -t output -s "$TARGET" >/dev/null 2>&1
        # Also send alert sounds to the speakers so beeps follow along
        "$SAS" -t system -s "$TARGET" >/dev/null 2>&1

        if [[ "$("$SAS" -c -t output)" == "$TARGET" ]]; then
            exit 0
        fi
    fi
    sleep 0.5
done

osascript -e "display notification \"Couldn't switch to $TARGET\" with title \"Audio Output\""
exit 1
