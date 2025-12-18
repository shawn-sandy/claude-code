# [Skill Name]

<!-- Replace [Skill Name] with your skill's descriptive name -->
<!-- Brief 1-2 sentence overview of what this skill does -->

[Brief description of skill purpose and capabilities]

## When This Skill Activates

<!-- CRITICAL: List all trigger phrases and keywords that activate this skill -->
<!-- This helps users understand when Claude will automatically use the skill -->

Claude automatically invokes this skill when you:
- [Trigger phrase 1] (e.g., "analyze my code", "review this file")
- [Trigger phrase 2] (e.g., "check quality", "find issues")
- [Trigger keyword 3] (e.g., mention "code review", "quality check")
- [Context scenario] (e.g., when discussing code improvements)

## Overview

<!-- Optional: More detailed explanation if the skill has complex capabilities -->

This skill provides:
- [Core capability 1]
- [Core capability 2]
- [Core capability 3]

## Features

<!-- List the main features and capabilities of the skill -->

### [Feature Category 1]
- **[Feature A]**: [Description of what it does]
- **[Feature B]**: [Description of what it does]

### [Feature Category 2]
- **[Feature C]**: [Description of what it does]
- **[Feature D]**: [Description of what it does]

## Usage Examples

<!-- Provide real-world scenarios showing how users interact with the skill -->
<!-- Show the conversation pattern: User request → Skill behavior -->

### Example 1: [Scenario Name]

```
User: "[Example user request that triggers the skill]"

Claude: [Explains what the skill does in this scenario]
```

**Result**: [What outcome the user can expect]

### Example 2: [Another Scenario]

```
User: "[Another example request]"

Claude: [How the skill responds]
```

**Result**: [Expected outcome]

### Example 3: [Edge Case or Advanced Usage]

```
User: "[Complex or specific request]"

Claude: [Skill behavior for advanced usage]
```

**Result**: [What happens]

## How It Works

<!-- Optional: Explain the skill's approach or methodology -->

When activated, this skill:

1. **[Phase 1]**: [What happens first]
2. **[Phase 2]**: [Next step in the process]
3. **[Phase 3]**: [How it completes the task]
4. **[Phase 4]**: [Final output or action]

## Configuration

<!-- Document any configuration options, settings, or customization -->
<!-- If no configuration needed, you can omit this section -->

### Available Options

This skill can be customized through:
- **[Option 1]**: [How to configure, what it affects]
- **[Option 2]**: [Configuration method and purpose]

### Environment Variables

<!-- If the skill uses environment variables -->

Required environment variables:
- `[VAR_NAME]`: [Purpose and example value]
- `[VAR_NAME_2]`: [Purpose and example value]

Optional environment variables:
- `[OPTIONAL_VAR]`: [Purpose and default value]

## Allowed Tools

<!-- List the tools this skill can use and explain why -->
<!-- This helps users understand what operations the skill can perform -->

This skill uses the following tools:
- **Read**: [Why this tool is needed - e.g., "Read source files for analysis"]
- **Grep**: [Purpose - e.g., "Search for patterns in codebase"]
- **Glob**: [Purpose - e.g., "Find files matching criteria"]
- **Write**: [Purpose - e.g., "Create report files"]
- **Bash**: [Purpose - e.g., "Run validation commands"]

### Tool Restrictions

<!-- If using allowed-tools to restrict capabilities -->

For security, this skill is restricted to:
- [Specific tool subset, e.g., "Read-only operations (Read, Grep, Glob)"]
- [Reason for restriction, e.g., "No file modifications to prevent unintended changes"]

## Troubleshooting

<!-- Document common issues and their solutions -->
<!-- This reduces support burden and helps users self-serve -->

### Issue: [Common Problem 1]

**Problem**: [Description of the issue users might encounter]

**Symptoms**:
- [How users know they're experiencing this issue]
- [What error or behavior they see]

**Solutions**:
1. [First thing to try]
2. [Alternative solution]
3. [If above don't work, try this]

### Issue: [Common Problem 2]

**Problem**: [Another common issue]

**Solutions**:
- [Solution approach 1]
- [Solution approach 2]

### Skill Not Triggering

**Problem**: The skill doesn't activate when expected

**Solutions**:
- Verify the plugin is installed: `/plugin list`
- Check trigger keywords match your request
- Ensure SKILL.md frontmatter is valid
- Try more explicit phrases from "When This Skill Activates" section

## Best Practices

<!-- Optional: Guidelines for getting the most out of the skill -->

To get the best results from this skill:
- [Practice 1 - e.g., "Provide clear, specific requests"]
- [Practice 2 - e.g., "Include relevant context"]
- [Practice 3 - e.g., "Review output before applying changes"]

## Limitations

<!-- Optional: Document known limitations or constraints -->

This skill has the following limitations:
- [Limitation 1 - e.g., "Only works with JavaScript/TypeScript files"]
- [Limitation 2 - e.g., "Requires minimum Node.js version X"]
- [Limitation 3 - e.g., "Cannot process files larger than X MB"]

## Related Documentation

<!-- Link to relevant documentation for deeper understanding -->

- [Official Plugin Reference](https://code.claude.com/docs/en/plugins-reference)
- [Starter Plugin Examples](../../../plugins/starter-plugin/)
- [Project CLAUDE.md](../../CLAUDE.md)
- [Contributing Guide](../../CONTRIBUTING.md)
- [Other relevant skill] - For related functionality

## Contributing

<!-- Optional: If you want contributions to this skill -->

To improve this skill:
1. [How to suggest improvements]
2. [Testing requirements]
3. [Where to report issues]

## Version History

<!-- Track significant changes to help users understand what's new -->

### v1.0.0 (YYYY-MM-DD)
- Initial release
- [Key feature 1]
- [Key feature 2]
- [Key feature 3]

### v1.1.0 (YYYY-MM-DD)
- Added: [New feature]
- Fixed: [Bug fix]
- Improved: [Enhancement]

### v1.2.0 (YYYY-MM-DD)
- Added: [Another feature]
- Changed: [Breaking change if any]
- Deprecated: [Old feature if any]

## License

<!-- If different from project license, specify here -->

[License type - typically inherits from project: MIT]

---

**Tip**: This template includes all possible sections. For simple skills, you can omit sections like Configuration, Limitations, or Contributing. Focus on "When This Skill Activates", "Features", and "Usage Examples" as the minimum viable documentation.

**When to include README**:
- ✅ Skill has multiple features or capabilities
- ✅ Configuration options available
- ✅ Complex usage patterns or workflows
- ✅ Troubleshooting steps frequently needed
- ✅ Public/marketplace distribution
- ❌ Simple, single-purpose, self-documenting skills
- ❌ Internal/private use only with obvious functionality
