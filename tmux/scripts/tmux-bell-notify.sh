#!/usr/bin/env bash
# Fires a native Windows toast notification when tmux bell rings,
# unless the bell's window is both active AND its session is currently
# attached to a client (i.e. actually being viewed right now).
# Args: $1 = tmux session name, $2 = pane current path, $3 = window_active flag,
#       $4 = session_attached count (all via tmux hook formats)

SESSION="${1:-tmux}"
PANE_PATH="${2:-$PWD}"
WINDOW_ACTIVE="${3:-0}"
SESSION_ATTACHED="${4:-0}"
DIR="$(basename "$PANE_PATH")"

# Skip notification only if the window is active in its session AND that
# session is currently attached to a client (i.e. you're actually looking at it).
if [ "$WINDOW_ACTIVE" = "1" ] && [ "$SESSION_ATTACHED" != "0" ]; then
  exit 0
fi

TITLE="${DIR}"
MSG="yo?! 🤖"
ICON_PATH="C:\\Users\\ADOLNGV\\AppData\\Local\\tmux-notify\\robot.png"

POWERSHELL="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

"$POWERSHELL" -NoProfile -Command "
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

\$template = @'
<toast>
  <visual>
    <binding template=\"ToastGeneric\">
      <text>${TITLE}</text>
      <text>${MSG}</text>
      <image placement=\"appLogoOverride\" hint-crop=\"circle\" src=\"${ICON_PATH}\"/>
    </binding>
  </visual>
</toast>
'@

\$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$xml.LoadXml(\$template)
\$toast = New-Object Windows.UI.Notifications.ToastNotification \$xml

\$appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\$appId).Show(\$toast)
" >/dev/null 2>&1 &
