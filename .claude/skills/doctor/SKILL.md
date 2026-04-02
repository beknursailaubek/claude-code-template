---
name: doctor
description: Diagnose project environment — checks runtime, dependencies, git state, MCP connections, hooks, and Claude Code configuration. Use when something feels broken or at project onboarding.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
---

# Skill: Doctor

## Purpose
Quickly diagnose the project environment and identify misconfigurations, missing dependencies, or broken tooling.

## When to Use
- First time working with a project
- When commands fail unexpectedly
- After pulling major changes
- When hooks or MCP servers aren't working
- During onboarding a new team member

## Checks (run in order)

### 1. Runtime & Tools
```bash
node --version 2>/dev/null || echo "MISSING: node"
npm --version 2>/dev/null || echo "MISSING: npm"
git --version 2>/dev/null || echo "MISSING: git"
jq --version 2>/dev/null || echo "MISSING: jq (needed for hooks)"
```

### 2. Package Manager & Dependencies
```bash
# Detect package manager
[ -f yarn.lock ] && echo "PM: yarn" || \
[ -f pnpm-lock.yaml ] && echo "PM: pnpm" || \
[ -f package-lock.json ] && echo "PM: npm" || \
echo "PM: unknown"

# Check node_modules
[ -d node_modules ] && echo "node_modules: OK" || echo "node_modules: MISSING — run install"
```

### 3. Git State
```bash
git status --short
git branch --show-current
git log --oneline -3
```

### 4. Claude Code Configuration
```bash
[ -f CLAUDE.md ] && echo "CLAUDE.md: OK" || echo "CLAUDE.md: MISSING"
[ -f .claude/settings.json ] && python3 -c "import json; json.load(open('.claude/settings.json')); print('settings.json: VALID')" || echo "settings.json: MISSING or INVALID"
ls .claude/rules/*.md 2>/dev/null | wc -l | xargs -I{} echo "Rules: {} files"
ls .claude/skills/*/SKILL.md 2>/dev/null | wc -l | xargs -I{} echo "Skills: {} files"
ls .claude/agents/*.md 2>/dev/null | wc -l | xargs -I{} echo "Agents: {} files"
```

### 5. Hooks
```bash
for hook in pre-tool-use.sh post-edit-lint.sh protect-files.sh session-report.sh; do
  if [ -f ".claude/hooks/$hook" ]; then
    [ -x ".claude/hooks/$hook" ] && echo "Hook $hook: OK" || echo "Hook $hook: NOT EXECUTABLE — run chmod +x"
  else
    echo "Hook $hook: MISSING"
  fi
done
```

### 6. MCP Servers
```bash
if [ -f .mcp.json ]; then
  python3 -c "import json; servers=json.load(open('.mcp.json')).get('mcpServers',{}); [print(f'MCP {k}: configured') for k in servers]" 2>/dev/null || echo "MCP: .mcp.json parse error"
else
  echo "MCP: no .mcp.json found"
fi
```

### 7. Placeholders Check
```bash
PLACEHOLDERS=$(grep -r "{{" . --include="*.md" --include="*.json" 2>/dev/null | grep -v node_modules | grep -v .git)
[ -z "$PLACEHOLDERS" ] && echo "Placeholders: none (good)" || echo "Placeholders: FOUND — run /project-bootstrap"
```

### 8. Build & Test
```bash
[ -f package.json ] && {
  npm run lint --if-present 2>&1 | tail -3
  npm test --if-present 2>&1 | tail -3
  npm run build --if-present 2>&1 | tail -3
} || echo "No package.json — skipping build checks"
```

## Output Format
```
=== Doctor Report ===
Runtime:       node v22.x, npm 10.x, git 2.x, jq 1.7
Package:       npm, node_modules OK
Git:           main, clean, 3 recent commits
Config:        CLAUDE.md OK, settings OK, 6 rules, 11 skills, 8 agents
Hooks:         4/4 executable
MCP:           postgres configured
Placeholders:  none
Build:         lint OK, tests OK, build OK

Issues found:  0
```

## Completion Criteria
- [ ] All 8 check categories executed
- [ ] Issues clearly listed with fix instructions
- [ ] No false positives (graceful handling of missing tools)
