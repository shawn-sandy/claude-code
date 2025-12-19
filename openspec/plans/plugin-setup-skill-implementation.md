# Plugin Setup Skill Implementation Plan

**Date**: 2025-12-18
**Status**: Approved - Ready for Implementation

## Overview

Create an interactive skill that guides users through setting up new Claude Code plugins with comprehensive validation and automation.

## User Requirements

Based on user selections:

- **Scope**: Interactive - ask user what components to include during execution
- **Automation**: Fully automated - update marketplace.json, README.md, and run validation
- **Triggers**: "create plugin", "setup plugin", and component addition keywords
- **Validation**: Comprehensive - JSON validation, permissions, structure, local installation test

## Implementation Steps

### 1. Create Skill Directory Structure

- Create `plugins/plugin-dev/skills/plugin-setup/` directory
- Add `SKILL.md` with frontmatter and detailed instructions

### 2. Skill Configuration

**Frontmatter:**

- **Name**: `plugin-setup`
- **Description**: Includes trigger keywords: "create plugin", "new plugin", "scaffold plugin", "setup plugin", "initialize plugin", "add command", "add skill", "add agent", "add hook", "add MCP"
- **Allowed Tools**: `Read`, `Write`, `Edit`, `Bash`, `Glob`, `Grep`, `AskUserQuestion`

### 3. Skill Workflow

The skill will:

#### Phase 1: Gather Requirements

Ask user interactively using AskUserQuestion:

- Plugin name (validate kebab-case)
- Description and metadata (author, homepage, repository)
- Which components to include (commands/skills/agents/hooks/MCP)

#### Phase 2: Create Plugin Structure

- Create `plugins/[name]/.claude-plugin/` directory
- Generate `plugin.json` with validated metadata
- Create selected component directories at plugin root
- Add example/template files for each selected component type:
  - Commands: Create `commands/example-command.md` with full frontmatter
  - Skills: Create `skills/example-skill/SKILL.md` with trigger description
  - Agents: Create `agents/example-agent.md` with system prompt
  - Hooks: Create `hooks/hooks.json` and `hooks/scripts/example-hook.sh`
  - MCP: Create `.mcp.json` with server templates

#### Phase 3: Update Marketplace

- Read `.claude-plugin/marketplace.json`
- Add new plugin entry with name, source, description, version
- Validate JSON syntax with `jq`
- Write updated marketplace.json

#### Phase 4: Update Documentation

- Read `README.md`
- Add plugin section under "Available Plugins"
- Include:
  - Plugin name and description
  - Component list (what's included)
  - Installation command
  - Basic usage examples
- Write updated README.md

#### Phase 5: Comprehensive Validation

Execute validation checks:

```bash
# JSON validation
jq empty .claude-plugin/marketplace.json
jq empty plugins/[name]/.claude-plugin/plugin.json
jq empty plugins/[name]/hooks/hooks.json  # if hooks included
jq empty plugins/[name]/.mcp.json  # if MCP included

# Hook script permissions (if hooks included)
chmod +x plugins/[name]/hooks/scripts/*.sh
bash -n plugins/[name]/hooks/scripts/*.sh

# Structure verification
# Verify components at plugin root, not in .claude-plugin/
```

#### Phase 6: Local Testing Guide

Provide commands to user:

```bash
# Add marketplace from local filesystem
/plugin marketplace add /path/to/claude-code

# Install plugin for testing
/plugin install [plugin-name]@claude-code-marketplace

# Test components
/command-name [args]  # for commands
# Skills trigger automatically
# Agents via Task tool
```

### 4. Reference Implementation

Use `plugins/starter-plugin/` as template source:

- Read starter-plugin component files
- Adapt examples for new plugin
- Maintain path variable patterns (`${CLAUDE_PLUGIN_ROOT}`)
- Follow established naming conventions (kebab-case)
- Preserve security patterns (allowed-tools restrictions)

### 5. Educational Insights

Include explanations about:

- **Directory Structure**: Why components must be at plugin root, not in `.claude-plugin/`
- **Path Variables**: Importance of `${CLAUDE_PLUGIN_ROOT}` for portability
- **Skill Descriptions**: Must include "when to use" trigger conditions
- **Security**: Tool restrictions prevent unauthorized operations
- **Naming**: Kebab-case ensures consistency and compatibility
- **Hook Scripts**: Must be executable and use proper exit codes

## Files to Create/Modify

### New Files

1. `plugins/plugin-dev/skills/plugin-setup/SKILL.md` - Main skill definition with complete workflow

### Modified Files During Execution

1. `.claude-plugin/marketplace.json` - Add new plugin entry
2. `README.md` - Add plugin documentation
3. Plugin-specific files created based on user selections

## Component Templates

### plugin.json Template

```json
{
  "name": "[kebab-case-name]",
  "version": "1.0.0",
  "description": "[description]",
  "author": {
    "name": "[author]",
    "email": "[email]"
  },
  "homepage": "[homepage-url]",
  "repository": "[repo-url]",
  "license": "MIT",
  "keywords": ["[keyword1]", "[keyword2]"]
}
```

### Command Template (commands/example-command.md)

```yaml
---
description: Example command demonstrating command structure
argument-hint: [optional-message]
allowed-tools: Read, Write, Bash(git:*)
---

# Example Command

When user types /example-command, this content becomes the prompt.

## What to do:
[Instructions for the command]
```

### Skill Template (skills/example-skill/SKILL.md)

```yaml
---
name: example-skill
description: What this skill does. Use when user asks about [trigger keywords] or mentions [use cases].
allowed-tools: Read, Grep, Glob
---

# Example Skill System Prompt

You are an autonomous skill that [purpose].

## When to activate:
[Conditions that trigger this skill]

## How to help:
[Step-by-step process]
```

### Agent Template (agents/example-agent.md)

```yaml
---
name: example-agent
description: Purpose and when Claude should launch this agent
tools: Read, Grep, Glob, Bash
model: inherit
---

# Example Agent System Prompt

You are a specialized agent for [purpose].

## Your Responsibilities:
[What this agent does]

## Approach:
1. [Step 1]
2. [Step 2]

## Completion:
You're done when:
- [Criterion 1]
- [Criterion 2]
```

### Hooks Template (hooks/hooks.json)

```json
{
  "description": "Example hooks for validation and logging",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before writing files, ensure proper formatting and validation."
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
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/example-hook.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Hook Script Template (hooks/scripts/example-hook.sh)

```bash
#!/bin/bash
# Example hook script

# Available environment variables:
# - TOOL_NAME: Tool being used
# - TOOL_INPUT: Input to tool
# - CLAUDE_PLUGIN_ROOT: Plugin directory
# - CLAUDE_PROJECT_DIR: Project directory

echo "Hook executed successfully"

# Exit 0 = success, Exit 1 = block operation
exit 0
```

### MCP Template (.mcp.json)

```json
{
  "example-stdio-server": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/example-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "API_KEY": "${API_KEY}",
      "LOG_LEVEL": "${LOG_LEVEL:-info}"
    }
  }
}
```

## Validation Checklist

After skill creation:

- [ ] Skill YAML frontmatter is valid
- [ ] Description includes all trigger keywords
- [ ] Workflow handles all component types
- [ ] Uses `${CLAUDE_PLUGIN_ROOT}` pattern correctly
- [ ] Includes comprehensive validation steps
- [ ] Provides clear educational insights
- [ ] References official documentation URL
- [ ] Templates match starter-plugin patterns
- [ ] Security patterns (allowed-tools) are included

## Success Criteria

- ✅ Skill triggers automatically on "create plugin", "setup plugin" keywords
- ✅ Interactively asks which components to include via AskUserQuestion
- ✅ Creates valid plugin structure with all selected components
- ✅ Updates marketplace.json automatically
- ✅ Updates README.md automatically
- ✅ Runs comprehensive validation (JSON, permissions, structure)
- ✅ Provides local testing instructions
- ✅ Works for both new plugins and adding components to existing plugins
- ✅ Uses starter-plugin as reference implementation
- ✅ Maintains project conventions (kebab-case, path variables)

## Reference Documentation

- Official Plugin Reference: <https://code.claude.com/docs/en/plugins-reference>
- Project CLAUDE.md: `/path/to/claude-code/CLAUDE.md`
- Starter Plugin: `/path/to/claude-code/plugins/starter-plugin/`
- OpenSpec Agents: `/path/to/claude-code/openspec/AGENTS.md`

## Notes

- Skill should check if plugin-dev plugin exists before adding to it
- If plugin-dev doesn't exist, create it first with minimal structure
- All templates should include inline comments explaining key concepts
- Validation should be thorough but user-friendly with clear error messages
- Educational insights should be provided throughout the process, not just at the end
