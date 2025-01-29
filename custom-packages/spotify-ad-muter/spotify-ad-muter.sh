#!/usr/bin/env bash

while true; do
  while ! playerctl -p spotify status >/dev/null 2>&1; do
    sleep 5
  done

  playerctl -p spotify metadata --format '{{title}}' --follow | while read -r title; do
    SPOTIFY_SINK_ID=$(pactl list sink-inputs | awk -v idx="spotify" '
      /#[0-9]+/ { 
        split($0, parts, /#| /); 
        for (i in parts) { 
          if (parts[i] ~ /^[0-9]+$/) { 
            sink_id = parts[i]; 
            break; 
          } 
        } 
      } 
      /application.name = "/ { 
        if ($0 ~ "\"" idx "\"") { 
          print sink_id; 
          exit; 
        } 
      }
    ')

    album=$(playerctl -p spotify metadata | grep 'xesam:album' | cut -d ' ' -f 3-)
    if [[ -z "$album" || "$title" =~ "Advertisement" || "$title" =~ "Spotify" ]]; then
      echo "ad detected, muting..."
      pactl set-sink-input-volume "$SPOTIFY_SINK_ID" 0%
    else
      echo "no ad, play normally"
      pactl set-sink-input-volume "$SPOTIFY_SINK_ID" 100%
    fi
  done
  sleep 5
done
