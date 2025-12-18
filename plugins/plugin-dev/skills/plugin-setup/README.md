# Plugin Setup Skill

An interactive, automated skill for creating and scaffolding Claude Code plugins with comprehensive validation and marketplace integration.

## Overview

The plugin-setup skill provides a guided workflow that automates the entire plugin creation process - from initial scaffolding to marketplace registration and validation. It eliminates manual setup errors and ensures plugins follow best practices and conventions.

## When This Skill Activates

Claude automatically invokes this skill when you say:

- "Create a plugin" / "New plugin" / "Make a plugin"
- "Setup plugin" / "Initialize plugin" / "Scaffold plugin"
- "Add a command" / "Add a skill" / "Add an agent"
- "Create hook" / "Setup MCP server"
- Any mention of creating Claude Code plugin components

## What It Does

### 6-Phase Automated Workflow

#### Phase 1: Gather Requirements
Interactive questions collect all necessary information:
- Plugin name (validated for kebab-case format)
- Description and purpose
- Author information (name, email)
- Repository and homepage URLs
- Component selection (commands, skills, agents, hooks, MCP)

#### Phase 2: Create Plugin Structure
Generates proper directory structure and files:
```
plugins/your-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── commands/                     # If selected
│   └── example-command.md
├── skills/                       # If selected
│   └── example-skill/
│       └── SKILL.md
├── agents/                       # If selected
│   └── example-agent.md
├── hooks/                        # If selected
│   ├── hooks.json
│   └── scripts/
│       └── example-hook.sh
└── .mcp.json                    # If selected
```

#### Phase 3: Update Marketplace
Automatically registers the new plugin in `.claude-plugin/marketplace.json` with proper metadata and formatting.

#### Phase 4: Update Documentation
Adds plugin documentation to `README.md` including:
- Plugin description
- Component list
- Installation instructions
- Usage examples

#### Phase 5: Comprehensive Validation
Runs thorough validation checks:
- JSON syntax validation (`jq` validation for all JSON files)
- YAML frontmatter validation in markdown files
- Hook script permissions (`chmod +x`)
- Directory structure verification
- Naming convention checks (kebab-case)
- Path variable validation (`${CLAUDE_PLUGIN_ROOT}`)

#### Phase 6: Testing Guide
Provides step-by-step instructions for:
- Installing plugin locally
- Testing each component type
- Verifying marketplace registration
- Customizing example files

## Features

### Interactive Component Selection

Choose which components to include:
- **Commands**: User-invoked slash commands (`/command-name`)
- **Skills**: Autonomous capabilities triggered by context
- **Agents**: Specialized subagents for complex tasks
- **Hooks**: Event-driven automation and validation
- **MCP Servers**: External service integrations

### Template-Based Generation

Uses `starter-plugin` as reference to create:
- Working example files adapted for your plugin
- Proper YAML frontmatter with all required fields
- Path variables (`${CLAUDE_PLUGIN_ROOT}`) for portability
- Security patterns (tool restrictions)
- Educational inline comments

### Optional README Generation for Skills

Asks whether to include README.md for skills:
- Interactive question: "Include README.md for this skill?"
- Generated README includes: activation triggers, features, usage examples, troubleshooting
- Template based on best practices from `templates/skill-readme-template.md`
- Separates user-facing documentation from system prompt (SKILL.md)
- Recommended for complex skills, optional for simple ones
- Example READMEs: `plugin-setup` and `example-skill`

### Automated Marketplace Integration

Handles all marketplace tasks:
- Adds plugin entry to catalog
- Maintains proper JSON formatting
- Validates syntax after updates
- Ensures unique plugin names

### Educational Insights

Provides context-aware explanations about:
- Directory structure requirements (components at root, not in `.claude-plugin/`)
- Skill description patterns (must include "when to use")
- Path variable importance for portability
- Hook script requirements (executable, exit codes)
- Security considerations (tool restrictions)

### Validation & Safety

Comprehensive checks prevent common mistakes:
- ✅ Component directories at plugin root (not in `.claude-plugin/`)
- ✅ Kebab-case naming throughout
- ✅ Valid JSON and YAML syntax
- ✅ Executable hook scripts
- ✅ Proper path variable usage
- ✅ Required frontmatter fields present

## Usage Examples

### Creating a New Plugin

```
You: "I want to create a new plugin"

Claude: I'll help you create a new plugin! Let me gather some information...

[Asks questions about plugin name, components, metadata]

[Creates structure, updates marketplace, validates everything]

Claude: Your plugin has been created successfully! Here's how to test it...
```

### Adding Components to Existing Plugin

```
You: "Add a skill to my plugin"

Claude: I'll help you add a skill component...

[If plugin exists, adds skill directory and example]
[If plugin doesn't exist, creates new plugin with skill]
```

### Quick Plugin with All Components

```
You: "Create a plugin called 'my-tools' with commands, skills, and hooks"

Claude: Creating 'my-tools' plugin with commands, skills, and hooks...

[Asks for metadata, creates all selected components, validates]
```

### Creating a Skill with README Documentation

```
You: "Add a skill to my code-tools plugin"

Claude: I'll add a skill to your code-tools plugin.

[Creates SKILL.md]

Claude: Would you like to include a README.md for this skill?

You: "Yes, include README"

Claude: Creating comprehensive README with usage examples, troubleshooting, and documentation...

[Generates README.md from template]

Claude: Skill created with both SKILL.md and README.md. The README provides user-facing documentation while SKILL.md contains the system prompt.
```

## Component Templates

### Command Template
```markdown
---
description: Example command for [plugin-name]
argument-hint: [optional-args]
allowed-tools: Read, Write, Bash(git:*)
---

# Example Command

Instructions for what the command does...
```

### Skill Template
```markdown
---
name: example-skill
description: What it does. Use when [triggers]. Keywords: [terms].
allowed-tools: Read, Grep, Glob
---

# Skill System Prompt

Purpose and instructions...
```

### Agent Template
```markdown
---
name: example-agent
description: Purpose and when to use
tools: Read, Grep, Glob, Bash
model: inherit
---

# Agent System Prompt

Responsibilities and approach...
```

### Hooks Template
```json
{
  "description": "Hook purpose",
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "SessionStart": [...]
  }
}
```

## Validation Checks

The skill runs these validations automatically:

### JSON Validation
```bash
jq empty .claude-plugin/marketplace.json
jq empty plugins/[name]/.claude-plugin/plugin.json
jq empty plugins/[name]/hooks/hooks.json
jq empty plugins/[name]/.mcp.json
```

### YAML Frontmatter
- Verifies proper YAML syntax in markdown frontmatter
- Checks required fields are present
- Validates field types and values

### Hook Scripts
```bash
chmod +x plugins/[name]/hooks/scripts/*.sh  # Make executable
bash -n plugins/[name]/hooks/scripts/*.sh    # Syntax check
```

### Structure Validation
- Components at plugin root (not in `.claude-plugin/`)
- Kebab-case naming conventions
- Path variables used correctly
- No hardcoded absolute paths

## Error Handling

The skill handles common errors gracefully:

### Plugin Already Exists
```
The plugin "my-plugin" already exists.
Would you like to:
1. Choose a different name
2. Add components to existing plugin
3. Cancel setup
```

### Invalid Plugin Name
```
Plugin name must be kebab-case (lowercase with hyphens).
Examples: code-reviewer, api-client, test-runner

Please provide a valid name.
```

### JSON Validation Failure
```
JSON validation failed for marketplace.json:
[specific error message]

I'll fix the syntax error and try again.
```

## Testing Your Plugin

After creation, test with these steps:

```bash
# 1. Add marketplace locally
/plugin marketplace add /path/to/claude-code

# 2. Verify marketplace
/plugin marketplace list

# 3. Install your plugin
/plugin install your-plugin-name@claude-code-marketplace

# 4. Test components

# Commands
/your-command [args]

# Skills (trigger automatically)
"[phrase that matches skill description]"

# Agents (launched via Task tool)
"Use the your-agent to [task]"

# Hooks (run automatically on events)
[Perform action that triggers hook]
```

## Configuration

### Allowed Tools

The skill uses these tools:
- `Read` - Read reference files (starter-plugin)
- `Write` - Create plugin files
- `Edit` - Update marketplace.json and README.md
- `Bash` - Run validation commands (jq, chmod)
- `Glob` - Find existing plugins
- `Grep` - Search for patterns
- `AskUserQuestion` - Interactive questions

### Tool Restrictions

The skill follows principle of least privilege:
- File operations limited to plugin directories
- Bash restricted to validation commands
- No network access required
- No destructive operations

## Best Practices

### Plugin Naming
- Use kebab-case: `my-plugin-name`
- Be descriptive: `code-reviewer` not `cr`
- Avoid generic names: `api-client` not `client`
- Check for uniqueness before creating

### Component Selection
Choose components based on use case:
- **Commands** for user-triggered workflows
- **Skills** for autonomous enhancements
- **Agents** for complex isolated tasks
- **Hooks** for validation and automation
- **MCP** for external integrations

### Description Writing
For skills and agents, always include:
1. What it does
2. When to use it
3. Trigger keywords users might say

Example:
```
description: Analyzes code quality and suggests improvements.
Use when user asks to "review code", "check quality", or
"analyze my code". Keywords: code review, quality check, analysis.
```

### Path Variables
Always use path variables in configs:
```json
// hooks.json
"command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/hook.sh"

// .mcp.json
"command": "${CLAUDE_PLUGIN_ROOT}/servers/server.js"
```

Never use hardcoded paths:
```json
// ❌ WRONG
"command": "/Users/username/plugins/my-plugin/scripts/hook.sh"
```

## Troubleshooting

### Skill Not Triggering

**Problem**: Skill doesn't activate when you say "create plugin"

**Solutions**:
- Verify plugin-dev is installed: `/plugin list`
- Check skill file exists: `plugins/plugin-dev/skills/plugin-setup/SKILL.md`
- Ensure YAML frontmatter is valid
- Try explicit phrases: "I want to create a new plugin"

### Components Not Found

**Problem**: Created plugin doesn't show components

**Solutions**:
- Verify components are at plugin root, not in `.claude-plugin/`
- Check file naming uses kebab-case
- Validate YAML frontmatter syntax
- Reinstall plugin: `/plugin update plugin-name`

### Validation Failures

**Problem**: JSON or YAML validation errors

**Solutions**:
- Check for trailing commas in JSON
- Verify YAML indentation (use spaces, not tabs)
- Ensure required frontmatter fields present
- Run `jq empty file.json` to identify JSON errors

### Hook Scripts Not Running

**Problem**: Hooks defined but don't execute

**Solutions**:
- Verify scripts are executable: `ls -la plugins/*/hooks/scripts/`
- Check shebang present: `#!/bin/bash`
- Test syntax: `bash -n script.sh`
- Ensure paths use `${CLAUDE_PLUGIN_ROOT}`

## Related Documentation

- [Official Plugin Reference](https://code.claude.com/docs/en/plugins-reference)
- [Starter Plugin Examples](../../starter-plugin/)
- [Project CLAUDE.md](../../../CLAUDE.md)
- [OpenSpec Agents](../../../openspec/AGENTS.md)
- [Contributing Guide](../../../CONTRIBUTING.md)

## Examples

### Real-World Plugin Creation

**Creating a Code Review Plugin:**

```
You: "Create a plugin called code-reviewer with skills and agents"

Claude: I'll create a code-review plugin with skills and agents.

[Questions about metadata]

Plugin created with:
- plugin.json with your metadata
- skills/review-code/SKILL.md
- agents/code-reviewer-agent.md
- Updated marketplace and README
- All validations passed ✓

Test with:
/plugin install code-reviewer@claude-code-marketplace
```

**Adding MCP Server to Existing Plugin:**

```
You: "Add an MCP server to my api-client plugin"

Claude: I'll add MCP server configuration to api-client.

[Creates .mcp.json with server templates]
[Creates MCP-SETUP.md with environment variable docs]
[Validates JSON syntax]

MCP configuration created. Set required environment variables:
- API_KEY
- AUTH_TOKEN
Then reinstall the plugin.
```

## Version History

### v1.0.0 (2025-12-18)
- Initial release
- Interactive plugin scaffolding
- All component types supported
- Comprehensive validation
- Automated marketplace integration
- Educational insights throughout

## Educational Insights

### Component Directory Structure

**Critical Pattern**: Component directories MUST be at plugin root level, not inside `.claude-plugin/`.

```
✅ Correct:   plugins/my-plugin/commands/
❌ Incorrect: plugins/my-plugin/.claude-plugin/commands/
```

**Why this matters**: Claude Code's auto-discovery system looks for component directories at the plugin root. Placing them inside `.claude-plugin/` breaks the discovery mechanism, and your components won't load.

**Auto-discovery directories**:
- `commands/*.md` → Slash commands
- `skills/*/SKILL.md` → Autonomous skills
- `agents/*.md` → Specialized agents
- `hooks/hooks.json` → Event automation
- `.mcp.json` → MCP servers

This is the **most common mistake** in plugin development!

### Skill Description Pattern

Skill descriptions must include TWO critical parts:

1. **WHAT it does**: "Analyzes code quality and suggests improvements"
2. **WHEN to use**: "Use when user asks to review code or check quality"

Without the WHEN part, Claude won't know when to trigger the skill autonomously.

**Good examples**:
```yaml
description: Interactive plugin setup tool. Use when user asks to "create plugin", "new plugin", "scaffold plugin", or mentions Claude Code plugin components.
```

**Bad examples**:
```yaml
# ❌ Missing trigger conditions
description: Interactive plugin setup tool.

# ❌ Too vague
description: Use this for plugin stuff.
```

### Path Variables for Portability

Always use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths in:
- `hooks.json` command paths
- `.mcp.json` server paths

**Why this matters**: Plugins can be installed in different scopes:
- User scope: `~/.claude/plugins/`
- Project scope: `.claude/plugins/`
- Local scope: `.claude/plugins.local/`
- Managed scope: Enterprise-controlled locations

Hardcoded paths will break portability!

**Correct usage**:
```json
// hooks.json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/validate.sh"
}

// .mcp.json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
  "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config/settings.json"]
}
```

**Incorrect usage**:
```json
// ❌ Hardcoded absolute path
{
  "command": "/Users/username/.claude/plugins/my-plugin/hooks/scripts/validate.sh"
}

// ❌ Using ~ or $HOME
{
  "command": "~/plugins/my-plugin/servers/api-server"
}

// ❌ Relative path without variable
{
  "command": "./hooks/scripts/validate.sh"
}
```

**Other path variables**:
- `${CLAUDE_PROJECT_DIR}` - Project root directory
- `${VAR:-default}` - Environment variable with default value

### Hook Scripts Best Practices

Hook scripts must be executable and use proper exit codes:

**Exit codes**:
- `0` = Success (allow operation to continue)
- `1` = Failure (block operation for PreToolUse hooks)

**Environment variables available**:
- `TOOL_NAME` - Name of the tool being used
- `TOOL_INPUT` - JSON input to the tool
- `TOOL_OUTPUT` - JSON output (PostToolUse only)
- `CLAUDE_PLUGIN_ROOT` - Absolute path to plugin directory
- `CLAUDE_PROJECT_DIR` - Absolute path to project directory

**Template structure**:
```bash
#!/bin/bash
# Purpose: Validate write operations
# Events: PreToolUse
# Exit: 0=allow, 1=block

# Access environment variables
if [ "$TOOL_NAME" = "Write" ]; then
  echo "Validating write operation..."

  # Your validation logic here

  # Exit with appropriate code
  exit 0  # Allow
  # exit 1  # Block
fi
```

**Common issues**:
- Script not executable: `chmod +x script.sh`
- Missing shebang: Always include `#!/bin/bash`
- Wrong exit code: PreToolUse with exit 1 blocks operation
- Timeout: Keep scripts under 10-30s execution time

### Security with Tool Restrictions

Use `allowed-tools` frontmatter field to restrict component capabilities following the **principle of least privilege**:

**Read-only operations**:
```yaml
allowed-tools: Read, Grep, Glob
```

**File modification**:
```yaml
allowed-tools: Read, Write, Edit
```

**Git operations only**:
```yaml
allowed-tools: Bash(git:*)
```

**Full access** (use carefully!):
```yaml
# Omit allowed-tools for full access
```

**Why restrict tools**:
- Prevents accidental destructive operations
- Limits security surface area
- Makes component behavior predictable
- Easier to audit and review

**Example security levels**:
- Analysis skills: `Read, Grep, Glob` (read-only)
- Code generation: `Read, Write` (create new files)
- Refactoring: `Read, Edit` (modify existing)
- Build automation: `Bash(npm:*, make:*)` (specific commands)

## Implementation Details

### Template Adaptation Pattern

The skill uses a **"Read + Adapt"** pattern for component generation:

1. **Read** the authoritative template from `starter-plugin`
2. **Adapt** with plugin-specific changes (name, description, purpose)
3. **Write** to new plugin directory

**Why this approach**:
- Single source of truth (`starter-plugin`)
- Templates stay up-to-date with conventions
- Reduced maintenance burden
- Consistent structure across all plugins

**Example workflow**:
```
1. Read: plugins/starter-plugin/commands/example.md
2. Adapt:
   - Replace "starter-plugin" with actual plugin name
   - Update description to match plugin purpose
   - Customize argument-hint and allowed-tools
   - Replace example content with plugin-specific instructions
3. Write: plugins/my-plugin/commands/my-command.md
```

### Validation Strategy

**Multi-layer validation** ensures plugin quality:

**Layer 1 - Syntax Validation**:
```bash
jq empty file.json                    # JSON syntax
python3 -c "import yaml; yaml.safe_load(open('file.md').read())"  # YAML
bash -n script.sh                     # Bash syntax
```

**Layer 2 - Structural Validation**:
- Components at plugin root (not in `.claude-plugin/`)
- Naming conventions (kebab-case)
- Required frontmatter fields present
- Path variables used correctly

**Layer 3 - Semantic Validation**:
- Plugin name unique in marketplace
- Descriptions include trigger conditions (skills)
- Tool restrictions appropriate for component type
- Cross-references valid (file paths exist)

**Why multi-layer**:
- Catches different error types at appropriate times
- Fast feedback (syntax first, semantics later)
- Prevents cascading failures
- Clear error messages for each layer

### Marketplace Integration

**Atomic update pattern** for marketplace.json:

1. Read current marketplace catalog
2. Parse JSON structure
3. Add new plugin entry to array
4. Validate entire JSON structure
5. Write back only if valid

**Why atomic**: Prevents corrupting marketplace catalog with partial updates. If validation fails, original file remains unchanged.

**Entry format**:
```json
{
  "name": "plugin-name",
  "source": "./plugins/plugin-name",
  "description": "Brief description (1-2 sentences)",
  "version": "1.0.0"
}
```

## Performance Notes

### Token Efficiency Considerations

**System Prompt Design**: The SKILL.md file is loaded into Claude's context on every activation. Large system prompts reduce available tokens for actual plugin generation and slow response times.

**Optimization strategy**:
- Keep SKILL.md focused on execution logic (what to do)
- Move educational content to README.md (why and how)
- Use reference pattern instead of embedding full templates
- Result: Faster activation, more context for generation

**Current approach**: SKILL.md references `starter-plugin` files instead of embedding complete templates, saving ~300 lines (~3,600 tokens) per activation.

### Validation Performance

**Fast validations first**: JSON and YAML syntax checks run before expensive operations like file system searches or script execution.

**Parallel validation**: Independent checks (JSON files, YAML frontmatter, scripts) can conceptually run in parallel, though current implementation is sequential for clarity.

**Timeout considerations**: Hook scripts validated for syntax only during setup. Runtime execution uses configured timeouts (10-30s recommended).

## Contributing

To improve this skill:

1. Test with various plugin types
2. Report issues or edge cases
3. Suggest additional validations
4. Propose new component templates
5. Improve error messages
6. Submit improvements via OpenSpec proposals

## License

MIT License - See [LICENSE](../../../../LICENSE)

---

**Built with Claude Code** - Automate your plugin development workflow! 🚀
