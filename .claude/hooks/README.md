# Claude Code Hooks

Hooks are shell scripts that run automatically in response to Claude Code events.
They can warn, block, or report on Claude's actions.

This directory contains example hook scripts. They are not active by default.

---

## Available Hook Events

| Event | When it fires |
|---|---|
| `PreToolUse` | Before Claude calls any tool |
| `PostToolUse` | After a tool call completes |
| `Notification` | When Claude sends a notification |
| `Stop` | When a task completes |

---

## How to Enable a Hook

1. Copy and adapt an example script (remove the `.example.sh` suffix or rename it)
2. Make it executable: `chmod +x your-hook.sh`
3. Register it in your Claude Code user or project settings:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/your-project/.claude/hooks/pre-tool-use.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Exit Codes

| Exit code | Meaning |
|---|---|
| `0` | Allow the action to proceed |
| `2` | Block the action; output is shown to Claude as feedback |
| Other non-zero | Error; action may proceed depending on configuration |

---

## Example Files in This Directory

| File | Purpose |
|---|---|
| `pre-tool-use.example.sh` | Warn before potentially dangerous shell commands |
| `post-edit-check.example.sh` | Remind Claude to run validation after editing code files |
| `completion-report.example.sh` | Generate a brief summary when a task completes |

---

## Tips

- Keep hooks fast. A slow hook adds latency to every Claude action.
- Use hooks for reminders and guardrails, not complex logic.
- Print to stdout for messages shown to Claude; print to stderr for messages shown to the user.
- Test hooks manually before registering them: `echo '{"tool_name":"Bash"}' | ./your-hook.sh`

---

## See Also: `.claude/settings.json`

`settings.json` is the other mechanism for controlling Claude's behavior at the project level.
While hooks run shell scripts, `settings.json` uses declarative allow/deny rules.

### Format

```json
{
  "permissions": {
    "allow": ["ToolName(pattern)"],
    "deny":  ["ToolName(pattern)"]
  }
}
```

### Pattern syntax

Patterns are prefix-matched glob strings against the tool's primary argument:

| Pattern | Matches |
|---|---|
| `Bash(git status)` | exactly `git status` |
| `Bash(git log*)` | any command starting with `git log` |
| `Bash(rm -rf *)` | `rm -rf <anything>` (space before `*` is required) |
| `Read(/etc/*)` | any Read call to a path under `/etc/` |

**Important:** `deny` rules only match the bash command string as typed. They cannot intercept SQL passed inside a command (e.g., `psql -c "DROP TABLE"`). Use hooks for that.

### Precedence

`deny` takes precedence over `allow`. If a tool call matches both, it is blocked.

### Scope

`settings.json` in `.claude/` applies to this project only.
Global rules live in `~/.claude/settings.json` and apply to all projects.
Project-level rules are merged on top of global rules; conflicts favour the project file.

### When to use settings.json vs. hooks

| Use | Mechanism |
|---|---|
| Block a specific command prefix | `settings.json` deny |
| Allow a command that global rules block | `settings.json` allow |
| Inspect command content before allowing | Hook (PreToolUse) |
| Run checks after a tool completes | Hook (PostToolUse) |
| Generate a report on session end | Hook (Stop) |
