#!/usr/bin/env bash
# Fires a native Windows toast notification when tmux bell rings,
# unless the bell came from the window currently being viewed.
# Args: $1 = tmux session name, $2 = pane current path, $3 = window_active flag (all via tmux hook formats)

SESSION="${1:-tmux}"
PANE_PATH="${2:-$PWD}"
WINDOW_ACTIVE="${3:-0}"
DIR="$(basename "$PANE_PATH")"

# Skip notification if the bell fired in the window that's currently displayed
if [ "$WINDOW_ACTIVE" = "1" ]; then
  exit 0
fi

TITLE="tmux bell — ${SESSION}"
MSG="Directory: ${DIR}"

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
