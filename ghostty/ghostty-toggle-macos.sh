#!/bin/bash
set -euo pipefail

APP_NAME="Ghostty"

activate_ghostty() {
  osascript <<APPLESCRIPT
tell application "$APP_NAME"
  activate
end tell
APPLESCRIPT
}

toggle_quick_terminal() {
  osascript <<APPLESCRIPT
tell application "$APP_NAME"
  perform action "toggle_quick_terminal" on terminal 1
end tell
APPLESCRIPT
}

frontmost_bundle_id=$(
  osascript <<'APPLESCRIPT' 2>/dev/null || true
tell application "System Events"
  set frontApp to first application process whose frontmost is true
  return bundle identifier of frontApp
end tell
APPLESCRIPT
)

if ! pgrep -qx "ghostty" >/dev/null 2>&1 && ! pgrep -qx "Ghostty" >/dev/null 2>&1; then
  open -a "$APP_NAME"
fi

if [ "$frontmost_bundle_id" != "com.mitchellh.ghostty" ]; then
  for _ in {1..20}; do
    activate_ghostty && break
    sleep 0.1
  done
fi

for _ in {1..20}; do
  toggle_quick_terminal && exit 0
  sleep 0.1
done

toggle_quick_terminal
