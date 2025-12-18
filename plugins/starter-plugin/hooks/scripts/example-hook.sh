#!/bin/bash
# Example hook script that executes after Bash tool use
# This demonstrates how to create executable hooks that respond to events

# Hook scripts receive context through environment variables:
# - TOOL_NAME: The name of the tool that was used
# - TOOL_INPUT: The input/parameters passed to the tool
# - TOOL_OUTPUT: The output from the tool (for PostToolUse hooks)
# - CLAUDE_PLUGIN_ROOT: Absolute path to this plugin's root directory
# - CLAUDE_PROJECT_DIR: Absolute path to the current project directory

echo "=== Example Hook Script Executed ==="
echo "Tool used: ${TOOL_NAME:-unknown}"
echo "Tool input: ${TOOL_INPUT:-none}"
echo "Plugin root: ${CLAUDE_PLUGIN_ROOT}"
echo "Project dir: ${CLAUDE_PROJECT_DIR}"
echo "===================================="

# Hook scripts communicate via exit codes:
# - exit 0: Success (continue execution)
# - exit 1: Failure (block execution for PreToolUse, log error for PostToolUse)

# Example: Block potentially dangerous commands
if [[ "$TOOL_INPUT" == *"rm -rf"* ]]; then
  echo "ERROR: Dangerous command detected and blocked"
  exit 1
fi

# Example: Log command execution
if [[ -n "$TOOL_NAME" ]]; then
  log_file="${CLAUDE_PLUGIN_ROOT}/hooks/logs/command.log"
  mkdir -p "$(dirname "$log_file")"
  echo "$(date): $TOOL_NAME - $TOOL_INPUT" >> "$log_file"
fi

# Success - allow execution to continue
exit 0
