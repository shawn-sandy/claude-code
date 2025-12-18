# Claude Code Plugin Marketplace

A collection of plugins, commands, skills, agents, and hooks for [Claude Code](https://code.claude.com) - extending Claude's capabilities for development workflows.

## Quick Start

Add this marketplace to your Claude Code installation:

```bash
/plugin marketplace add shawnsandy/claude-code
```

Then install any plugin:

```bash
/plugin install starter-plugin@claude-code-marketplace
```

## Available Plugins

### starter-plugin

A comprehensive example plugin demonstrating all Claude Code component types with detailed documentation and best practices.

**Components:**
- **Commands**: Example slash command (`/example`) with frontmatter configuration
- **Skills**: Autonomous skill that explains skill development
- **Agents**: Specialized agent for learning about agent structure
- **Hooks**: Event-driven automation examples (PreToolUse, PostToolUse, SessionStart)
- **MCP**: Configuration templates for Model Context Protocol servers

**Install:**
```bash
/plugin install starter-plugin@claude-code-marketplace
```

**Usage Examples:**
```bash
# Try the example command
/example Hello from the marketplace!

# Skills are automatically triggered by Claude based on context
# Try asking: "Show me how to create a skill"

# Agents are launched via the Task tool
# Try asking: "Use the example-agent to explain agents"
```

## Plugin Components Explained

### Commands (Slash Commands)
User-invoked actions that start with `/`. Perfect for:
- Running tests or builds
- Creating git commits
- Custom workflows
- Deployment operations

**Structure:** `commands/command-name.md` with YAML frontmatter

### Skills
Autonomously triggered capabilities that enhance Claude's abilities. Perfect for:
- Code analysis and formatting
- Documentation generation
- Pattern detection
- Specialized knowledge

**Structure:** `skills/skill-name/SKILL.md` with YAML frontmatter

### Agents
Specialized subagents for complex, domain-specific tasks. Perfect for:
- Code reviews
- Security audits
- Research and analysis
- Multi-step workflows

**Structure:** `agents/agent-name.md` with YAML frontmatter

### Hooks
Event-driven automation that responds to tool usage and session events. Perfect for:
- Validation and safety checks
- Logging and monitoring
- Enforcing best practices
- Custom workflows

**Structure:** `hooks/hooks.json` with hook configurations

### MCP Servers
Model Context Protocol integrations for external services. Perfect for:
- API integrations
- Database access
- External tool integration
- Custom protocols

**Structure:** `.mcp.json` with server configurations

## Management Commands

### Marketplace Commands
```bash
# List all marketplaces
/plugin marketplace list

# Add a marketplace
/plugin marketplace add owner/repo
/plugin marketplace add https://git.company.com/plugins.git

# Update marketplace catalog
/plugin marketplace update claude-code-marketplace

# Remove a marketplace
/plugin marketplace remove claude-code-marketplace
```

### Plugin Commands
```bash
# List available plugins
/plugin list

# Install a plugin
/plugin install plugin-name@marketplace-name

# Update a plugin
/plugin update plugin-name

# Uninstall a plugin
/plugin uninstall plugin-name

# Get plugin info
/plugin info plugin-name
```

## Creating Your Own Plugins

This marketplace is designed to be a starting point. You can:

1. **Fork this repository** and add your own plugins
2. **Use the starter-plugin** as a template
3. **Follow the structure** outlined in [CONTRIBUTING.md](CONTRIBUTING.md)

### Quick Plugin Creation

```bash
# 1. Create your plugin directory
mkdir -p plugins/my-plugin/.claude-plugin
mkdir -p plugins/my-plugin/commands
mkdir -p plugins/my-plugin/skills
mkdir -p plugins/my-plugin/agents
mkdir -p plugins/my-plugin/hooks

# 2. Create plugin.json
cat > plugins/my-plugin/.claude-plugin/plugin.json <<EOF
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My awesome plugin",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "license": "MIT"
}
EOF

# 3. Add your components (commands, skills, agents, hooks)

# 4. Update marketplace.json to include your plugin

# 5. Test locally
/plugin marketplace add ./path/to/claude-code
/plugin install my-plugin@claude-code-marketplace
```

## Directory Structure

```
claude-code/
├── .claude-plugin/
│   └── marketplace.json              # Marketplace catalog
├── plugins/
│   └── starter-plugin/               # Example plugin
│       ├── .claude-plugin/
│       │   └── plugin.json          # Plugin manifest
│       ├── commands/                 # Slash commands
│       ├── skills/                   # Autonomous skills
│       ├── agents/                   # Specialized agents
│       ├── hooks/                    # Event hooks
│       └── .mcp.json                # MCP servers
├── plans/                            # Planning documents
├── README.md                         # This file
├── CONTRIBUTING.md                   # Contribution guidelines
├── LICENSE                           # MIT License
└── .gitignore                        # Git ignore rules
```

## Documentation

- **Official Plugin Docs**: https://code.claude.com/docs/en/plugins
- **Model Context Protocol**: https://modelcontextprotocol.io
- **Contributing Guide**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Setup Plan**: [plans/plugin-marketplace-setup.md](plans/plugin-marketplace-setup.md)

## Examples and Templates

The `starter-plugin` contains fully documented examples:

- [Example Command](plugins/starter-plugin/commands/example.md) - Slash command with frontmatter
- [Example Skill](plugins/starter-plugin/skills/example-skill/SKILL.md) - Autonomous skill structure
- [Example Agent](plugins/starter-plugin/agents/example-agent.md) - Specialized agent with system prompt
- [Hooks Config](plugins/starter-plugin/hooks/hooks.json) - Event-driven automation
- [Hook Script](plugins/starter-plugin/hooks/scripts/example-hook.sh) - Executable hook example
- [MCP Config](plugins/starter-plugin/.mcp.json) - External service integration

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Plugin development guidelines
- Naming conventions
- Testing procedures
- Pull request process

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/shawnsandy/claude-code/issues)
- **Discussions**: [GitHub Discussions](https://github.com/shawnsandy/claude-code/discussions)
- **Claude Code Help**: Use `/help` in Claude Code

## Acknowledgments

Built with [Claude Code](https://code.claude.com) - the official CLI for Claude by Anthropic.

---

**Happy coding with Claude!** 🚀
