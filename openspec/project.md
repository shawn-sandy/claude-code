# Project Context

## Purpose

This is a **Claude Code Plugin Marketplace** - a multi-plugin repository for distributing plugins, commands, skills, agents, and hooks that extend Claude Code's capabilities. The project serves as:

1. A public marketplace for Claude Code plugins (installable via `/plugin marketplace add shawn-sandy/claude-code`)
2. A comprehensive reference implementation with `starter-plugin` demonstrating all component types
3. A template for others to fork and create their own plugin marketplaces

The marketplace enables users to install plugins that enhance Claude Code with custom slash commands, autonomous skills, specialized agents, event-driven hooks, and external service integrations.

## Tech Stack

- **Configuration**: JSON (marketplace.json, plugin.json, hooks.json, .mcp.json)
- **Component Files**: Markdown with YAML frontmatter (.md files)
- **Scripting**: Bash (for hook scripts)
- **Distribution**: Git/GitHub (marketplace installation)
- **Runtime**: Claude Code CLI

**No traditional programming languages** - this is a configuration-based plugin system using:

- JSON for manifests and configurations
- Markdown for component definitions and prompts
- YAML frontmatter for metadata
- Bash for optional hook automation scripts

## Project Conventions

### Code Style

**Naming Conventions:**

- **All identifiers**: kebab-case (lowercase with hyphens)
  - Plugin names: `my-plugin-name`
  - Command names: `command-name.md` (filename without extension)
  - Skill names: `skill-name/` (directory name)
  - Agent names: `agent-name.md` (filename without extension)
- **No special characters** except hyphens in names
- **Path variables** in JSON: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PROJECT_DIR}`, `${VAR:-default}`

**File Organization:**

- Component directories at plugin root (NOT in `.claude-plugin/`)
- Hook scripts in `hooks/scripts/`
- Skill support files in skill's directory
- Executable permissions on hook scripts (`chmod +x`)

**JSON/YAML Formatting:**

- 2-space indentation
- Required fields first in objects
- Validate all JSON before committing
- Verify YAML frontmatter syntax

### Architecture Patterns

**Two-Level Catalog System:**

1. **Marketplace Level** (`.claude-plugin/marketplace.json`): Defines all plugins in catalog
2. **Plugin Level** (`plugins/*/. claude-plugin/plugin.json`): Individual plugin manifests

**Auto-Discovery Pattern:**
Claude Code automatically discovers components by location:

- `commands/*.md` → Slash commands
- `skills/*/SKILL.md` → Autonomous skills
- `agents/*.md` → Specialized agents
- `hooks/hooks.json` → Event hooks
- `.mcp.json` → MCP servers

**Component Architecture:**

- **Commands**: User-invoked (explicit `/command`)
- **Skills**: Claude-invoked (autonomous based on context)
- **Agents**: Task-invoked (isolated subagent execution)
- **Hooks**: Event-driven (respond to tool use, sessions)
- **MCP**: External services (API/tool integrations)

**Path Management:**

- Always use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths
- Custom paths in plugin.json supplement (don't replace) defaults
- Component directories must be at plugin root level

### Testing Strategy

**Local Testing Required:**

```bash
# Add marketplace locally
/plugin marketplace add /path/to/claude-code

# Install plugin
/plugin install plugin-name@claude-code-marketplace

# Test each component type
/command-name [args]           # Commands
# Skills trigger automatically
# Agents via Task tool
```

**Validation Checklist Before Committing:**

- [ ] All JSON files validate (use `jq` or validator)
- [ ] All YAML frontmatter is valid
- [ ] Hook scripts are executable (`chmod +x`)
- [ ] Skill descriptions include "when to use" triggers
- [ ] Component names follow kebab-case
- [ ] No sensitive data (API keys, tokens)
- [ ] Plugin installs locally without errors
- [ ] All components function as expected
- [ ] Documentation updated in README.md
- [ ] Marketplace catalog updated if new plugin added

**No automated tests** - this is a configuration/documentation project. Testing is manual via Claude Code CLI.

### Git Workflow

**Branching:**

- `main` branch is production (what users install)
- Feature branches for new plugins: `add-plugin-name`
- Feature branches for improvements: `update-component-name`

**Commit Message Format:**

```
Brief descriptive summary line

Detailed explanation of changes:
- Bullet points for major changes
- Group related changes together
- Reference issue numbers if applicable

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Commit Requirements:**

- Clear, descriptive first line (50 chars ideal)
- Detailed body explaining "why" not just "what"
- Co-author attribution when AI-assisted
- No commits with failing validations
- Update README.md in same commit when adding plugins

**Example Commits:**

- `Add local development section to README`
- `Add Claude Code plugin marketplace with starter plugin`
- `Add CLAUDE.md with repository guidance for AI assistants`

## Domain Context

**Claude Code Plugin System:**

- Plugins extend Claude Code CLI functionality
- Marketplaces are Git repositories with catalog files
- Users install via `/plugin marketplace add owner/repo`
- Components are discovered automatically by file location
- Path variables enable portable configurations

**Component Lifecycle:**

1. **Commands**: User types `/name` → Claude expands markdown prompt → Executes with allowed tools
2. **Skills**: Claude sees context match → Loads SKILL.md → Executes autonomously
3. **Agents**: Claude uses Task tool → Launches isolated subagent → Returns results
4. **Hooks**: Event occurs → Runs prompt/script → Can block or allow action
5. **MCP**: Plugin loads → Connects to external service → Provides tools/resources

**Critical Distinctions:**

- Commands = Explicit user action
- Skills = Autonomous Claude decision
- Agents = Isolated specialized execution
- Hooks = Event-driven automation
- MCP = External service bridge

**Frontmatter Requirements:**

- Skills: Description MUST include "when to use" (triggers autonomous invocation)
- Agents: Can specify tools, model, permissionMode
- Commands: Can restrict allowed-tools for security

## Important Constraints

**Technical Constraints:**

- Component names must be kebab-case (Claude Code requirement)
- Component directories must be at plugin root, not in `.claude-plugin/`
- Hook scripts must be executable and exit properly (0=success, 1=failure)
- MCP servers must be tested independently before integration
- Path variables required for portability across installations

**Distribution Constraints:**

- Public marketplace requires GitHub public repository
- Users need Claude Code CLI installed to use plugins
- Local testing requires absolute or relative paths
- Plugin names must be unique within marketplace

**Security Constraints:**

- Never commit secrets (API keys, tokens, credentials)
- Use environment variables for sensitive data
- Restrict tools in commands/skills/agents when appropriate
- Validate inputs in hook scripts
- Review hook scripts for safety before enabling

**Documentation Constraints:**

- Every new plugin requires README.md entry
- Skill descriptions must explain when Claude should use them
- Hook scripts must document environment variables
- MCP configs must document required env vars

## External Dependencies

**Runtime Dependency:**

- **Claude Code CLI**: Required for all plugin functionality
  - Installation: <https://code.claude.com>
  - Used for: Plugin installation, component execution, marketplace management

**Optional Dependencies (for MCP servers):**

- External services/APIs that MCP servers connect to
- Environment variables for authentication
- Network connectivity for remote services

**Development Dependencies:**

- **Git**: For version control and distribution
- **GitHub**: For public marketplace hosting (optional - can use any Git host)
- **jq** (recommended): For JSON validation
- **Text editor**: For creating markdown/JSON files

**Documentation References:**

- Official Plugin Docs: <https://code.claude.com/docs/en/plugins>
- Model Context Protocol: <https://modelcontextprotocol.io>
- OpenSpec: `/openspec/AGENTS.md` for change proposals

**No package managers or build tools** - this is a configuration project with no compilation or bundling step.
