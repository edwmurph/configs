#!/bin/bash

curl --include \
     --request POST \
     --header "Content-Type: application/json" \
     --data-binary "{
    \"reason\": \"+6 @aababio @jbjerke @kenny.fellows @dpreston @mgreenwald @gchoy @kennis @smurray ☁️🍒 #teamwork\"
}" \
"https://bonus.ly/api/v1/bonuses?access_token=$BONUSLY_API_KEY"
