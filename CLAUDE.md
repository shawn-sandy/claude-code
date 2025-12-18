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

## Architecture

### Marketplace System

**Two-Level Structure:**
1. **Marketplace Level** (`.claude-plugin/marketplace.json`): Catalog of all plugins with metadata
2. **Plugin Level** (`plugins/*/. claude-plugin/plugin.json`): Individual plugin manifests

**Auto-Discovery Pattern:**
Claude Code automatically discovers components in standard directories:
- `commands/*.md` → Slash commands (filename becomes command name)
- `skills/*/SKILL.md` → Autonomous skills (directory name becomes skill name)
- `agents/*.md` → Specialized agents (filename becomes agent name)
- `hooks/hooks.json` → Event-driven automation configuration
- `.mcp.json` → Model Context Protocol server configurations

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

**Agents** (`agents/*.md`):
- Launched via Task tool for complex, isolated tasks
- Use for: Multi-step workflows, domain expertise, separate context needed
- Structure: Markdown file with frontmatter + system prompt
- Key fields: `tools` (restrict access), `model` (inherit/sonnet/opus/haiku), `permissionMode`

**Hooks** (`hooks/hooks.json`):
- Event-driven automation responding to tool use and session events
- Use for: Validation, logging, enforcing best practices
- Two types: `prompt` (inject instructions) and `command` (execute scripts)
- Available events: PreToolUse, PostToolUse, SessionStart, UserPromptSubmit, etc.

**MCP Servers** (`.mcp.json`):
- External service integrations via Model Context Protocol
- Use for: API access, database connections, external tools
- Path variables: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PROJECT_DIR}`, `${VAR:-default}`

### Critical Architecture Patterns

**Path Management:**
- Always use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths in hooks and MCP configs
- Component directories MUST be at plugin root, NOT inside `.claude-plugin/`
- Custom paths in plugin.json supplement (don't replace) default directories

**Naming Convention:**
- All names: kebab-case (lowercase with hyphens)
- Plugin names must be unique within marketplace
- Component names derived from filenames/directories (without extensions)

**Frontmatter Requirements:**
- Commands: `description`, `argument-hint` (optional), `allowed-tools` (optional), `model` (optional)
- Skills: `name` (required), `description` (required - must include when to use), `allowed-tools` (optional)
- Agents: `name` (required), `description` (required), `tools` (optional), `model` (optional), `permissionMode` (optional)

## Development Workflow

### Testing Locally

```bash
# Add marketplace from local filesystem
/plugin marketplace add /Users/shawnsandy/devbox/claude-code
# Or relative path
/plugin marketplace add ./path/to/claude-code

# Install plugin
/plugin install starter-plugin@claude-code-marketplace

# Test components
/example [message]  # Test command
# Skills trigger automatically when context matches
# Agents launched via Task tool
```

### Adding a New Plugin

1. **Create plugin structure:**
```bash
mkdir -p plugins/new-plugin/.claude-plugin
mkdir -p plugins/new-plugin/{commands,skills,agents,hooks/scripts}
```

2. **Create plugin.json** (required fields: name, version, description, author, license)

3. **Add components** following structure guidelines

4. **Update marketplace catalog** in `.claude-plugin/marketplace.json`:
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

5. **Update README.md** with plugin documentation under "Available Plugins"

6. **Test locally** before committing

### Validation Before Committing

- Validate all JSON files (marketplace.json, plugin.json, hooks.json, .mcp.json)
- Verify YAML frontmatter in all .md files
- Ensure hook scripts are executable (`chmod +x`)
- Check that skill descriptions include "when to use" trigger conditions
- Verify no sensitive information (API keys, tokens) in files
- Test plugin installation and component functionality locally

### Hook Script Development

When creating hook scripts (`hooks/scripts/*.sh`):
- Make executable: `chmod +x hooks/scripts/script.sh`
- Use environment variables: `TOOL_NAME`, `TOOL_INPUT`, `TOOL_OUTPUT`, `CLAUDE_PLUGIN_ROOT`, `CLAUDE_PROJECT_DIR`
- Exit codes: 0 (success/continue), 1 (failure/block)
- Keep fast (use timeouts in hooks.json: 10-30s max)
- Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths

## Key Distinctions

**Commands vs Skills vs Agents:**
- Commands: User types `/name` → Explicit invocation
- Skills: Claude decides based on context → Autonomous invocation
- Agents: Claude launches via Task tool → Specialized isolated execution

**When Each Component Type is Appropriate:**
- Simple user action → Command
- Enhance Claude's abilities automatically → Skill
- Complex multi-step task needing isolation → Agent
- Automation on events → Hook
- External service integration → MCP Server

## Starter Plugin as Reference

The `starter-plugin` serves as the canonical example:
- `commands/example.md`: Full command structure with all frontmatter options
- `skills/example-skill/SKILL.md`: Comprehensive skill with "when to use" guidance
- `agents/example-agent.md`: Agent with complete system prompt structure
- `hooks/hooks.json`: All hook event types with prompt and command examples
- `hooks/scripts/example-hook.sh`: Executable hook script with environment variable usage
- `.mcp.json`: MCP server configuration templates

Reference these files when creating new components - they include inline documentation and best practices.

## Distribution

**GitHub Installation:**
Users install via: `/plugin marketplace add shawnsandy/claude-code`

**Local Installation:**
Users/developers can test via: `/plugin marketplace add ./path/to/repository`

**Installation Scopes:**
- user: `~/.claude/plugins/` (personal)
- project: `.claude/plugins/` (team, version controlled)
- local: Project-specific, gitignored
- managed: Enterprise-controlled (read-only)

## Special Considerations

**Security:**
- Use `allowed-tools` in commands/skills/agents to restrict capabilities
- Never commit secrets - use environment variables
- Validate inputs in hook scripts
- Review hook scripts for safety before enabling

**Performance:**
- Hook scripts should be fast (10-30s timeout max)
- Choose appropriate agent models (haiku for speed, sonnet for balance, opus for complex)
- Minimize dependencies in MCP servers

**Documentation:**
- Each plugin needs README entry with components and usage examples
- Frontmatter descriptions should be clear about purpose and usage
- Hook scripts should include comments explaining environment variables
