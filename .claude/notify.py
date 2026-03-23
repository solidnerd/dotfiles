#!/usr/bin/env python3
# Adapted from https://github.com/jessfraz/dotfiles/blob/main/.codex/notify.py

import json
import os
import shutil
import subprocess
import sys
from typing import Optional


def should_use_terminal_notifier() -> bool:
    if os.environ.get("CLAUDE_NOTIFY_FORCE_TERMINAL_NOTIFIER") == "1":
        return True
    if os.environ.get("TERM_PROGRAM") == "ghostty":
        return False
    if os.environ.get("__CFBundleIdentifier") == "com.mitchellh.ghostty":
        return False
    if os.environ.get("TERM") == "xterm-ghostty":
        return False
    return True


def notify(title: str, message: str) -> None:
    """Send a macOS notification via terminal-notifier.

    Non-blocking, ignores failures.
    """
    if not should_use_terminal_notifier():
        return
    tn = shutil.which("terminal-notifier")
    if not tn:
        return
    args = [
        tn,
        "-title",
        title,
        "-message",
        message,
        "-group",
        "claude-code",
        "-activate",
        "com.mitchellh.ghostty",
    ]
    try:
        subprocess.run(
            args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3
        )
    except Exception:
        pass


def main() -> int:
    raw: Optional[str] = None
    if not sys.stdin.isatty():
        raw = sys.stdin.read().strip() or None

    if not raw:
        return 1

    try:
        event = json.loads(raw)
    except json.JSONDecodeError:
        return 1

    hook_event = event.get("hook_event_name", "")

    if hook_event == "Stop":
        stop_reason = event.get("stop_reason", "")
        title = "Claude Code"
        message = "Ready for input" if stop_reason else "Turn complete"
        notify(title, message)
    elif hook_event == "Notification":
        notification_type = event.get("notification_type", "")
        title = "Claude Code"
        message = notification_type.replace("_", " ").title() if notification_type else "Needs attention"
        notify(title, message)
    else:
        return 0

    return 0


if __name__ == "__main__":
    sys.exit(main())
