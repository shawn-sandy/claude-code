---
description: Example slash command demonstrating command structure and frontmatter
argument-hint: [optional-message]
allowed-tools: Bash(echo:*)
model: claude-3-5-sonnet-20241022
---

# Example Command

This is an example slash command that demonstrates the proper structure for Claude Code commands.

## How This Works

When a user types `/example [message]`, this prompt is expanded and executed by Claude.

## Your Task

If the user provided an argument after the command, echo it back to them in a friendly way.
If no argument was provided, explain what this example command does and show them how to use it with an argument.

Use the Bash tool to echo the message if one was provided.

## Command Structure Notes

- **description**: Brief summary shown in command listings (max 1-2 sentences)
- **argument-hint**: Shows users what arguments are expected
- **allowed-tools**: Restricts which tools this command can use (for security)
- **model**: Which Claude model to use (defaults to conversation model)
- **disable-model-invocation**: Set to true for simple prompt expansion without LLM

## Best Practices

1. Keep commands focused on a single, clear purpose
2. Use argument-hint to guide users on expected inputs
3. Restrict allowed-tools when dealing with sensitive operations
4. Document your command's behavior in the prompt
5. Commands are user-invoked (explicit), unlike skills which are automatic
