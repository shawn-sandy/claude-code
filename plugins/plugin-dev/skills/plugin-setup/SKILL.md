---
name: plugin-setup
description: Interactive plugin setup and scaffolding tool for Claude Code plugins. Use this skill when user asks to "create plugin", "new plugin", "scaffold plugin", "setup plugin", "initialize plugin", "add command", "add skill", "add agent", "add hook", "add MCP server", or mentions creating Claude Code plugin components.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Plugin Setup Skill

## Purpose

This skill provides an interactive, guided workflow for creating new Claude Code plugins with proper structure, validation, and marketplace integration. It automates the entire plugin setup process from scaffolding to documentation.

## When Claude Should Use This Skill

Automatically invoke this skill when the user:
- Says "create a plugin", "new plugin", "make a plugin"
- Says "setup plugin", "initialize plugin", "scaffold plugin"
- Wants to "add a command", "add a skill", "add an agent"
- Mentions "create hook", "setup MCP server"
- Asks about plugin development or structure
- Needs help with Claude Code plugin components

## Documentation Reference

**For comprehensive educational content, refer users to**: `plugins/plugin-dev/skills/plugin-setup/README.md`

README contains:
- Educational Insights (component structure, skill descriptions, path variables, hooks, security)
- Implementation Details (template adaptation, validation strategy, marketplace integration)
- Performance Notes (token efficiency, validation performance)
- Troubleshooting (common issues and solutions)

This SKILL.md focuses on **execution workflow** while README provides **user education**.

## Workflow Overview

This skill follows a 6-phase workflow:

1. **Gather Requirements** - Interactive questions about plugin details
2. **Create Structure** - Generate plugin directories and files
3. **Update Marketplace** - Register plugin in marketplace catalog
4. **Update Documentation** - Add plugin to README.md
5. **Validate Everything** - Comprehensive validation checks
6. **Provide Testing Guide** - Instructions for local testing

---

## Phase 1: Gather Requirements

Use the AskUserQuestion tool to gather all necessary information:

### Question 1: Plugin Name
```
Question: "What should we name your plugin?"
Header: "Plugin Name"
Options:
- "Enter custom name" (allow text input)
Instructions:
- Must be kebab-case (lowercase with hyphens)
- Should be descriptive and unique
- No special characters except hyphens
- Examples: code-reviewer, test-runner, api-client
```

Validate the name:
- Check if plugin already exists: `ls plugins/[name]`
- Ensure kebab-case format: only lowercase, numbers, hyphens
- If invalid, ask again with specific feedback

### Question 2: Plugin Metadata
Ask for:
- **Description**: Clear, concise description of plugin purpose
- **Author Name**: Plugin author's name
- **Author Email**: Contact email
- **Homepage**: GitHub repository or project homepage
- **Repository**: Git repository URL
- **Keywords**: Array of search keywords (comma-separated)

### Question 3: Component Selection
```
Question: "Which components would you like to include?"
Header: "Components"
MultiSelect: true
Options:
- "Commands - User-invoked slash commands"
- "Skills - Autonomous capabilities triggered by context"
- "Agents - Specialized subagents for complex tasks"
- "Hooks - Event-driven automation and validation"
- "MCP Servers - Model Context Protocol integrations"
```

Store selected components for Phase 2.

---

## Phase 2: Create Plugin Structure

### Step 2.1: Create Base Directories
```bash
mkdir -p plugins/[plugin-name]/.claude-plugin
```

### Step 2.2: Generate plugin.json

Read the starter-plugin manifest as reference:
```bash
Read: /Users/shawnsandy/devbox/claude-code/plugins/starter-plugin/.claude-plugin/plugin.json
```

Create plugin.json with gathered metadata:
```json
{
  "name": "[plugin-name]",
  "version": "1.0.0",
  "description": "[user-provided-description]",
  "author": {
    "name": "[author-name]",
    "email": "[author-email]"
  },
  "homepage": "[homepage-url]",
  "repository": "[repository-url]",
  "license": "MIT",
  "keywords": ["[keyword1]", "[keyword2]", "..."]
}
```

Write to: `plugins/[plugin-name]/.claude-plugin/plugin.json`

### Step 2.3: Create Selected Components

For each selected component type, create appropriate structure:

#### If "Commands" Selected:

1. Create directory: `mkdir -p plugins/[plugin-name]/commands`
2. Read starter template: `plugins/starter-plugin/commands/example.md`
3. Adapt template with:
   - Update `description` to match plugin purpose
   - Customize `argument-hint` if command accepts parameters
   - Set `allowed-tools` based on security requirements
   - Replace example content with plugin-specific instructions
   - Add usage examples relevant to this command
4. Write to: `plugins/[plugin-name]/commands/example-command.md`

#### If "Skills" Selected:

1. Create directory: `mkdir -p plugins/[plugin-name]/skills/example-skill`
2. Read starter template: `plugins/starter-plugin/skills/example-skill/SKILL.md`
3. Adapt SKILL.md with:
   - Update `name` to match skill name
   - Update `description` with WHAT it does AND WHEN to use (critical for triggering)
   - Set `allowed-tools` based on security requirements
   - Customize purpose and instructions for the plugin
   - Add specific trigger keywords and scenarios
4. Write to: `plugins/[plugin-name]/skills/example-skill/SKILL.md`

**Optional README for Skills:**

Use AskUserQuestion to ask: "Would you like to include a README.md for this skill?"
- Options: "Yes - Include comprehensive README.md" or "No - SKILL.md only"
- Recommended for: Complex skills with multiple features or configuration
- Simple skills may not need separate README

If "Yes" selected:
1. Read README template: `templates/skill-readme-template.md` or `plugins/plugin-dev/skills/plugin-setup/README.md` as reference
2. Adapt README with:
   - Skill overview and activation triggers
   - Feature list specific to this skill
   - Usage examples showing common scenarios
   - Allowed tools and their purposes
   - Troubleshooting section
   - Version history
3. Write to: `plugins/[plugin-name]/skills/example-skill/README.md`

#### If "Agents" Selected:

1. Create directory: `mkdir -p plugins/[plugin-name]/agents`
2. Read starter template: `plugins/starter-plugin/agents/example-agent.md`
3. Adapt template with:
   - Update `name` and `description` for agent purpose
   - Set `tools` list (restrict to needed tools)
   - Choose `model` (inherit, sonnet, opus, haiku)
   - Set `permissionMode` (auto, ask, or omit)
   - Define agent's role and responsibilities
   - Specify systematic approach/phases
   - Add completion criteria and report format
4. Write to: `plugins/[plugin-name]/agents/example-agent.md`

#### If "Hooks" Selected:

1. Create directory: `mkdir -p plugins/[plugin-name]/hooks/scripts`
2. Read starter templates:
   - `plugins/starter-plugin/hooks/hooks.json`
   - `plugins/starter-plugin/hooks/scripts/example-hook.sh`
3. Adapt hooks.json with:
   - Update description for plugin purpose
   - Choose hook events (PreToolUse, PostToolUse, SessionStart, etc.)
   - Set tool matchers (regex for which tools trigger hooks)
   - Use `${CLAUDE_PLUGIN_ROOT}` for all script paths
   - Configure timeouts (10-30s recommended)
4. Write to: `plugins/[plugin-name]/hooks/hooks.json`
5. Adapt hook scripts with:
   - Add plugin-specific validation or automation logic
   - Use environment variables (TOOL_NAME, TOOL_INPUT, etc.)
   - Proper exit codes (0=success, 1=block)
   - Include shebang `#!/bin/bash`
6. Write to: `plugins/[plugin-name]/hooks/scripts/[hook-name].sh`
7. Make executable: `chmod +x plugins/[plugin-name]/hooks/scripts/*.sh`

#### If "MCP Servers" Selected:

1. Read starter template: `plugins/starter-plugin/.mcp.json`
2. Adapt .mcp.json with:
   - Update server names for plugin purpose
   - Set server commands/URLs using `${CLAUDE_PLUGIN_ROOT}`
   - Configure transport type (stdio, sse, http, websocket)
   - Define environment variables with defaults: `${VAR:-default}`
   - Add server-specific arguments
3. Write to: `plugins/[plugin-name]/.mcp.json`
4. Create MCP-SETUP.md with:
   - List of required environment variables
   - Setup instructions for users
   - Testing procedures for MCP servers
5. Write to: `plugins/[plugin-name]/MCP-SETUP.md`

---

## Phase 3: Update Marketplace Catalog

Read the current marketplace catalog:
```bash
Read: .claude-plugin/marketplace.json
```

Parse the JSON and add new plugin entry to the "plugins" array:
```json
{
  "name": "[plugin-name]",
  "source": "./plugins/[plugin-name]",
  "description": "[brief-description]",
  "version": "1.0.0"
}
```

Important: Maintain proper JSON formatting with commas between entries.

Write updated marketplace.json back to: `.claude-plugin/marketplace.json`

---

## Phase 4: Update Documentation

Read the current README.md:
```bash
Read: README.md
```

Find the "Available Plugins" section and add new plugin documentation:

```markdown
### [Plugin Name]

[Plugin description]

**Components:**
- Commands: [list if included, or "None"]
- Skills: [list if included, or "None"]
- Agents: [list if included, or "None"]
- Hooks: [list if included, or "None"]
- MCP: [list if included, or "None"]

**Installation:**
\`\`\`bash
/plugin marketplace add shawnsandy/claude-code
/plugin install [plugin-name]@claude-code-marketplace
\`\`\`

**Usage:**
[Basic usage examples for each component type]
```

Write updated README.md back to: `README.md`

---

## Phase 5: Comprehensive Validation

Run validation checks to ensure plugin is properly configured:

### Validation 5.1: JSON Syntax
```bash
# Validate marketplace.json
jq empty .claude-plugin/marketplace.json

# Validate plugin.json
jq empty plugins/[plugin-name]/.claude-plugin/plugin.json

# If hooks included, validate hooks.json
jq empty plugins/[plugin-name]/hooks/hooks.json

# If MCP included, validate .mcp.json
jq empty plugins/[plugin-name]/.mcp.json
```

If any JSON validation fails, show error and fix the syntax.

### Validation 5.2: YAML Frontmatter
For each component with frontmatter (commands, skills, agents):
- Read the file
- Check that YAML frontmatter is properly formatted
- Verify required fields are present:
  - Commands: `description` (required)
  - Skills: `name`, `description` (both required)
  - Agents: `name`, `description` (both required)

### Validation 5.3: Hook Scripts
If hooks included:
```bash
# Verify scripts are executable
ls -la plugins/[plugin-name]/hooks/scripts/

# If not executable, make them executable
chmod +x plugins/[plugin-name]/hooks/scripts/*.sh

# Validate bash syntax
bash -n plugins/[plugin-name]/hooks/scripts/*.sh
```

### Validation 5.4: Directory Structure
Verify:
- Components are at plugin root, NOT in `.claude-plugin/`
- Correct: `plugins/[name]/commands/`
- Incorrect: `plugins/[name]/.claude-plugin/commands/`

### Validation 5.5: Naming Conventions
Verify all names use kebab-case:
- Plugin name
- Command filenames (without .md)
- Skill directory names
- Agent filenames (without .md)

### Validation 5.6: Path Variables
Check that all paths use `${CLAUDE_PLUGIN_ROOT}`:
- In hooks.json
- In .mcp.json
- No hardcoded absolute paths

Report validation results to user with specific issues if any fail.

---

## Phase 6: Provide Testing Guide

After successful validation, provide testing instructions:

```markdown
## Testing Your New Plugin

Your plugin has been created successfully! Here's how to test it:

### 1. Add Marketplace Locally
\`\`\`bash
/plugin marketplace add /Users/shawnsandy/devbox/claude-code
\`\`\`

### 2. Verify Marketplace
\`\`\`bash
/plugin marketplace list
\`\`\`
You should see "claude-code-marketplace" in the list.

### 3. Install Your Plugin
\`\`\`bash
/plugin install [plugin-name]@claude-code-marketplace
\`\`\`

### 4. Verify Installation
\`\`\`bash
/plugin list
/plugin info [plugin-name]
\`\`\`

### 5. Test Components

[If commands included:]
**Commands:**
\`\`\`bash
/example-command [arguments]
\`\`\`

[If skills included:]
**Skills:**
Skills trigger automatically. Try asking: "[example trigger phrase]"

[If agents included:]
**Agents:**
Agents are launched via Task tool when needed for [specific scenario].

[If hooks included:]
**Hooks:**
Hooks run automatically on events. Try [action that triggers hook].

[If MCP included:]
**MCP Servers:**
See MCP-SETUP.md in the plugin directory for configuration instructions.

### Next Steps

1. Customize the example components for your use case
2. Update descriptions to match your plugin's purpose
3. Test thoroughly with different scenarios
4. Update documentation with specific examples
5. Consider creating additional components as needed

### File Locations

Your plugin files are located at:
- Plugin manifest: `plugins/[plugin-name]/.claude-plugin/plugin.json`
- Commands: `plugins/[plugin-name]/commands/`
- Skills: `plugins/[plugin-name]/skills/`
- Agents: `plugins/[plugin-name]/agents/`
- Hooks: `plugins/[plugin-name]/hooks/`
- MCP: `plugins/[plugin-name]/.mcp.json`

### Reference Documentation

- Starter Plugin: `plugins/starter-plugin/` - Complete examples
- Project Guide: `CLAUDE.md` - Architecture and patterns
- Official Docs: https://code.claude.com/docs/en/plugins-reference
```

---

## Important Notes

### Error Handling
- If plugin already exists, ask user to choose different name or add to existing
- If invalid name format, explain kebab-case requirement and ask again
- If JSON validation fails, show error and fix syntax automatically
- If hook scripts not executable, run `chmod +x` automatically

### Educational Guidance
- For detailed insights on component structure, skill descriptions, path variables, hooks, and security, refer users to the comprehensive README.md
- README contains: Educational Insights, Implementation Details, Performance Notes sections

### Reference Files
Always consult these reference implementations:
- `plugins/starter-plugin/` - Complete working examples
- `.claude-plugin/marketplace.json` - Marketplace structure
- `CLAUDE.md` - Project conventions and patterns
- Plugin-specific README.md - For educational insights and troubleshooting
