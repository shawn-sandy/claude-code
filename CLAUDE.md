<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:

- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:

- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Claude Code Plugin Marketplace** - a distribution repository that catalogs and serves extensible plugins for Claude Code (Anthropic's CLI). It uses a catalog-based architecture where `.claude-plugin/marketplace.json` defines all available plugins.

| Characteristic | Description |
|----------------|-------------|
| **Type** | Pure distribution repository (no build/test/compile steps) |
| **Validation** | JSON/YAML syntax validation + local CLI testing |
| **Change Management** | OpenSpec-driven for significant changes |
| **Reference** | `starter-plugin` implements all component types |
| **Stack** | Configuration files (JSON, Markdown, YAML, Bash) |

## Architecture

### Two-Level Marketplace Structure

**Level 1: Marketplace Catalog** (`.claude-plugin/marketplace.json`)
- Central registry of all available plugins
- Contains: name, version, description, source path
- Single source of truth for discovery

**Level 2: Plugin Manifests** (`plugins/*/. claude-plugin/plugin.json`)
- Individual plugin metadata
- Contains: name, version, author, license, keywords
- Similar to npm's package.json

### Auto-Discovery Pattern

**CRITICAL:** Claude Code automatically discovers components by directory location and filename. Component directories **MUST** be at plugin root (`plugins/my-plugin/commands/`), **NOT** inside `.claude-plugin/` directory.

| Component Type | Location | Discovery Rule | Invocation |
|----------------|----------|----------------|------------|
| **Commands** | `commands/*.md` | Filename → command name | User types `/command-name` |
| **Skills** | `skills/*/SKILL.md` | Directory → skill name | Claude autonomous (context-based) |
| **Agents** | `agents/*.md` | Filename → agent name | Task tool with `subagent_type` |
| **Hooks** | `hooks/hooks.json` | Defined in config | Event-driven (PreToolUse, etc.) |
| **MCP Servers** | `.mcp.json` | Root-level config | Plugin load time |

### Component Comparison

| Component | Invocation | Use For | Example |
|-----------|------------|---------|---------|
| **Commands** | User types `/name` | Explicit user actions | Git commits, test runners, builds |
| **Skills** | Claude autonomous | Enhanced capabilities | Code analysis, formatting, documentation |
| **Agents** | Task tool launch | Complex multi-step tasks | Code reviews, security audits, research |
| **Hooks** | Event-driven | Automation, validation | Pre-commit checks, logging, enforcement |
| **MCP Servers** | Plugin load | External services | API access, databases, external tools |

## Component Development

### Commands (Slash Commands)

**Purpose:** User-invoked workflows triggered by typing `/command-name`

**Structure:** `commands/command-name.md`

**Frontmatter (YAML):**
```yaml
---
description: Brief summary of what command does (REQUIRED)
argument-hint: [optional-args] (OPTIONAL)
allowed-tools: Bash(git:*), Read, Write (OPTIONAL - security restriction)
model: claude-3-5-sonnet-20241022 (OPTIONAL - model override)
---

Your prompt content here...
```

**Use Cases:**
- Git operations (commits, branches, merges)
- Build and test runners
- Deployment workflows
- Custom project-specific tasks

**Security:**
- Use `allowed-tools` to restrict which tools command can use
- `Bash(git:*)` restricts bash to only git commands
- Omitting `allowed-tools` grants full access

**Example:** `plugins/starter-plugin/commands/example.md`

---

### Skills (Autonomous Capabilities)

**Purpose:** Capabilities that Claude autonomously invokes based on context

**Structure:** `skills/skill-name/SKILL.md`

**Frontmatter (YAML):**
```yaml
---
name: skill-identifier (REQUIRED - kebab-case)
description: What it does + WHEN to use it (REQUIRED - CRITICAL for triggering!)
allowed-tools: Read, Grep, Glob (OPTIONAL - security restriction)
---

Your system prompt here...
```

**CRITICAL: Description Requirements**

The `description` field **MUST** include:
1. **What it does** - Capability description
2. **When to use it** - Specific trigger conditions, keywords, or contexts

Example:
```yaml
description: Analyzes code for style issues and best practices. Use this skill when the user asks about "code quality", "style guide", "linting", or mentions checking code standards.
```

**Supporting Files:**
- Complex skills should include `README.md` in skill directory
- Separates user documentation from system prompt
- See `templates/skill-readme-template.md` for template

**Use Cases:**
- Code analysis and pattern detection
- Documentation generation
- Formatting and style checking
- Specialized domain knowledge

**Example:** `plugins/starter-plugin/skills/example-skill/SKILL.md`

---

### Agents (Specialized Subagents)

**Purpose:** Isolated execution contexts for complex, multi-step workflows

**Structure:** `agents/agent-name.md`

**Frontmatter (YAML):**
```yaml
---
name: agent-identifier (REQUIRED - kebab-case)
description: Purpose and when to use (REQUIRED)
tools: Read, Write, Edit, Bash (OPTIONAL - tool restriction)
model: inherit|sonnet|opus|haiku (OPTIONAL - defaults to inherit)
permissionMode: auto|ask|block (OPTIONAL - tool use permissions)
---

Your agent system prompt here...
```

**Model Selection:**
- `haiku` - Fast, simple tasks (<100 tokens output)
- `sonnet` - Balanced, most tasks (default)
- `opus` - Complex reasoning, multi-step workflows
- `inherit` - Use parent conversation's model

**Use Cases:**
- Code reviews and audits
- Security analysis
- Research and exploration
- Domain-specific expertise

**Example:** `plugins/starter-plugin/agents/example-agent.md`

---

### Hooks (Event-Driven Automation)

**Purpose:** Respond to tool usage and session events with automation

**Structure:** `hooks/hooks.json` + `hooks/scripts/*.sh`

**Configuration:**
```json
{
  "description": "Purpose of hooks",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {"type": "prompt", "prompt": "Instruction text"},
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/script.sh",
            "args": ["${TOOL_NAME}", "${TOOL_INPUT}"],
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**Available Events:**

| Event | When | Use For |
|-------|------|---------|
| `PreToolUse` | Before tool execution | Validation, blocking dangerous operations |
| `PostToolUse` | After tool execution | Logging, analysis, reporting |
| `SessionStart` | Session begins | Setup, initialization |
| `UserPromptSubmit` | User enters prompt | Input processing, validation |
| `SessionEnd` | Session ends | Cleanup, final reporting |
| `Stop` / `SubagentStop` | Execution stops | Cleanup, state saving |
| `PermissionRequest` | Permission requested | Custom authorization logic |
| `Notification` | System notification | Event handling |
| `PreCompact` | Before context compaction | Save critical information |

**Hook Types:**
- **prompt** - Injects instructions into Claude
- **command** - Executes external script

**Script Requirements:**

```bash
#!/bin/bash
# Always include shebang

# Environment variables available:
# - TOOL_NAME: Name of tool being used
# - TOOL_INPUT: JSON input to tool
# - TOOL_OUTPUT: JSON output (PostToolUse only)
# - CLAUDE_PLUGIN_ROOT: Absolute path to plugin
# - CLAUDE_PROJECT_DIR: Absolute path to project

# Exit codes:
# 0 = success, continue
# 1 = failure, block operation (PreToolUse only)

exit 0
```

**Make scripts executable:**
```bash
chmod +x hooks/scripts/script.sh
```

**Examples:**
- `plugins/starter-plugin/hooks/hooks.json`
- `plugins/starter-plugin/hooks/scripts/example-hook.sh`

---

### MCP Servers (Model Context Protocol)

**Purpose:** Integrate external services via Model Context Protocol

**Structure:** `.mcp.json` (at plugin root)

**Transport Types:**

**stdio (default) - Process-based:**
```json
{
  "example_server": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/server-name",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "API_KEY": "${API_KEY}",
      "TIMEOUT": "${TIMEOUT:-30}"
    }
  }
}
```

**SSE - Server-Sent Events:**
```json
{
  "sse_server": {
    "transport": "sse",
    "url": "http://localhost:3000/sse",
    "env": {"AUTH_TOKEN": "${AUTH_TOKEN}"}
  }
}
```

**HTTP - Synchronous:**
```json
{
  "http_server": {
    "transport": "http",
    "url": "http://localhost:8080/mcp",
    "headers": {"Authorization": "Bearer ${API_TOKEN}"}
  }
}
```

**Secrets Management:**
- Never commit API keys, tokens, or passwords
- Use environment variables: `${API_KEY}`
- Provide defaults: `${TIMEOUT:-30}`
- Document required env vars in plugin README

**Example:** `plugins/starter-plugin/.mcp.json`

---

## Frontmatter Reference

| Field | Commands | Skills | Agents | Required |
|-------|----------|--------|--------|----------|
| `name` | ✗ | ✓ | ✓ | Skills/Agents only |
| `description` | ✓ | ✓ | ✓ | All components |
| `argument-hint` | ✓ | ✗ | ✗ | No |
| `allowed-tools` | ✓ | ✓ | ✗ | No |
| `tools` | ✗ | ✗ | ✓ | No |
| `model` | ✓ | ✗ | ✓ | No |
| `permissionMode` | ✗ | ✗ | ✓ | No |

## Development Workflow

### Git Hooks (Husky)

This repository uses **Husky** for automated validation. Hooks run on every commit/push.

**Pre-Commit Hook** (`.husky/pre-commit`):
- ✓ Validates JSON files (`marketplace.json`, `plugin.json`, `hooks.json`, `.mcp.json`)
- ✓ Checks shell script syntax (`bash -n`)
- ✓ Verifies hook scripts are executable (`chmod +x`)
- ✓ Validates YAML frontmatter in markdown files
- ✗ Blocks commit if any validation fails

**Commit Message Hook** (`.husky/commit-msg`):
- Enforces conventional commit format
- Pattern: `<type>: <description>` or `<type>(<scope>): <description>`
- Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `build`, `ci`, `add`, `update`, `remove`, `enhance`, `improve`
- Minimum 10 characters, warns if >72

**Examples:**
```bash
docs: update CLAUDE.md with git hooks section
feat(plugins): add new testing plugin
fix: resolve JSON validation in marketplace catalog
enhance(hooks): improve error messages
```

**Pre-Push Hook** (`.husky/pre-push`):
- Runs OpenSpec validation
- Security checks
- Additional project validation

**Bypass Hooks (Not Recommended):**
```bash
git commit --no-verify
git push --no-verify
```

**Troubleshooting:**
- Ensure `jq` installed: `brew install jq` (macOS) or `apt-get install jq` (Linux)
- Check permissions: `ls -la .husky/`
- View hook output for specific errors
- Manually run validations: `jq empty file.json`

---

### OpenSpec Workflow

**Decision Tree:**

```
Is this change...
├─ Bug fix (restoring intended behavior)? → Fix directly, no proposal
├─ Typo/formatting/comment change? → Fix directly, no proposal
├─ Adding dependency (non-breaking)? → Fix directly, no proposal
├─ Adding new plugin? → CREATE OPENSPEC PROPOSAL
├─ Adding component type to existing plugin? → CREATE OPENSPEC PROPOSAL
├─ Breaking change to plugin structure? → CREATE OPENSPEC PROPOSAL
├─ Changing marketplace architecture? → CREATE OPENSPEC PROPOSAL
└─ Unclear? → CREATE OPENSPEC PROPOSAL (safer choice)
```

**Three-Stage Workflow:**

**Stage 1 - Creating Change:**
```bash
# Review existing work
openspec list
openspec list --specs

# Choose unique change-id (kebab-case, verb-led)
# Examples: add-testing-plugin, update-hook-validation

# Scaffold proposal
mkdir -p openspec/changes/[change-id]/specs/[capability]

# Create files:
# - proposal.md (why, what, impact)
# - tasks.md (implementation checklist)
# - specs/[capability]/spec.md (ADDED/MODIFIED/REMOVED requirements)

# Validate
openspec validate [change-id] --strict
```

**Stage 2 - Implementation:**
1. Read `proposal.md`, `design.md` (if exists), `tasks.md`
2. Implement tasks sequentially
3. Mark tasks complete as you finish
4. Wait for approval before starting

**Stage 3 - Archiving:**
```bash
# After deployment
openspec archive [change-id]
# Updates specs/ and moves to archive/
```

**Commands:**
```bash
openspec list                    # Active changes
openspec list --specs            # Current capabilities
openspec show [item]             # View details
openspec validate [item] --strict
openspec diff [change]           # Preview changes
```

---

### Testing Locally

```bash
# Add marketplace from local filesystem
/plugin marketplace add /path/to/claude-code
# Or relative path
/plugin marketplace add ./path/to/claude-code

# Verify marketplace added
/plugin marketplace list

# Install plugin for testing
/plugin install starter-plugin@claude-code-marketplace

# Test components
/example [message]                # Test command
# Skills trigger automatically based on context
# Agents launched via Task tool when needed
```

---

### Adding a New Plugin

**Step 1: OpenSpec Proposal (if significant)**
- See Decision Tree above
- Create proposal for new plugins

**Step 2: Create Plugin Structure**
```bash
mkdir -p plugins/new-plugin/.claude-plugin
mkdir -p plugins/new-plugin/{commands,skills,agents,hooks/scripts}
```

**Step 3: Create plugin.json**
```json
{
  "name": "new-plugin",
  "version": "1.0.0",
  "description": "Clear, concise description",
  "author": {
    "name": "Your Name",
    "email": "your@example.com"
  },
  "homepage": "https://github.com/user/repo",
  "repository": "https://github.com/user/repo",
  "license": "MIT",
  "keywords": ["relevant", "search", "terms"]
}
```

**Step 4: Add Components**
- Follow structure guidelines above
- Reference `plugins/starter-plugin/` for examples

**Step 5: Update Marketplace Catalog**
Edit `.claude-plugin/marketplace.json`:
```json
{
  "plugins": [
    {
      "name": "new-plugin",
      "source": "./plugins/new-plugin",
      "description": "Brief description",
      "version": "1.0.0"
    }
  ]
}
```

**Step 6: Update README.md**
- Add plugin documentation under "Available Plugins"
- Include: name, description, components, installation, usage

**Step 7: Validate Before Committing**

**JSON/YAML Validation:**
```bash
jq empty .claude-plugin/marketplace.json
jq empty plugins/*/.claude-plugin/plugin.json
jq empty plugins/*/hooks/hooks.json
jq empty plugins/*/.mcp.json
```

**Hook Scripts:**
```bash
chmod +x plugins/*/hooks/scripts/*.sh
bash -n plugins/*/hooks/scripts/*.sh
```

**Pre-Commit Checklist:**
- [ ] All JSON files valid
- [ ] YAML frontmatter in all .md files valid
- [ ] Hook scripts executable
- [ ] Skill descriptions include "when to use"
- [ ] No sensitive information (API keys, tokens)
- [ ] Plugin installs locally without errors
- [ ] All components work as expected
- [ ] README.md updated
- [ ] Marketplace catalog updated
- [ ] OpenSpec proposal validated (if applicable)

**Step 8: Test Locally**
- Install and test all components before committing

---

## Critical Patterns & Conventions

### Path Management

**CRITICAL:** Always use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths. Never use hardcoded absolute paths.

**In hooks.json:**
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/example-hook.sh"
}
```

**In .mcp.json:**
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/server.js",
  "args": ["${CLAUDE_PLUGIN_ROOT}/config.json"]
}
```

**In hook scripts:**
```bash
source "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/helpers.sh"
```

**Path Variables:**
- `${CLAUDE_PLUGIN_ROOT}` - Absolute path to plugin directory
- `${CLAUDE_PROJECT_DIR}` - Absolute path to project directory
- `${VAR:-default}` - Environment variable with default value

---

### Naming Conventions

**All identifiers use kebab-case** (lowercase with hyphens):

| Item | Rule | Example |
|------|------|---------|
| Plugin names | kebab-case | `my-plugin` |
| Command files | kebab-case.md | `test-runner.md` → `/test-runner` |
| Skill directories | kebab-case/ | `code-reviewer/` → skill name |
| Agent files | kebab-case.md | `security-audit.md` → agent name |
| Hook scripts | kebab-case.sh | `validate-json.sh` |

**Validation:** Pre-commit hook validates naming conventions.

---

### Component Location Rules

**CRITICAL RULE:** Component directories **MUST** be at plugin root, **NOT** inside `.claude-plugin/` directory.

✅ **Correct:**
```
plugins/my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
├── skills/
├── agents/
└── hooks/
```

❌ **Wrong:**
```
plugins/my-plugin/
└── .claude-plugin/
    ├── plugin.json
    ├── commands/      ← WRONG LOCATION
    ├── skills/        ← WRONG LOCATION
    └── agents/        ← WRONG LOCATION
```

**Common Mistake:** Placing components inside `.claude-plugin/` - they will not be discovered!

---

## Troubleshooting

### Plugin Not Discovered

**Symptoms:** Plugin doesn't appear in `/plugin list`

**Solutions:**
1. Verify plugin in `.claude-plugin/marketplace.json`
2. Check plugin path in marketplace catalog
3. Ensure `plugin.json` at `plugins/[name]/.claude-plugin/plugin.json`
4. Validate JSON syntax: `jq empty file.json`
5. Remove and re-add marketplace

---

### Components Not Loading

**Symptoms:** Commands/skills/agents don't work after installation

**Solutions:**
1. **Check component location** - Must be at plugin root, NOT in `.claude-plugin/`
2. Verify filenames use kebab-case
3. Validate YAML frontmatter: check `---` markers
4. Ensure required frontmatter fields present
5. Skills: Check description includes "when to use"
6. Reinstall plugin: `/plugin uninstall name` then `/plugin install name@marketplace`

---

### Hook Scripts Not Executing

**Symptoms:** Hooks defined but don't run

**Solutions:**
1. Verify executable: `ls -la plugins/*/hooks/scripts/`
2. Make executable: `chmod +x script.sh`
3. Check shebang: `#!/bin/bash`
4. Test syntax: `bash -n script.sh`
5. Verify path uses `${CLAUDE_PLUGIN_ROOT}`
6. Check hook matcher regex correct
7. Test timeout (default 30s, configure in hooks.json)

---

### Path Variable Issues

**Symptoms:** Paths not resolving, file not found errors

**Solutions:**
1. Use `${CLAUDE_PLUGIN_ROOT}` not `./` or hardcoded paths
2. Don't use `~` or `$HOME` in plugin configs
3. Verify syntax: `${VAR}` not `$VAR`
4. For defaults: `${VAR:-default}`
5. Echo path in hook script to test resolution

---

### Validation Failures

**Symptoms:** JSON/YAML errors, OpenSpec validation fails

**Solutions:**
```bash
# Validate JSON
jq empty file.json
python3 -m json.tool file.json

# Check OpenSpec
openspec validate [change-id] --strict
openspec show [change-id] --json --deltas-only
```

**Common Issues:**
- Missing commas in JSON
- Incorrect YAML indentation
- Unquoted strings with special characters
- Missing required frontmatter fields

---

### Git Hook Failures

**Symptoms:** Commit blocked by pre-commit hook

**Solutions:**

**JSON validation failed:**
```bash
# Find specific error
jq . path/to/file.json

# Common fixes:
# - Add missing commas
# - Quote property names
# - Remove trailing commas
```

**Shell script syntax error:**
```bash
# Test syntax
bash -n path/to/script.sh

# Common fixes:
# - Missing fi/done/esac
# - Unquoted variables with spaces
# - Missing semicolons
```

**Hook script not executable:**
```bash
chmod +x plugins/*/hooks/scripts/*.sh
```

**Commit message format:**
```bash
# Use correct format
git commit -m "feat: add new feature"
git commit -m "fix(plugins): resolve bug"

# NOT:
git commit -m "Added new feature"
git commit -m "bug fix"
```

**YAML frontmatter:**
```bash
# Ensure proper closing
---
name: my-skill
description: Description here
---

# NOT:
---
name: my-skill
description: Description here
(missing closing ---)
```

**Bypass (not recommended):**
```bash
git commit --no-verify
```

---

## Quick Reference

### Common Commands

```bash
# Marketplace management
/plugin marketplace add <owner/repo>
/plugin marketplace add <local-path>
/plugin marketplace list
/plugin marketplace update <name>

# Plugin management
/plugin list
/plugin install <name>@<marketplace>
/plugin update <name>
/plugin uninstall <name>

# OpenSpec workflow
openspec list
openspec list --specs
openspec show [item]
openspec validate [item] --strict
openspec archive [change] --yes

# Local validation
jq empty .claude-plugin/marketplace.json
chmod +x plugins/*/hooks/scripts/*.sh
bash -n plugins/*/hooks/scripts/*.sh
```

---

### File Locations

| File Type | Location |
|-----------|----------|
| Marketplace catalog | `.claude-plugin/marketplace.json` |
| Plugin manifest | `plugins/[name]/.claude-plugin/plugin.json` |
| Commands | `plugins/[name]/commands/*.md` |
| Skills | `plugins/[name]/skills/*/SKILL.md` |
| Agents | `plugins/[name]/agents/*.md` |
| Hooks config | `plugins/[name]/hooks/hooks.json` |
| Hook scripts | `plugins/[name]/hooks/scripts/*.sh` |
| MCP config | `plugins/[name]/.mcp.json` |

---

### Path Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `${CLAUDE_PLUGIN_ROOT}` | Absolute path to plugin | `/Users/you/.claude/plugins/my-plugin` |
| `${CLAUDE_PROJECT_DIR}` | Absolute path to project | `/Users/you/projects/my-project` |
| `${VAR:-default}` | Env var with default | `${TIMEOUT:-30}` |

---

### Essential Reading

| Resource | Purpose |
|----------|---------|
| `openspec/AGENTS.md` | OpenSpec workflow and CLI reference |
| `openspec/project.md` | Project conventions and constraints |
| `plugins/starter-plugin/` | Reference implementation (all component types) |
| `CONTRIBUTING.md` | Contribution guidelines |
| `README.md` | User-facing documentation |
| `.husky/pre-commit` | Pre-commit validation details |
| `.husky/commit-msg` | Commit message format enforcement |

---

### Installation Scopes

| Scope | Location | Use For | Version Controlled |
|-------|----------|---------|-------------------|
| **user** | `~/.claude/plugins/` | Personal plugins | No |
| **project** | `.claude/plugins/` | Team plugins | Yes |
| **local** | `.claude/plugins.local/` | Dev/testing | No (gitignored) |
| **managed** | Organization-controlled | Enterprise | Read-only |
