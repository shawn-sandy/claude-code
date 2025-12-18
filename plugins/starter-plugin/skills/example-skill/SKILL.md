---
name: example-skill
description: Example skill demonstrating skill structure and best practices. Use this skill when the user asks about "skill examples", "skill templates", "how to create skills", or mentions wanting to learn about Claude Code skill development.
allowed-tools: Read, Grep, Glob
---

# Example Skill: Skill Development Guide

## Purpose

This skill demonstrates how to properly structure a Claude Code skill with correct frontmatter, clear instructions, and best practices for autonomous invocation.

## When Claude Should Use This Skill

Claude should automatically invoke this skill when:
- User asks questions about skill examples or templates
- User mentions "skill structure", "skill format", or "SKILL.md"
- User wants to understand how skills differ from commands
- Context suggests the user is learning about the Claude Code skill system
- User asks "show me how to create a skill"

## Key Differences: Skills vs Commands vs Agents

### Skills (This File Type)
- **Invocation**: Autonomous - Claude decides when to use based on context
- **Discovery**: `skills/*/SKILL.md` structure
- **Purpose**: Provide specialized capabilities that enhance Claude's abilities
- **Trigger**: Description must clearly state when to use (critical!)
- **User Interaction**: Transparent - user may not know skill was used

### Commands
- **Invocation**: Explicit - user types `/command-name`
- **Discovery**: `commands/*.md` files
- **Purpose**: User-triggered actions and workflows
- **Trigger**: User explicitly calls the command
- **User Interaction**: Direct - user knows they're running a command

### Agents
- **Invocation**: Via Task tool - Claude launches specialized subagents
- **Discovery**: `agents/*.md` files
- **Purpose**: Complex, multi-step specialized tasks requiring isolation
- **Trigger**: Task tool with subagent_type parameter
- **User Interaction**: Explicit subagent execution with separate context

## Instructions for This Skill

When this skill is invoked, provide a comprehensive explanation that includes:

1. **Skill File Structure**
   - Show the proper SKILL.md format with frontmatter
   - Explain the required fields (name, description)
   - Discuss optional fields (allowed-tools)

2. **Writing Effective Descriptions**
   - MUST include what the skill does
   - MUST include when Claude should use it
   - Include trigger keywords users might mention
   - Be specific about the context that warrants usage

3. **Best Practices**
   - Keep skills focused on one primary capability
   - Use clear, action-oriented descriptions
   - Include concrete examples and scenarios
   - Restrict tools with allowed-tools when appropriate
   - Support with additional files in skill directory if needed

4. **Practical Example**
   Use this very file as a working example, pointing out:
   - The frontmatter configuration
   - How the description includes both "what" and "when"
   - The detailed instructions section
   - Documentation of different component types

5. **Common Pitfalls**
   - Vague descriptions that don't specify when to use
   - Missing trigger keywords that users might naturally say
   - Overly broad skills that try to do too much
   - Not restricting tools when security matters

## Example Skill Template

Show the user this template they can copy:

```markdown
---
name: my-skill-name
description: [What this skill does] Use this skill when [specific conditions or user requests that should trigger it]. Keywords: [terms users might mention].
allowed-tools: Read, Grep, Glob
---

# Skill Title

## Purpose
Clear statement of what this skill provides

## When to Use
Specific conditions that warrant this skill

## Instructions
Step-by-step guidance for Claude when skill is invoked

## Examples
Concrete scenarios and use cases
```

## Supporting Files

Skills can include supporting files in their directory:
- Configuration files
- Template files
- Reference documentation
- Helper scripts (executed via Bash tool)

Example structure:
```
skills/my-skill/
├── SKILL.md              # Required
├── config.json           # Optional supporting file
├── templates/            # Optional subdirectory
│   └── template.md
└── scripts/              # Optional scripts
    └── helper.sh
```

## Tool Restrictions

The `allowed-tools` field limits which tools this skill can use:
- Security: Prevent unintended file modifications
- Focus: Keep skills constrained to their purpose
- Debugging: Easier to trace skill behavior

Common tool combinations:
- **Read-only**: `Read, Grep, Glob` (safe exploration)
- **Analysis**: `Read, Grep, Glob, WebFetch` (research)
- **Modification**: `Read, Write, Edit` (file operations)
- **Execution**: `Bash` (command execution - use carefully)

## Summary

Provide a clear, educational response that:
1. Explains the skill system architecture
2. Shows concrete examples from this file
3. Provides a template they can use
4. Highlights key best practices
5. Clarifies when to use skills vs commands vs agents

Make your response practical and actionable, referencing specific lines or sections from this skill file as examples.
