# Claude Code Plugin Marketplace Setup Plan

**Date:** 2025-12-18
**Purpose:** Set up a multi-plugin marketplace repository for Claude Code plugins, commands, skills, agents, and hooks

---

## Overview

This plan outlines the creation of a **multi-plugin marketplace repository** that will be publicly shared on GitHub. The repository will support:

- ✅ Multiple plugins organized in a marketplace structure
- ✅ Commands (slash commands)
- ✅ Skills (autonomously triggered capabilities)
- ✅ Agents (specialized subagents)
- ✅ Hooks (event-driven automation)
- ✅ MCP server integration structure (for future use)
- ✅ GitHub public distribution

---

## Repository Structure

```
claude-code/ (current directory)
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog manifest
├── plugins/
│   └── starter-plugin/           # Example/starter plugin
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin manifest
│       ├── commands/             # Slash commands directory
│       │   └── example.md
│       ├── skills/               # Skills directory
│       │   └── example-skill/
│       │       └── SKILL.md
│       ├── agents/               # Agents directory
│       │   └── example-agent.md
│       ├── hooks/                # Hooks directory
│       │   ├── hooks.json
│       │   └── scripts/
│       │       └── example-hook.sh
│       └── .mcp.json            # MCP config (stub for future)
├── .gitignore                    # Ignore sensitive files
├── README.md                     # Installation & usage docs
├── CONTRIBUTING.md              # Guidelines for contributors
├── LICENSE                       # Open source license
└── plans/
    └── plugin-marketplace-setup.md  # This document
```

---

## Implementation Steps

### 1. Create Marketplace Manifest

**File:** `.claude-plugin/marketplace.json`

```json
{
  "name": "claude-code-marketplace",
  "description": "Collection of Claude Code plugins, commands, skills, and agents",
  "version": "1.0.0",
  "owner": {
    "name": "Your Name",
    "email": "your-email@example.com"
  },
  "pluginRoot": "./plugins",
  "plugins": [
    {
      "name": "starter-plugin",
      "source": "./plugins/starter-plugin",
      "description": "Example plugin demonstrating all component types",
      "version": "1.0.0"
    }
  ]
}
```

**Purpose:** Defines the marketplace catalog and lists all available plugins

---

### 2. Create Starter Plugin Structure

#### 2.1 Plugin Manifest

**File:** `plugins/starter-plugin/.claude-plugin/plugin.json`

```json
{
  "name": "starter-plugin",
  "version": "1.0.0",
  "description": "Example plugin with commands, skills, agents, and hooks",
  "author": {
    "name": "Your Name",
    "email": "your-email@example.com"
  },
  "homepage": "https://github.com/your-username/claude-code",
  "repository": "https://github.com/your-username/claude-code",
  "license": "MIT",
  "keywords": ["example", "starter", "template"]
}
```

#### 2.2 Example Command

**File:** `plugins/starter-plugin/commands/example.md`

```markdown
---
description: Example slash command demonstrating command structure
argument-hint: [optional-message]
allowed-tools: Bash(echo:*)
model: claude-3-5-sonnet-20241022
---

# Example Command

This is an example slash command. You can use this as a template for creating your own commands.

If the user provided an argument, echo it back. Otherwise, provide a friendly greeting.
```

#### 2.3 Example Skill

**File:** `plugins/starter-plugin/skills/example-skill/SKILL.md`

```markdown
---
name: example-skill
description: Example skill that demonstrates skill structure. Use this when the user asks about skill examples or mentions "show me a skill template".
allowed-tools: Read, Grep, Glob
---

# Example Skill

## Purpose

This skill demonstrates how to structure a Claude Code skill with proper frontmatter and instructions.

## When to Use

Claude should automatically invoke this skill when:
- User asks about skill examples
- User mentions "skill template" or "skill structure"
- Context suggests the user wants to learn about skills

## Instructions

1. Explain what skills are and how they differ from commands
2. Show the proper file structure with SKILL.md
3. Demonstrate the frontmatter format
4. Provide best practices for skill descriptions

## Best Practices

- Include clear trigger conditions in the description
- Keep skills focused on one primary capability
- Use allowed-tools to restrict tool access when appropriate
- Provide examples and usage scenarios
```

#### 2.4 Example Agent

**File:** `plugins/starter-plugin/agents/example-agent.md`

```markdown
---
name: example-agent
description: Example specialized agent that demonstrates agent structure. Use this agent when the user asks for agent examples or wants to see how agents are structured.
tools: Read, Grep, Glob, Bash
model: inherit
permissionMode: auto
---

# Example Agent System Prompt

You are a specialized agent that demonstrates the proper structure for Claude Code agents.

## Your Purpose

Help users understand how to create well-structured agents by:
1. Showing proper frontmatter configuration
2. Demonstrating clear system prompt instructions
3. Explaining agent vs skill vs command differences

## Behavior Guidelines

- Be educational and clear in your explanations
- Reference the official documentation when helpful
- Provide concrete examples
- Keep responses focused and relevant

## When You're Invoked

You should be used when:
- User explicitly asks for agent examples
- User wants to understand agent structure
- Context suggests the user is learning about the agent system
```

#### 2.5 Example Hooks Configuration

**File:** `plugins/starter-plugin/hooks/hooks.json`

```json
{
  "description": "Example hooks demonstrating event-driven automation",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before writing or editing files, ensure you've read the existing content and understand the context."
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/example-hook.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Session started with starter-plugin loaded."
          }
        ]
      }
    ]
  }
}
```

**File:** `plugins/starter-plugin/hooks/scripts/example-hook.sh`

```bash
#!/bin/bash
# Example hook script that runs after Bash tool use

echo "Example hook executed successfully"
exit 0
```

#### 2.6 MCP Configuration Stub

**File:** `plugins/starter-plugin/.mcp.json`

```json
{
  "_comment": "MCP server configurations - add your servers here",
  "_example": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/example-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "API_KEY": "${API_KEY}",
      "TIMEOUT": "${TIMEOUT:-30}"
    }
  }
}
```

---

### 3. Create Documentation

#### 3.1 README.md

**File:** `README.md`

```markdown
# Claude Code Plugin Marketplace

A collection of plugins, commands, skills, agents, and hooks for Claude Code.

## Installation

Add this marketplace to your Claude Code installation:

\`\`\`bash
/plugin marketplace add your-username/claude-code
\`\`\`

## Available Plugins

### starter-plugin

Example plugin demonstrating all component types:
- **Commands:** Example slash command with frontmatter
- **Skills:** Example skill with proper structure
- **Agents:** Example specialized agent
- **Hooks:** Event-driven automation examples
- **MCP:** Configuration structure for external services

Install:
\`\`\`bash
/plugin install starter-plugin@claude-code-marketplace
\`\`\`

## Usage

After installation, you can:
- Use slash commands: `/example [message]`
- Skills are automatically invoked by Claude based on context
- Agents can be launched via the Task tool
- Hooks run automatically on configured events

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new plugins.

## License

MIT License - See [LICENSE](LICENSE) for details.
```

#### 3.2 CONTRIBUTING.md

**File:** `CONTRIBUTING.md`

```markdown
# Contributing to Claude Code Marketplace

Thank you for contributing! This guide will help you add new plugins to the marketplace.

## Plugin Structure

Each plugin must follow this structure:

\`\`\`
plugins/your-plugin-name/
├── .claude-plugin/
│   └── plugin.json          # REQUIRED
├── commands/                 # Optional: slash commands
├── skills/                   # Optional: autonomous skills
├── agents/                   # Optional: specialized agents
├── hooks/                    # Optional: event hooks
└── .mcp.json                # Optional: MCP servers
\`\`\`

## Naming Conventions

- **Plugin names:** kebab-case (e.g., `my-awesome-plugin`)
- **Command files:** kebab-case (e.g., `my-command.md`)
- **Skill directories:** kebab-case (e.g., `my-skill/SKILL.md`)
- **Agent files:** kebab-case (e.g., `my-agent.md`)

## Required Files

### plugin.json

Every plugin MUST have `.claude-plugin/plugin.json`:

\`\`\`json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "Brief description of your plugin",
  "author": {
    "name": "Your Name",
    "email": "your-email@example.com"
  },
  "license": "MIT"
}
\`\`\`

## Adding Your Plugin

1. Create your plugin in `plugins/your-plugin-name/`
2. Add entry to `.claude-plugin/marketplace.json`:

\`\`\`json
{
  "name": "your-plugin-name",
  "source": "./plugins/your-plugin-name",
  "description": "What your plugin does",
  "version": "1.0.0"
}
\`\`\`

3. Update README.md with plugin documentation
4. Submit a pull request

## Best Practices

- **Commands:** User-invoked actions (e.g., `/deploy`, `/test`)
- **Skills:** Autonomously triggered by Claude (explain when to use in description)
- **Agents:** Specialized subagents for complex domains
- **Hooks:** Event-driven automation (PreToolUse, PostToolUse, etc.)

## Testing

Test your plugin locally before submitting:

\`\`\`bash
/plugin marketplace add ./path/to/claude-code
/plugin install your-plugin-name@claude-code-marketplace
\`\`\`

## Documentation

Include in your plugin README:
- What the plugin does
- How to use each component
- Configuration requirements
- Examples

## Questions?

Open an issue or discussion on GitHub!
```

---

### 4. Configure Git

#### 4.1 .gitignore

**File:** `.gitignore`

```gitignore
# Node modules (if using JS/TS MCP servers)
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Python (if using Python MCP servers)
__pycache__/
*.py[cod]
*$py.class
.Python
venv/
env/

# Environment variables and secrets
.env
.env.local
*.key
*.pem
credentials.json

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Local plugin overrides
*.local.md

# Build outputs
dist/
build/
*.log

# Test files
coverage/
.nyc_output/
```

#### 4.2 LICENSE

**File:** `LICENSE`

```text
MIT License

Copyright (c) 2025 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

### 5. GitHub Setup

#### 5.1 Making Repository Public

1. Go to GitHub repository settings
2. Scroll to "Danger Zone"
3. Click "Change visibility"
4. Select "Make public"

#### 5.2 User Installation Instructions

Once public, users can install your marketplace:

```bash
# Add marketplace
/plugin marketplace add your-username/claude-code

# List available plugins
/plugin list

# Install a specific plugin
/plugin install starter-plugin@claude-code-marketplace

# Update marketplace catalog
/plugin marketplace update claude-code-marketplace
```

---

## Key Components Explained

### Marketplace vs Plugin

- **Marketplace:** Container for multiple plugins (defined by `marketplace.json`)
- **Plugin:** Individual collection of commands/skills/agents/hooks (defined by `plugin.json`)

### Component Types

| Component | Discovery | User Invocation | Use Case |
|-----------|-----------|-----------------|----------|
| **Commands** | `commands/*.md` | Explicit (`/command`) | User-triggered actions |
| **Skills** | `skills/*/SKILL.md` | Automatic (by Claude) | Context-aware capabilities |
| **Agents** | `agents/*.md` | Task tool | Specialized subagents |
| **Hooks** | `hooks/hooks.json` | Event-driven | Automation & validation |

### Auto-Discovery

Claude Code automatically finds components in standard directories:
- Commands: All `.md` files in `commands/`
- Skills: All `SKILL.md` files in `skills/*/`
- Agents: All `.md` files in `agents/`
- Hooks: Configuration in `hooks/hooks.json`

### Path Variables

Use these in configurations:
- `${CLAUDE_PLUGIN_ROOT}` - Absolute path to plugin directory
- `${CLAUDE_PROJECT_DIR}` - Current project directory
- `${VAR:-default}` - Environment variable with default

---

## Next Steps After Implementation

1. **Create your first custom plugin** in `plugins/`
2. **Test locally** using `/plugin marketplace add ./path`
3. **Push to GitHub** and make repository public
4. **Share** the installation command with users
5. **Iterate** based on feedback and usage

---

## Resources

- [Official Plugin Documentation](https://code.claude.com/docs/en/plugins)
- [Plugin Examples](https://github.com/anthropics/claude-code/tree/main/plugins)
- [Model Context Protocol](https://modelcontextprotocol.io)

---

**Status:** Ready for implementation
**Estimated Files:** ~15 files (structure + examples)
**Distribution:** GitHub public repository
