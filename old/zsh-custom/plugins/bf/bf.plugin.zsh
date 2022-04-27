# Connect to VC's vpn through anyconnect
function vpnVC() {
  source "${SECRETS}/secrets.zsh"
  printf "CustomerVPN\n${BFVPN_USERNAME}\n${BFVPN_PW} ${BFVPN_USERNAME}"
  # launchctl load /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist 2> /dev/null
  printf "CustomerVPN\n${BFVPN_USERNAME}\n${BFVPN_PW}\n" |
    /opt/cisco/anyconnect/bin/vpn -s connect ${BFVPN_USERNAME}
  unset_secrets
}

# Disconnect from anyconnect vpn
function vpnD() {
  /opt/cisco/anyconnect/bin/vpn -s disconnect
  # launchctl unload /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist 2> /dev/null
}

# source "${SECRETS}/secrets.zsh"
# export DIGITALOCEAN_ACCESS_TOKEN=${DO_ACCESS_TOKEN}
# export SPACES_SECRET_ACCESS_KEY=${SPACES_SECRET_ACCESS_KEY}
# export SPACES_ACCESS_KEY_ID=${SPACES_ACCESS_KEY_ID}
# unset_secrets
