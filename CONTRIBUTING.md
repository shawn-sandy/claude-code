# Contributing to Claude Code Marketplace

Thank you for your interest in contributing! This guide will help you add plugins to the marketplace or improve existing ones.

## Table of Contents

- [Getting Started](#getting-started)
- [Plugin Structure](#plugin-structure)
- [Component Types](#component-types)
- [Naming Conventions](#naming-conventions)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Best Practices](#best-practices)

## Getting Started

### Prerequisites

- [Claude Code](https://code.claude.com) installed
- Git installed
- Familiarity with Markdown and YAML frontmatter
- Understanding of the Claude Code plugin system

### Repository Setup

1. Fork this repository
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/claude-code.git
   cd claude-code
   ```
3. Test the marketplace locally:
   ```bash
   /plugin marketplace add ./path/to/claude-code
   /plugin list
   ```

## Plugin Structure

Each plugin must follow this exact structure:

```
plugins/your-plugin-name/
├── .claude-plugin/
│   └── plugin.json          # REQUIRED: Plugin manifest
├── commands/                 # Optional: Slash commands
│   └── command-name.md
├── skills/                   # Optional: Autonomous skills
│   └── skill-name/
│       └── SKILL.md
├── agents/                   # Optional: Specialized agents
│   └── agent-name.md
├── hooks/                    # Optional: Event hooks
│   ├── hooks.json
│   └── scripts/
│       └── hook-script.sh
└── .mcp.json                # Optional: MCP servers
```

### Required Files

Every plugin MUST have:

**`.claude-plugin/plugin.json`**
```json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "Clear, concise description of what your plugin does",
  "author": {
    "name": "Your Name",
    "email": "your-email@example.com"
  },
  "homepage": "https://github.com/username/repo",
  "repository": "https://github.com/username/repo",
  "license": "MIT",
  "keywords": ["relevant", "keywords", "for", "search"]
}
```

## Component Types

### Commands (Slash Commands)

**Location:** `commands/command-name.md`

Commands are user-invoked actions. Create them when users need to explicitly trigger an action.

**Structure:**
```markdown
---
description: Brief command description (1-2 sentences)
argument-hint: [optional-args]
allowed-tools: Bash(git:*), Read, Write
model: claude-3-5-sonnet-20241022
---

# Command Implementation

Your command prompt instructions here.
When a user types /command-name [args], this prompt is expanded.
```

**Best Practices:**
- Keep commands focused on a single purpose
- Use `argument-hint` to guide users
- Restrict `allowed-tools` for security
- Document expected behavior clearly

### Skills

**Location:** `skills/skill-name/SKILL.md`

Skills are autonomously triggered by Claude based on context. Create them to enhance Claude's capabilities.

**Structure:**
```markdown
---
name: skill-identifier
description: What the skill does and WHEN Claude should use it. Include trigger keywords users might mention.
allowed-tools: Read, Grep, Glob
---

# Skill Name

## Purpose
Clear statement of capability

## When to Use
Specific conditions for invocation

## Instructions
Detailed implementation guidance
```

**Best Practices:**
- Description MUST include both "what" and "when"
- Include trigger keywords users might say
- Keep skills focused on one capability
- Use read-only tools when possible

### Agents

**Location:** `agents/agent-name.md`

Agents are specialized subagents for complex tasks. Create them for domain-specific expertise.

**Structure:**
```markdown
---
name: agent-identifier
description: Agent's purpose and when Claude should launch it
tools: Read, Write, Edit, Bash
model: inherit
permissionMode: auto
---

# Agent System Prompt

You are a specialized agent that [clear identity].

## Your Purpose
[Detailed role description]

## Behavior Guidelines
[Specific instructions]

## Completion Criteria
You're done when:
- [Criterion 1]
- [Criterion 2]
```

**Best Practices:**
- Provide clear identity and role
- Include specific behavioral instructions
- Define completion criteria
- Restrict tools appropriately
- Choose suitable model (inherit, sonnet, opus, haiku)

### Hooks

**Location:** `hooks/hooks.json`

Hooks are event-driven automation. Create them for validation, logging, or workflow enforcement.

**Structure:**
```json
{
  "description": "Hook purpose",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validation instruction"
          }
        ]
      }
    ]
  }
}
```

**Available Events:**
- `PreToolUse` - Before tool execution
- `PostToolUse` - After tool execution
- `SessionStart` - Session initialization
- `SessionEnd` - Session cleanup
- `UserPromptSubmit` - User input received
- `Stop` - Main agent stopped
- `SubagentStop` - Subagent stopped
- `PermissionRequest` - Permission needed
- `Notification` - Notification received
- `PreCompact` - Before context compaction

**Hook Types:**
- `prompt` - Inject instructions into Claude's context
- `command` - Execute shell script with environment variables

**Best Practices:**
- Use prompt hooks for guidance
- Use command hooks for validation/logging
- Keep scripts fast (use timeouts)
- Make scripts executable (`chmod +x`)
- Use `${CLAUDE_PLUGIN_ROOT}` for paths

### MCP Servers

**Location:** `.mcp.json`

MCP servers integrate external services. Create them for API access or external tools.

**Structure:**
```json
{
  "server-name": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/server-executable",
    "args": ["--config", "config.json"],
    "env": {
      "API_KEY": "${API_KEY}",
      "TIMEOUT": "${TIMEOUT:-30}"
    }
  }
}
```

**Best Practices:**
- Document required environment variables
- Provide setup instructions
- Test servers independently
- Use path variables correctly
- Support environment variable defaults

## Naming Conventions

### Plugin Names
- **Format:** kebab-case (lowercase with hyphens)
- **Examples:** `code-reviewer`, `test-runner`, `git-helper`
- **Rules:**
  - Descriptive and clear
  - Unique within marketplace
  - No special characters except hyphens

### Component Names
- **Commands:** kebab-case matching filename without `.md`
- **Skills:** kebab-case matching directory name
- **Agents:** kebab-case matching filename without `.md`
- **Hooks:** N/A (defined in JSON)

### File Organization
- Group related commands in subdirectories (doesn't affect naming)
- Keep skill support files in skill directory
- Place hook scripts in `hooks/scripts/`

## Development Workflow

### 1. Create Your Plugin

```bash
# Create plugin structure
mkdir -p plugins/my-plugin/.claude-plugin
mkdir -p plugins/my-plugin/commands
mkdir -p plugins/my-plugin/skills
mkdir -p plugins/my-plugin/agents
mkdir -p plugins/my-plugin/hooks/scripts

# Create plugin.json
cat > plugins/my-plugin/.claude-plugin/plugin.json <<EOF
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "license": "MIT"
}
EOF
```

### 2. Add Components

Create commands, skills, agents, or hooks following the structure guidelines above.

### 3. Update Marketplace Catalog

Edit `.claude-plugin/marketplace.json`:

```json
{
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Brief plugin description",
      "version": "1.0.0"
    }
  ]
}
```

### 4. Document Your Plugin

Add plugin documentation to README.md under "Available Plugins".

## Testing

### Local Testing

1. **Add marketplace locally:**
   ```bash
   /plugin marketplace add ./path/to/claude-code
   ```

2. **Install your plugin:**
   ```bash
   /plugin install my-plugin@claude-code-marketplace
   ```

3. **Test components:**
   ```bash
   # Test commands
   /my-command arg1 arg2

   # Test skills (ask Claude to use them)
   # "Can you [trigger phrase from skill description]"

   # Test agents (ask Claude to launch them)
   # "Use the [agent-name] to [task]"
   ```

4. **Verify hooks:**
   - Check hook prompts appear correctly
   - Verify hook scripts execute and exit properly
   - Test blocked operations return appropriate errors

### Validation Checklist

Before submitting:

- [ ] Plugin.json has all required fields
- [ ] All JSON files are valid (use `jq` or JSON validator)
- [ ] All frontmatter is valid YAML
- [ ] Component names follow kebab-case convention
- [ ] Hook scripts are executable (`chmod +x`)
- [ ] Descriptions clearly state "what" and "when"
- [ ] Documentation is complete and accurate
- [ ] No sensitive information (API keys, passwords)
- [ ] License is specified and appropriate
- [ ] Plugin installs without errors locally
- [ ] All components work as expected

## Git Hooks (Husky)

This repository uses Husky git hooks to automatically validate changes before commits and pushes. Hooks are located in `.husky/` and run automatically without requiring npm or package.json.

### Installed Hooks

**pre-commit:**
- Validates JSON files (marketplace.json, plugin.json, hooks.json, .mcp.json)
- Checks shell script syntax with `bash -n`
- Verifies hook scripts are executable
- Validates YAML frontmatter in markdown files

**commit-msg:**
- Enforces conventional commit message format
- Validates commit message structure and length
- Provides helpful error messages with examples

**pre-push:**
- Runs OpenSpec validation if spec files changed
- Scans for accidentally committed secrets
- Validates marketplace catalog consistency
- Checks plugin structure integrity

**prepare-commit-msg:**
- Adds helpful commit message template
- Includes type options and examples
- Appears when creating new commits

### Bypassing Hooks

If you need to bypass hooks (use sparingly and with caution):

```bash
# Skip pre-commit and commit-msg hooks
git commit --no-verify -m "message"

# Skip pre-push hook
git push --no-verify
```

**Note:** Only bypass hooks when absolutely necessary, such as urgent hotfixes or false positives. All commits should pass validation before merging.

### Common Validation Errors

**JSON validation failed:**
```bash
# Problem: Invalid JSON syntax
# Solution: Run jq to see specific error
jq . .claude-plugin/marketplace.json

# Common issues:
# - Missing commas between objects
# - Trailing commas (invalid in JSON)
# - Unquoted strings
# - Mismatched brackets
```

**Shell script not executable:**
```bash
# Problem: Hook script not executable
# Solution: Add executable permission
chmod +x plugins/starter-plugin/hooks/scripts/example-hook.sh
```

**Invalid commit message:**
```bash
# Problem: Commit message doesn't follow conventional format
# Solution: Use proper format

# ❌ Bad:
git commit -m "updated docs"
git commit -m "WIP"

# ✅ Good:
git commit -m "docs: update README with installation steps"
git commit -m "feat(plugins): add testing plugin"
git commit -m "fix: resolve JSON validation issue"
```

**Allowed commit types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Maintenance tasks
- `add`, `update`, `remove`, `enhance`, `improve` - Content changes

**OpenSpec validation failed:**
```bash
# Problem: OpenSpec validation errors
# Solution: Run validation locally and fix issues
openspec validate --strict

# Common issues:
# - Missing required fields in spec
# - Incorrect delta format
# - Scenario formatting issues
```

**Potential secrets detected:**
```bash
# Problem: Pattern matching API keys, tokens, passwords
# Solution: Remove sensitive data, use environment variables

# ❌ Bad:
api_key = "sk_live_abc123def456"
password = "mySecretPassword"

# ✅ Good:
api_key = "${API_KEY}"  # In .mcp.json
# Document in README: "Set API_KEY environment variable"
```

### Hook Configuration

Hooks use system tools without dependencies:
- **jq** - JSON validation (pre-installed on macOS/Linux)
- **bash** - Shell script validation (built-in)
- **openspec** - OpenSpec validation (if installed)

If a tool is not available, the hook will skip that validation or show a warning.

### Troubleshooting

**Hooks not running:**
```bash
# Verify hooks are executable
ls -la .husky/

# All hooks should have execute permission (x):
# -rwxr-xr-x  pre-commit
# -rwxr-xr-x  commit-msg
# -rwxr-xr-x  pre-push

# If not executable:
chmod +x .husky/*
```

**Hook script errors:**
```bash
# Test hook manually
./.husky/pre-commit

# Check for syntax errors
bash -n .husky/pre-commit
```

**False positives:**
If a validation incorrectly blocks your commit:
1. Review the error message carefully
2. Verify your changes are correct
3. If it's truly a false positive, use `--no-verify`
4. Report the issue so we can improve the hook

## Submitting Changes

### Pull Request Process

1. **Create a feature branch:**
   ```bash
   git checkout -b add-my-plugin
   ```

2. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Add my-plugin: brief description"
   ```

3. **Push to your fork:**
   ```bash
   git push origin add-my-plugin
   ```

4. **Open a Pull Request:**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

### PR Template

```markdown
## Plugin Name
[Your plugin name]

## Description
[What your plugin does]

## Components
- [ ] Commands
- [ ] Skills
- [ ] Agents
- [ ] Hooks
- [ ] MCP Servers

## Testing
- [ ] Tested locally
- [ ] All components work
- [ ] No errors or warnings
- [ ] Documentation complete

## Additional Notes
[Any special considerations]
```

### Review Process

1. Maintainer reviews for:
   - Structure compliance
   - Code quality
   - Documentation completeness
   - Security concerns

2. Address feedback:
   - Make requested changes
   - Update PR with fixes
   - Re-request review

3. Merge:
   - PR approved by maintainer
   - Merged to main branch
   - Available in marketplace

## Best Practices

### General Guidelines

- **Clarity:** Write clear descriptions and documentation
- **Focus:** Each component should have one clear purpose
- **Security:** Restrict tools, validate inputs, avoid sensitive data
- **Documentation:** Explain usage, requirements, and examples
- **Testing:** Thoroughly test before submitting

### Component-Specific

**Commands:**
- User-triggered actions only
- Clear argument expectations
- Appropriate tool restrictions
- Documented behavior

**Skills:**
- Trigger conditions in description
- Focused on one capability
- Read-only when possible
- Includes usage examples

**Agents:**
- Clear identity and purpose
- Specific behavioral guidelines
- Completion criteria defined
- Appropriate tool access

**Hooks:**
- Fast execution (use timeouts)
- Clear error messages
- Proper exit codes
- Minimal dependencies

**MCP Servers:**
- Independent testing
- Environment variable docs
- Error handling
- Connection timeouts

### Security Considerations

- **Never commit secrets:** Use environment variables
- **Validate inputs:** Check user inputs in hooks
- **Restrict tools:** Use `allowed-tools` appropriately
- **Review scripts:** Audit hook scripts for safety
- **Permission modes:** Use restrictive modes when appropriate

### Performance

- **Keep hooks fast:** Use timeouts (10-30s max)
- **Optimize agents:** Choose appropriate models
- **Minimize dependencies:** Reduce external requirements
- **Efficient prompts:** Clear, concise instructions

### Documentation

- **README sections:** Usage, requirements, examples
- **Inline comments:** Explain complex logic
- **Frontmatter docs:** Document all fields
- **Examples:** Show real-world usage

## Questions and Support

- **Issues:** [GitHub Issues](https://github.com/shawnsandy/claude-code/issues)
- **Discussions:** [GitHub Discussions](https://github.com/shawnsandy/claude-code/discussions)
- **Documentation:** https://code.claude.com/docs/en/plugins

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Claude Code Plugin Marketplace!
