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
```bash
mkdir -p plugins/[plugin-name]/commands
```

Read starter example:
```bash
Read: plugins/starter-plugin/commands/example.md
```

Create example command file adapted for the new plugin:
```markdown
---
description: Example command for [plugin-name]
argument-hint: [optional-message]
allowed-tools: Read, Write, Bash(git:*)
---

# Example Command for [Plugin Name]

This is an example command. When a user types /example-command, this markdown content becomes the prompt.

## What to do:
1. [Customize instructions for your command]
2. [Add specific steps]
3. [Define expected behavior]

## Example Usage:
/example-command [arguments]
```

Write to: `plugins/[plugin-name]/commands/example-command.md`

#### If "Skills" Selected:
```bash
mkdir -p plugins/[plugin-name]/skills/example-skill
```

Read starter example:
```bash
Read: plugins/starter-plugin/skills/example-skill/SKILL.md
```

Create example skill adapted for the new plugin:
```markdown
---
name: example-skill
description: Example skill for [plugin-name]. Use this skill when user asks about [trigger keywords] or mentions [specific use cases].
allowed-tools: Read, Grep, Glob
---

# Example Skill for [Plugin Name]

## Purpose
This skill demonstrates how to create a skill for [plugin-name].

## When Claude Should Use This Skill
Claude should invoke this skill when:
- User asks about [specific functionality]
- User mentions keywords like "[keyword1]", "[keyword2]"
- Context suggests [specific scenario]

## Instructions
When this skill is invoked:
1. [Step 1 - what to do]
2. [Step 2 - how to analyze]
3. [Step 3 - what to provide]

## Best Practices
- [Practice 1]
- [Practice 2]
```

Write to: `plugins/[plugin-name]/skills/example-skill/SKILL.md`

**Ask about README Generation:**

Use AskUserQuestion to ask if skill should include README:
```
Question: "Would you like to include a README.md for this skill?"
Header: "Skill README"
Options:
- "Yes - Include comprehensive README.md"
- "No - SKILL.md only (suitable for simple skills)"
Instructions:
- README recommended for skills with multiple features or configuration
- README provides user-facing documentation separate from system prompt
- Simple, single-purpose skills may not need separate README
```

If user selects "Yes", create README.md adapted from template:
```markdown
# Example Skill for [Plugin Name]

Brief overview of what this skill does and its purpose.

## When This Skill Activates

Claude automatically invokes this skill when you:
- Say "[trigger phrase 1]"
- Mention "[keyword 1]", "[keyword 2]"
- Request help with [specific task]

## Features

- Feature 1: [Description based on skill purpose]
- Feature 2: [Description]
- Feature 3: [Description]

## Usage Examples

### Example 1: [Scenario Name]

\`\`\`
You: "[Example user request]"

Claude: [What the skill does in this scenario]
\`\`\`

### Example 2: [Another Scenario]

\`\`\`
You: "[Another example]"

Claude: [Expected behavior]
\`\`\`

## Allowed Tools

This skill uses these tools:
- \`Read\` - [Purpose for this skill]
- \`Grep\` - [Purpose for this skill]
- \`Glob\` - [Purpose for this skill]

## Configuration

[Document any configuration options, or note "No configuration required"]

## Troubleshooting

### Issue: Skill Not Triggering

**Problem**: The skill doesn't activate when expected

**Solutions**:
- Verify plugin is installed: \`/plugin list\`
- Check trigger keywords match your request
- Try more explicit phrases from "When This Skill Activates" section

## Related Documentation

- [Official Plugin Reference](https://code.claude.com/docs/en/plugins-reference)
- [Starter Plugin Examples](../../../plugins/starter-plugin/)
- [Project CLAUDE.md](../../../CLAUDE.md)

## Version History

### v1.0.0 (YYYY-MM-DD)
- Initial release
- [Key feature 1]
- [Key feature 2]
```

Write to: `plugins/[plugin-name]/skills/example-skill/README.md`

#### If "Agents" Selected:
```bash
mkdir -p plugins/[plugin-name]/agents
```

Read starter example:
```bash
Read: plugins/starter-plugin/agents/example-agent.md
```

Create example agent adapted for the new plugin:
```markdown
---
name: example-agent
description: Example agent for [plugin-name] - specialized subagent for [specific purpose]
tools: Read, Grep, Glob, Bash
model: inherit
permissionMode: auto
---

# Example Agent for [Plugin Name]

You are a specialized agent that [define purpose and role].

## Your Responsibilities

When launched, you should:
1. [Primary responsibility]
2. [Secondary responsibility]
3. [Final responsibility]

## Approach

Follow this systematic approach:
1. **[Phase 1 Name]**: [What to do in phase 1]
2. **[Phase 2 Name]**: [What to do in phase 2]
3. **[Phase 3 Name]**: [What to do in phase 3]

## Completion Criteria

You are done when:
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

## Report Format

Provide your final report in this format:
- **Summary**: [Brief overview]
- **Findings**: [Key findings]
- **Recommendations**: [Actionable recommendations]
```

Write to: `plugins/[plugin-name]/agents/example-agent.md`

#### If "Hooks" Selected:
```bash
mkdir -p plugins/[plugin-name]/hooks/scripts
```

Read starter examples:
```bash
Read: plugins/starter-plugin/hooks/hooks.json
Read: plugins/starter-plugin/hooks/scripts/example-hook.sh
```

Create hooks.json adapted for the new plugin:
```json
{
  "description": "Example hooks for [plugin-name] validation and automation",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before modifying files, ensure changes align with [plugin-name] best practices and conventions."
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/post-write.sh",
            "args": ["${TOOL_NAME}", "${TOOL_INPUT}"],
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

Write to: `plugins/[plugin-name]/hooks/hooks.json`

Create example hook script:
```bash
#!/bin/bash
# Example hook script for [plugin-name]
# This script runs at session start

# Available environment variables:
# - TOOL_NAME: Name of the tool being used
# - TOOL_INPUT: JSON input to the tool
# - TOOL_OUTPUT: JSON output from tool (PostToolUse only)
# - CLAUDE_PLUGIN_ROOT: Absolute path to plugin directory
# - CLAUDE_PROJECT_DIR: Absolute path to project directory

echo "[plugin-name] hook: Session started successfully"

# Add your validation or automation logic here

# Exit codes:
# 0 = Success (allow operation to continue)
# 1 = Failure (block operation for PreToolUse hooks)

exit 0
```

Write to: `plugins/[plugin-name]/hooks/scripts/session-start.sh`

Make scripts executable:
```bash
chmod +x plugins/[plugin-name]/hooks/scripts/*.sh
```

#### If "MCP Servers" Selected:
Read starter example:
```bash
Read: plugins/starter-plugin/.mcp.json
```

Create .mcp.json adapted for the new plugin:
```json
{
  "_comment": "Example MCP server configurations for [plugin-name]",

  "example-stdio-server": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/example-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config/server.json"],
    "env": {
      "API_KEY": "${API_KEY}",
      "LOG_LEVEL": "${LOG_LEVEL:-info}",
      "TIMEOUT": "${TIMEOUT:-30}"
    }
  },

  "example-sse-server": {
    "transport": "sse",
    "url": "http://localhost:3000/sse",
    "env": {
      "AUTH_TOKEN": "${AUTH_TOKEN}"
    }
  }
}
```

Write to: `plugins/[plugin-name]/.mcp.json`

Create README for MCP setup:
```markdown
# MCP Server Setup for [Plugin Name]

## Required Environment Variables

Before using MCP servers in this plugin, set these environment variables:

- `API_KEY`: Your API key for the service
- `AUTH_TOKEN`: Authentication token (optional)
- `LOG_LEVEL`: Logging level (default: info)
- `TIMEOUT`: Request timeout in seconds (default: 30)

## Setup Instructions

1. Set environment variables in your shell:
   \`\`\`bash
   export API_KEY="your-api-key"
   export AUTH_TOKEN="your-token"
   \`\`\`

2. Install the plugin with MCP support

3. MCP servers will automatically connect when needed

## Testing MCP Servers

[Add specific testing instructions for your MCP servers]
```

Write to: `plugins/[plugin-name]/MCP-SETUP.md`

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

## Educational Insights

Throughout the process, provide these key insights:

### Insight 1: Component Directory Structure
```
★ Insight ─────────────────────────────────────
Component directories MUST be at plugin root level, not inside `.claude-plugin/`.

Correct:   plugins/my-plugin/commands/
Incorrect: plugins/my-plugin/.claude-plugin/commands/

This is the most common mistake in plugin development!
─────────────────────────────────────────────────
```

### Insight 2: Skill Descriptions
```
★ Insight ─────────────────────────────────────
Skill descriptions must include TWO critical parts:

1. WHAT it does: "Analyzes code quality"
2. WHEN to use: "Use when user asks to review code or check quality"

Without the WHEN part, Claude won't know when to trigger the skill autonomously.
─────────────────────────────────────────────────
```

### Insight 3: Path Variables
```
★ Insight ─────────────────────────────────────
Always use ${CLAUDE_PLUGIN_ROOT} for plugin-relative paths in:
- hooks.json command paths
- .mcp.json server paths

This ensures the plugin works regardless of where it's installed:
- User scope: ~/.claude/plugins/
- Project scope: .claude/plugins/
- Local scope: .claude/plugins.local/

Hardcoded paths will break portability!
─────────────────────────────────────────────────
```

### Insight 4: Hook Scripts
```
★ Insight ─────────────────────────────────────
Hook scripts must be executable (chmod +x) and use proper exit codes:

- Exit 0: Success (allow operation to continue)
- Exit 1: Failure (block operation for PreToolUse hooks)

Environment variables available in hooks:
- TOOL_NAME, TOOL_INPUT, TOOL_OUTPUT
- CLAUDE_PLUGIN_ROOT, CLAUDE_PROJECT_DIR
─────────────────────────────────────────────────
```

### Insight 5: Security with Tool Restrictions
```
★ Insight ─────────────────────────────────────
Use allowed-tools to restrict component capabilities:

- Read-only: allowed-tools: Read, Grep, Glob
- File modification: allowed-tools: Read, Write, Edit
- Git only: allowed-tools: Bash(git:*)
- Full access: omit allowed-tools (use carefully!)

This follows the principle of least privilege for security.
─────────────────────────────────────────────────
```

---

## Error Handling

If issues occur during setup:

### Plugin Already Exists
```
The plugin "[plugin-name]" already exists. Would you like to:
1. Choose a different name
2. Add components to existing plugin
3. Cancel setup
```

### Invalid Plugin Name
```
Plugin name must be kebab-case (lowercase with hyphens only).
Examples: code-reviewer, api-client, test-runner

Please provide a valid plugin name.
```

### JSON Validation Failure
```
JSON validation failed for [file-path]:
[error message]

I'll fix this syntax error and try again.
```

### Hook Script Not Executable
```
Hook scripts are not executable. Making them executable now:
chmod +x plugins/[plugin-name]/hooks/scripts/*.sh
```

---

## Summary

This skill provides a complete, automated workflow for plugin creation:

1. ✅ Interactive requirement gathering
2. ✅ Proper directory structure creation
3. ✅ Component scaffolding with examples
4. ✅ Marketplace registration
5. ✅ Documentation updates
6. ✅ Comprehensive validation
7. ✅ Local testing instructions
8. ✅ Educational insights throughout

The result is a fully functional, validated plugin ready for customization and testing.

## Reference Files

Always consult these reference implementations:
- `/plugins/starter-plugin/` - Complete working examples
- `/.claude-plugin/marketplace.json` - Marketplace structure
- `/CLAUDE.md` - Project conventions and patterns
- `https://code.claude.com/docs/en/plugins-reference` - Official documentation
