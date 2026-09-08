#!/usr/bin/env bash
# Fires a native Windows toast notification when tmux bell rings.
# Args: $1 = tmux session name, $2 = pane current path (both passed via tmux hook formats)

SESSION="${1:-tmux}"
PANE_PATH="${2:-$PWD}"
DIR="$(basename "$PANE_PATH")"

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
