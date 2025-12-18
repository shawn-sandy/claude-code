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

This is a **Claude Code Plugin Marketplace** - a multi-plugin repository that distributes plugins, commands, skills, agents, and hooks for Claude Code. The marketplace uses a catalog-based architecture where `.claude-plugin/marketplace.json` defines all available plugins.

**Key Characteristics:**
- Pure distribution repository (no build/test commands)
- Content validated via JSON/YAML validation and local testing
- OpenSpec-driven for significant changes
- Reference implementation via `starter-plugin`

## Architecture

### Marketplace System

**Two-Level Structure:**
1. **Marketplace Level** (`.claude-plugin/marketplace.json`): Catalog of all plugins with metadata
2. **Plugin Level** (`plugins/*/.claude-plugin/plugin.json`): Individual plugin manifests

**Auto-Discovery Pattern:**
Claude Code automatically discovers components in standard directories:
- `commands/*.md` → Slash commands (filename becomes command name)
- `skills/*/SKILL.md` → Autonomous skills (directory name becomes skill name)
- `agents/*.md` → Specialized agents (filename becomes agent name)
- `hooks/hooks.json` → Event-driven automation configuration
- `.mcp.json` → Model Context Protocol server configurations

**CRITICAL**: Component directories MUST be at plugin root (`plugins/my-plugin/commands/`), NOT inside `.claude-plugin/` directory. Custom paths in `plugin.json` supplement (don't replace) default auto-discovery directories.

### Component Types & When to Use Each

**Commands** (`commands/*.md`):
- User explicitly invokes with `/command-name`
- Use for: User-triggered workflows, builds, deployments, git operations
- Structure: Markdown file with YAML frontmatter
- Key field: `allowed-tools` restricts which tools the command can use

**Skills** (`skills/*/SKILL.md`):
- Claude autonomously triggers based on context
- Use for: Capabilities that enhance Claude's abilities without user invocation
- **Critical**: Description must include BOTH "what it does" AND "when to use it"
- Supporting files can live in the skill's directory
- **Best Practice**: Include `README.md` for complex skills with multiple features or configuration options

**Agents** (`agents/*.md`):
- Launched via Task tool for complex, isolated tasks
- Use for: Multi-step workflows, domain expertise, separate context needed
- Structure: Markdown file with frontmatter + system prompt
- Key fields: `tools` (restrict access), `model` (inherit/sonnet/opus/haiku), `permissionMode`

**Hooks** (`hooks/hooks.json`):
- Event-driven automation responding to tool use and session events
- Use for: Validation, logging, enforcing best practices
- Two types: `prompt` (inject instructions) and `command` (execute scripts)
- Available events: PreToolUse, PostToolUse, SessionStart, UserPromptSubmit, SessionEnd, Stop, SubagentStop, PermissionRequest, Notification, PreCompact

**MCP Servers** (`.mcp.json`):
- External service integrations via Model Context Protocol
- Use for: API access, database connections, external tools
- Path variables: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PROJECT_DIR}`, `${VAR:-default}`

### Critical Architecture Patterns

**Path Management:**
- Always use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths in hooks and MCP configs
- Never use hardcoded absolute paths
- Example in hooks.json: `"command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/example-hook.sh"`
- Example in .mcp.json: `"args": ["${CLAUDE_PLUGIN_ROOT}/server.js"]`

**Naming Convention:**
- All names: kebab-case (lowercase with hyphens)
- Plugin names must be unique within marketplace
- Component names derived from filenames/directories (without extensions)
- Examples: `code-reviewer`, `test-runner`, `example-skill`

**Frontmatter Requirements:**
- Commands: `description` (required), `argument-hint` (optional), `allowed-tools` (optional), `model` (optional)
- Skills: `name` (required), `description` (required - must include when to use), `allowed-tools` (optional)
- Agents: `name` (required), `description` (required), `tools` (optional), `model` (optional), `permissionMode` (optional)

## Development Workflow

### Before You Start

**Context Checklist:**
1. Check for existing plugins that might do similar things: `ls plugins/`
2. Review `openspec list` and `openspec list --specs` to understand current work
3. Read `openspec/project.md` for project conventions
4. Study `starter-plugin` for reference implementation
5. Determine if OpenSpec proposal is needed (see decision tree below)

### OpenSpec Decision Tree

```
Is this change...
├─ Bug fix (restoring intended behavior)? → Fix directly, no proposal
├─ Typo/formatting/comment change? → Fix directly, no proposal
├─ Adding dependency (non-breaking)? → Fix directly, no proposal
├─ Adding new plugin? → Create OpenSpec proposal
├─ Adding new component type to existing plugin? → Create OpenSpec proposal
├─ Breaking change to plugin structure? → Create OpenSpec proposal
├─ Changing marketplace architecture? → Create OpenSpec proposal
└─ Unclear? → Create OpenSpec proposal (safer choice)
```

**Creating OpenSpec Proposals:**
When required, follow the three-stage workflow in `openspec/AGENTS.md`:

1. **Stage 1 - Creating Change:**
   ```bash
   # Review existing work
   openspec list
   openspec list --specs

   # Choose unique change-id (kebab-case, verb-led)
   # Examples: add-testing-plugin, update-hook-validation, refactor-marketplace-catalog

   # Scaffold proposal
   mkdir -p openspec/changes/[change-id]/specs/[capability]
   # Create proposal.md, tasks.md, and spec deltas

   # Validate before sharing
   openspec validate [change-id] --strict
   ```

2. **Stage 2 - Implementation:**
   - Read proposal.md, design.md (if exists), tasks.md
   - Implement tasks sequentially
   - Mark tasks complete as you finish them
   - Wait for approval before starting

3. **Stage 3 - Archiving:**
   ```bash
   # After deployment
   openspec archive [change-id]
   # Updates specs/ and moves to archive/
   ```

### Testing Locally

```bash
# Add marketplace from local filesystem
/plugin marketplace add /Users/shawnsandy/devbox/claude-code
# Or relative path from anywhere
/plugin marketplace add ./path/to/claude-code

# Verify marketplace added
/plugin marketplace list

# Install plugin for testing
/plugin install starter-plugin@claude-code-marketplace

# Test components
/example [message]                # Test command
# Skills trigger automatically when context matches their description
# Agents launched via Task tool when you request them
```

### Adding a New Plugin

**Step 1: OpenSpec Proposal (if significant)**
If adding substantial functionality, create proposal first (see OpenSpec Decision Tree above).

**Step 2: Create Plugin Structure**
```bash
mkdir -p plugins/new-plugin/.claude-plugin
mkdir -p plugins/new-plugin/{commands,skills,agents,hooks/scripts}
```

**Step 3: Create plugin.json**
Required fields:
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
Follow structure guidelines in Component Types section above. Reference `plugins/starter-plugin/` for examples.

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
Add plugin documentation under "Available Plugins" section with:
- Plugin name and description
- Components list
- Installation command
- Usage examples

**Step 7: Validate Before Committing**
Run the validation checklist (see Validation section below).

**Step 8: Test Locally**
Install and test all components before committing.

### Validation Before Committing

**JSON/YAML Validation:**
```bash
# Validate all JSON files
jq empty .claude-plugin/marketplace.json
jq empty plugins/*/. claude-plugin/plugin.json
jq empty plugins/*/hooks/hooks.json
jq empty plugins/*/.mcp.json

# Alternative: use Python
python3 -m json.tool .claude-plugin/marketplace.json > /dev/null
```

**Frontmatter Validation:**
```bash
# Check YAML frontmatter in markdown files
# Use a YAML validator or manually verify frontmatter syntax
```

**Hook Scripts:**
```bash
# Ensure executable
chmod +x plugins/*/hooks/scripts/*.sh

# Test scripts don't have syntax errors
bash -n plugins/*/hooks/scripts/*.sh
```

**Pre-Commit Checklist:**
- [ ] All JSON files are valid (use `jq` or `python -m json.tool`)
- [ ] YAML frontmatter in all .md files is valid
- [ ] Hook scripts are executable (`chmod +x`)
- [ ] Skill descriptions include "when to use" trigger conditions
- [ ] No sensitive information (API keys, tokens) in any files
- [ ] Plugin installs locally without errors
- [ ] All components work as expected
- [ ] README.md updated with plugin documentation
- [ ] Marketplace catalog updated
- [ ] OpenSpec proposal validated if applicable (`openspec validate --strict`)

### Hook Script Development

**Environment Variables Available:**
- `TOOL_NAME`: Name of the tool being used
- `TOOL_INPUT`: JSON input to the tool
- `TOOL_OUTPUT`: JSON output from tool (PostToolUse only)
- `CLAUDE_PLUGIN_ROOT`: Absolute path to plugin directory
- `CLAUDE_PROJECT_DIR`: Absolute path to project directory

**Exit Codes:**
- `0`: Success, continue execution
- `1`: Failure, block operation (for PreToolUse hooks)

**Best Practices:**
```bash
#!/bin/bash
# Always use shebang

# Access environment variables
if [ "$TOOL_NAME" = "Write" ]; then
  # Validation logic
  echo "Validating write operation..."
fi

# Use plugin-relative paths
source "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/helpers.sh"

# Exit with appropriate code
exit 0  # Success
# exit 1  # Block operation
```

**Timeouts:**
Configure in `hooks.json`: 10-30s max for performance.

**Make Executable:**
```bash
chmod +x hooks/scripts/script.sh
```

## Key Distinctions

**Commands vs Skills vs Agents:**
- **Commands**: User types `/name` → Explicit invocation → Prompt expansion
- **Skills**: Claude decides based on context → Autonomous invocation → Enhanced capability
- **Agents**: Claude launches via Task tool → Specialized isolated execution → Multi-step workflow

**When Each Component Type is Appropriate:**
- Simple user action (build, commit, deploy) → **Command**
- Enhance Claude's abilities automatically (formatting, analysis) → **Skill**
- Complex multi-step task needing isolation (code review, audit) → **Agent**
- Automation on events (validation, logging) → **Hook**
- External service integration (API, database) → **MCP Server**

## Starter Plugin as Reference

The `starter-plugin` serves as the canonical example implementing all component types:

**Commands:**
- `commands/example.md`: Full command structure with all frontmatter options
- Demonstrates `allowed-tools`, `argument-hint`, and model selection

**Skills:**
- `skills/example-skill/SKILL.md`: Comprehensive skill with "when to use" guidance
- Shows proper description format for autonomous triggering

**Agents:**
- `agents/example-agent.md`: Agent with complete system prompt structure
- Demonstrates tool restriction and permission modes

**Hooks:**
- `hooks/hooks.json`: All hook event types with prompt and command examples
- `hooks/scripts/example-hook.sh`: Executable hook script with environment variable usage

**MCP:**
- `.mcp.json`: MCP server configuration templates with path variable examples

**Always reference these files when creating new components** - they include inline documentation and best practices that are kept up-to-date.

## Distribution

**GitHub Installation:**
Users install via:
```bash
/plugin marketplace add shawnsandy/claude-code
```

**Local Installation:**
Developers test via:
```bash
/plugin marketplace add ./path/to/repository
# Or absolute path
/plugin marketplace add /Users/username/projects/claude-code
```

**Installation Scopes:**
- **user**: `~/.claude/plugins/` - Personal plugins, user-specific
- **project**: `.claude/plugins/` - Team plugins, version controlled, shared
- **local**: `.claude/plugins.local/` - Project-specific, gitignored, not shared
- **managed**: Enterprise-controlled, read-only, organization-wide

## Special Considerations

### Security

**Tool Restrictions:**
```yaml
# In command/skill/agent frontmatter
allowed-tools: Bash(git:*), Read, Write  # Restrict to specific tools
```
- Use `allowed-tools` to limit capabilities
- `Bash(git:*)` restricts bash to git commands only
- Omitting `allowed-tools` grants full access

**Secrets Management:**
- Never commit API keys, tokens, or passwords
- Use environment variables in `.mcp.json`
- Document required env vars in plugin README
- Example: `"env": {"API_KEY": "${API_KEY}"}`

**Input Validation:**
```bash
# In hook scripts
if [[ ! "$TOOL_INPUT" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Invalid input format"
  exit 1
fi
```

**Script Review:**
- Audit all hook scripts before enabling
- Check for command injection vulnerabilities
- Validate file paths and user inputs

### Performance

**Hook Optimization:**
- Target 1-5s execution time
- Use 10-30s timeout max in `hooks.json`
- Avoid network calls in PreToolUse hooks
- Cache expensive operations

**Agent Model Selection:**
- `haiku`: Fast, simple tasks (<100 tokens)
- `sonnet` (default): Balanced, most tasks
- `opus`: Complex reasoning, multi-step workflows
- `inherit`: Use parent conversation's model

**MCP Server Efficiency:**
- Minimize dependencies
- Implement connection pooling
- Use timeouts on external calls
- Cache responses when appropriate

### Documentation

**Plugin README Requirements:**
Each plugin should document:
- Purpose and capabilities
- Installation command
- Component list (commands, skills, agents, hooks, MCP)
- Usage examples for each component
- Required environment variables (for MCP)
- Configuration options

**Frontmatter Descriptions:**
- Commands: What the command does and expected arguments
- Skills: What it does AND when Claude should use it (critical!)
- Agents: Purpose and when Claude should launch it
- Clear, concise, user-focused language

**Hook Script Comments:**
```bash
#!/bin/bash
# Purpose: Validate write operations before execution
# Environment: TOOL_NAME, TOOL_INPUT, CLAUDE_PLUGIN_ROOT
# Exit: 0=allow, 1=block
```

**Skill README Best Practices:**

For complex skills with multiple features, include a `README.md` in the skill directory. This separates user-facing documentation from the system prompt (`SKILL.md`).

**When to Include README:**
- Skill has multiple capabilities or features
- Configuration options available
- Complex usage patterns or workflows
- Troubleshooting steps frequently needed
- Public/marketplace distribution

**When README is Optional:**
- Simple, single-purpose skills
- Self-documenting functionality
- Internal/private use only
- Obvious from SKILL.md content

**Template Structure:**
```markdown
# Skill Name
## When This Skill Activates
## Features
## Usage Examples
## Configuration
## Allowed Tools
## Troubleshooting
## Version History
```

See `templates/skill-readme-template.md` for comprehensive template with inline comments and guidance.

**Examples:**
- `plugins/plugin-dev/skills/plugin-setup/README.md` - Comprehensive example
- `plugins/starter-plugin/skills/example-skill/README.md` - Reference implementation

## Troubleshooting

### Plugin Not Discovered

**Symptoms:** Plugin doesn't appear in `/plugin list`

**Solutions:**
1. Verify plugin is in `.claude-plugin/marketplace.json`
2. Check plugin path in marketplace catalog is correct
3. Ensure `plugin.json` exists at `plugins/[name]/.claude-plugin/plugin.json`
4. Validate JSON syntax in both files
5. Try removing and re-adding marketplace

### Components Not Loading

**Symptoms:** Commands/skills/agents don't work after installation

**Solutions:**
1. Verify component directories are at plugin root, NOT in `.claude-plugin/`
   - ✅ Correct: `plugins/my-plugin/commands/`
   - ❌ Wrong: `plugins/my-plugin/.claude-plugin/commands/`
2. Check filenames use kebab-case
3. Verify frontmatter YAML is valid
4. Ensure required frontmatter fields are present
5. Skills: Check description includes "when to use"

### Hook Scripts Not Executing

**Symptoms:** Hooks defined but don't run

**Solutions:**
1. Verify scripts are executable: `ls -la plugins/*/hooks/scripts/`
2. Run `chmod +x` on script files
3. Check script has valid shebang: `#!/bin/bash`
4. Test script syntax: `bash -n script.sh`
5. Verify path in `hooks.json` uses `${CLAUDE_PLUGIN_ROOT}`
6. Check hook matcher regex is correct

### Path Variable Issues

**Symptoms:** Paths not resolving, file not found errors

**Solutions:**
1. Use `${CLAUDE_PLUGIN_ROOT}` not `./` or hardcoded paths
2. Don't use `~` or `$HOME` in plugin configs
3. Verify variable syntax: `${VAR}` not `$VAR`
4. For defaults: `${VAR:-default}` syntax
5. Test path resolution by echoing in hook script

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

# Common issues:
# - Missing commas in JSON
# - Incorrect YAML indentation
# - Unquoted strings with special chars
# - Missing required frontmatter fields
```

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
openspec list                    # Active changes
openspec list --specs            # Current capabilities
openspec show [item]             # View details
openspec validate [item] --strict
openspec archive [change] --yes

# Local validation
jq empty .claude-plugin/marketplace.json
chmod +x plugins/*/hooks/scripts/*.sh
```

### File Locations

- **Marketplace catalog**: `.claude-plugin/marketplace.json`
- **Plugin manifest**: `plugins/[name]/.claude-plugin/plugin.json`
- **Commands**: `plugins/[name]/commands/*.md`
- **Skills**: `plugins/[name]/skills/*/SKILL.md`
- **Agents**: `plugins/[name]/agents/*.md`
- **Hooks**: `plugins/[name]/hooks/hooks.json`
- **Hook scripts**: `plugins/[name]/hooks/scripts/*.sh`
- **MCP config**: `plugins/[name]/.mcp.json`

### Path Variables

- `${CLAUDE_PLUGIN_ROOT}` - Absolute path to plugin directory
- `${CLAUDE_PROJECT_DIR}` - Absolute path to project directory
- `${VAR:-default}` - Environment variable with default value

### Essential Reading

- `openspec/AGENTS.md` - OpenSpec workflow and CLI
- `openspec/project.md` - Project conventions
- `plugins/starter-plugin/` - Reference implementation
- `CONTRIBUTING.md` - Contribution guidelines
- `README.md` - User documentation
