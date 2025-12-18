# Add Husky Git Hooks to Repository

## Overview

Set up Husky with minimal shell-based hooks (no package.json/npm dependencies) to automate validation of JSON files, shell scripts, commit messages, and OpenSpec changes.

## User Requirements

**Hooks to Implement:**
- pre-commit
- commit-msg
- pre-push
- prepare-commit-msg

**Validations Required:**
- JSON validation (marketplace.json, plugin.json, hooks.json, .mcp.json)
- Markdown linting
- Shell script validation
- OpenSpec validation

**Approach:**
- Minimal setup (just Husky with shell scripts, no package.json dependencies)

## Current Repository State

### Existing Infrastructure
- ✅ Git repository initialized
- ✅ `.gitignore` configured for node_modules, lock files
- ❌ No `.husky/` directory exists
- ❌ No package.json exists
- ❌ No existing git hooks configured

### Available Tools
- ✅ `jq` - available at `/usr/bin/jq` (JSON validation)
- ✅ `openspec` - available at `/opt/homebrew/bin/openspec` (spec validation)
- ❌ `shellcheck` - NOT installed (would need assumption of availability)
- ❌ `markdownlint-cli` - NOT installed (would need assumption of availability)

### Files Requiring Validation

**JSON Files (6 total):**
1. `.claude-plugin/marketplace.json` - Marketplace catalog
2. `plugins/starter-plugin/.claude-plugin/plugin.json` - Plugin manifest
3. `plugins/starter-plugin/hooks/hooks.json` - Hook configuration
4. `plugins/starter-plugin/.mcp.json` - MCP server config
5. `.claude/settings.local.json` - Local settings (gitignored, may skip)
6. `.git/cursor/crepe/*/metadata.json` - Git metadata (may skip)

**Markdown Files (16 tracked):**
- Root: README.md, CONTRIBUTING.md, CLAUDE.md, AGENTS.md
- Plugin docs: plugins/starter-plugin/commands/example.md, skills/example-skill/SKILL.md, agents/example-agent.md
- OpenSpec: openspec/project.md, openspec/AGENTS.md
- Commands: .claude/commands/openspec/*.md
- GitHub: .github/copilot-instructions.md
- Planning: planning/plugin-marketplace-setup.md

**Shell Scripts (1 file):**
- `plugins/starter-plugin/hooks/scripts/example-hook.sh` (already executable)

## Commit Message Format

Based on recent commits analysis:

**Current Pattern:**
- `<type>: <description>`
- `<type>(<scope>): <description>`

**Examples from History:**
- `docs: enhance CLAUDE.md with comprehensive development guidance`
- `docs: add Cursor IDE support with enhanced AI instructions`
- `Add OpenSpec integration and AI assistant documentation`

**Conventional Commit Types Used:**
- `docs:` - Documentation changes
- `feat:` - New features (implied)
- `fix:` - Bug fixes (implied)
- Bare descriptions without prefix also present

**Extended Format (for generated commits):**
- Multi-line body descriptions
- Co-authorship: `Co-Authored-By: Claude <noreply@anthropic.com>`
- Attribution footer: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`

## Implementation Plan

### 1. Initialize Husky Structure

Create `.husky/` directory with core hook files:

```
.husky/
├── pre-commit          # Validate JSON, shell scripts, YAML frontmatter
├── commit-msg          # Enforce conventional commits format
├── pre-push            # Run OpenSpec validation, check for secrets
├── prepare-commit-msg  # Add commit message template/helpers
└── _/
    └── .gitignore      # Standard Husky ignore file
```

### 2. Create pre-commit Hook

**File:** `.husky/pre-commit`

**Responsibilities:**
- Validate JSON files using `jq`
- Check shell script syntax using `bash -n`
- Verify hook scripts are executable
- Basic YAML frontmatter validation for markdown files

**Validation Logic:**

```bash
#!/bin/bash

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# JSON validation
echo "Validating JSON files..."
JSON_FILES=$(echo "$STAGED_FILES" | grep -E '\.(json)$')
for file in $JSON_FILES; do
  if [ -f "$file" ]; then
    if ! jq -e . "$file" >/dev/null 2>&1; then
      echo "❌ JSON validation failed: $file"
      exit 1
    fi
  fi
done

# Shell script syntax validation
echo "Validating shell scripts..."
SHELL_FILES=$(echo "$STAGED_FILES" | grep -E '\.(sh)$')
for file in $SHELL_FILES; do
  if [ -f "$file" ]; then
    if ! bash -n "$file" 2>&1; then
      echo "❌ Shell script syntax error: $file"
      exit 1
    fi

    # Check if hook scripts are executable
    if [[ "$file" =~ hooks/scripts/ ]]; then
      if [ ! -x "$file" ]; then
        echo "❌ Hook script not executable: $file"
        echo "   Run: chmod +x $file"
        exit 1
      fi
    fi
  fi
done

# YAML frontmatter validation (basic check)
echo "Validating YAML frontmatter..."
MD_FILES=$(echo "$STAGED_FILES" | grep -E '\.(md)$')
for file in $MD_FILES; do
  if [ -f "$file" ]; then
    # Check if file has frontmatter
    if head -1 "$file" | grep -q "^---$"; then
      # Basic validation - ensure closing ---
      if ! grep -q "^---$" <(sed -n '2,20p' "$file"); then
        echo "❌ YAML frontmatter not properly closed: $file"
        exit 1
      fi
    fi
  fi
done

echo "✅ Pre-commit validation passed"
exit 0
```

### 3. Create commit-msg Hook

**File:** `.husky/commit-msg`

**Responsibilities:**
- Enforce conventional commits format
- Validate commit message structure
- Ensure minimum quality standards

**Validation Logic:**

```bash
#!/bin/bash

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Skip merge commits
if echo "$COMMIT_MSG" | grep -q "^Merge"; then
  exit 0
fi

# Skip revert commits
if echo "$COMMIT_MSG" | grep -q "^Revert"; then
  exit 0
fi

# Conventional commit pattern
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|add|update|remove|enhance|improve)(\(.+\))?: .+"

if ! echo "$COMMIT_MSG" | grep -Eq "$PATTERN"; then
  echo "❌ Invalid commit message format"
  echo ""
  echo "Commit message must follow conventional commits format:"
  echo "  <type>: <description>"
  echo "  <type>(<scope>): <description>"
  echo ""
  echo "Allowed types:"
  echo "  feat, fix, docs, style, refactor, perf, test, chore"
  echo "  add, update, remove, enhance, improve, build, ci"
  echo ""
  echo "Examples:"
  echo "  docs: update README with installation steps"
  echo "  feat(plugins): add new testing plugin"
  echo "  fix: resolve JSON validation issue"
  echo ""
  exit 1
fi

# Check minimum length (type + description should be meaningful)
if [ ${#COMMIT_MSG} -lt 10 ]; then
  echo "❌ Commit message too short (minimum 10 characters)"
  exit 1
fi

echo "✅ Commit message validation passed"
exit 0
```

### 4. Create pre-push Hook

**File:** `.husky/pre-push`

**Responsibilities:**
- Run OpenSpec validation if specs changed
- Check marketplace.json consistency
- Scan for accidentally committed secrets
- Verify plugin structure integrity

**Validation Logic:**

```bash
#!/bin/bash

# Get list of files being pushed
FILES_TO_PUSH=$(git diff --name-only origin/main..HEAD 2>/dev/null || git diff --name-only --cached)

# OpenSpec validation
if echo "$FILES_TO_PUSH" | grep -q "openspec/"; then
  echo "OpenSpec files changed, running validation..."
  if command -v openspec >/dev/null 2>&1; then
    if ! openspec validate --strict; then
      echo "❌ OpenSpec validation failed"
      echo "   Fix validation errors before pushing"
      exit 1
    fi
  else
    echo "⚠️  Warning: openspec CLI not found, skipping validation"
  fi
fi

# Check for secrets
echo "Scanning for potential secrets..."
SECRET_PATTERNS="(api[_-]?key|password|secret|token|access[_-]?key|private[_-]?key).*['\"]?[a-zA-Z0-9]{20,}['\"]?"
if echo "$FILES_TO_PUSH" | xargs grep -Ei "$SECRET_PATTERNS" 2>/dev/null; then
  echo "❌ Potential secrets detected in code"
  echo "   Remove sensitive data before pushing"
  exit 1
fi

# Validate marketplace.json consistency
if echo "$FILES_TO_PUSH" | grep -q "marketplace.json"; then
  echo "Validating marketplace catalog..."

  # Check all plugins in marketplace.json have corresponding directories
  if [ -f ".claude-plugin/marketplace.json" ]; then
    PLUGIN_NAMES=$(jq -r '.plugins[].name' .claude-plugin/marketplace.json)
    for plugin in $PLUGIN_NAMES; do
      if [ ! -d "plugins/$plugin" ]; then
        echo "❌ Plugin directory missing: plugins/$plugin"
        echo "   marketplace.json references non-existent plugin"
        exit 1
      fi

      if [ ! -f "plugins/$plugin/.claude-plugin/plugin.json" ]; then
        echo "❌ Plugin manifest missing: plugins/$plugin/.claude-plugin/plugin.json"
        exit 1
      fi
    done
  fi
fi

echo "✅ Pre-push validation passed"
exit 0
```

### 5. Create prepare-commit-msg Hook

**File:** `.husky/prepare-commit-msg`

**Responsibilities:**
- Add helpful comments to commit message template
- Optionally prepend context
- Keep lightweight and non-intrusive

**Logic:**

```bash
#!/bin/bash

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Only add template for regular commits (not merge, squash, etc.)
if [ -z "$COMMIT_SOURCE" ] || [ "$COMMIT_SOURCE" = "message" ]; then
  # Check if commit message is empty or default
  if ! grep -q "[a-zA-Z]" "$COMMIT_MSG_FILE"; then
    cat > "$COMMIT_MSG_FILE" <<EOF
# <type>: <description>
#
# Types: feat, fix, docs, style, refactor, perf, test, chore
#        add, update, remove, enhance, improve
#
# Examples:
#   docs: update README with installation steps
#   feat(plugins): add new testing plugin
#   fix: resolve JSON validation issue
#
# Remember:
#   - Use present tense ("add" not "added")
#   - Keep first line under 72 characters
#   - Separate body with blank line if needed
EOF
  fi
fi

exit 0
```

### 6. Create Husky Ignore File

**File:** `.husky/_/.gitignore`

```
*
```

This ensures the `_/` directory is tracked but its contents are ignored (standard Husky pattern).

### 7. Update Documentation

#### CONTRIBUTING.md Updates

Add new section after "Validation Checklist" (around line 377):

```markdown
## Git Hooks (Husky)

This repository uses Husky git hooks to automatically validate changes before commits and pushes.

### Installed Hooks

**pre-commit:**
- Validates JSON files (marketplace.json, plugin.json, hooks.json, .mcp.json)
- Checks shell script syntax
- Verifies hook scripts are executable
- Validates YAML frontmatter in markdown files

**commit-msg:**
- Enforces conventional commit message format
- Validates commit message structure and length

**pre-push:**
- Runs OpenSpec validation if spec files changed
- Scans for accidentally committed secrets
- Validates marketplace catalog consistency

**prepare-commit-msg:**
- Adds helpful commit message template

### Bypassing Hooks

If you need to bypass hooks (use sparingly):

```bash
# Skip pre-commit and commit-msg hooks
git commit --no-verify -m "message"

# Skip pre-push hook
git push --no-verify
```

### Common Validation Errors

**JSON validation failed:**
- Run `jq . file.json` to see specific syntax error
- Check for missing commas, brackets, or quotes

**Shell script not executable:**
- Run `chmod +x path/to/script.sh`

**Invalid commit message:**
- Use format: `<type>: <description>`
- Allowed types: feat, fix, docs, style, refactor, perf, test, chore, add, update, remove, enhance, improve

**OpenSpec validation failed:**
- Run `openspec validate --strict` locally
- Fix issues in spec files before pushing
```

#### README.md Updates

Add section after "Quick Start" (around line 33):

```markdown
## Development Setup

### Git Hooks

This repository uses Husky git hooks for automated validation. Hooks are located in `.husky/` and run automatically:

- **pre-commit**: Validates JSON, shell scripts, and YAML frontmatter
- **commit-msg**: Enforces conventional commit format
- **pre-push**: Runs OpenSpec validation and security checks

The hooks use system tools (`jq`, `bash`, `openspec`) without requiring npm/node dependencies.

For troubleshooting, see [CONTRIBUTING.md](CONTRIBUTING.md#git-hooks-husky).
```

### 8. Testing Plan

**Test pre-commit hook:**
```bash
# Test JSON validation
echo "{invalid json" > test.json
git add test.json
git commit -m "test: invalid json"  # Should fail

# Test shell script validation
echo "if [ missing fi" > test.sh
git add test.sh
git commit -m "test: invalid shell"  # Should fail

# Test valid changes
rm test.json test.sh
git add .
git commit -m "test: valid changes"  # Should succeed
```

**Test commit-msg hook:**
```bash
git commit --allow-empty -m "bad message"  # Should fail
git commit --allow-empty -m "docs: valid message"  # Should succeed
```

**Test pre-push hook:**
```bash
# Test OpenSpec validation (if specs exist)
# Modify openspec file with invalid content
git add openspec/
git commit -m "test: invalid spec"
git push  # Should fail if openspec validation fails

# Test secret detection
echo "api_key = 'sk_live_EXAMPLE_KEY_HERE_20_CHARS'" > secret.txt
git add secret.txt
git commit -m "test: secret"
git push  # Should fail
```

## Implementation Checklist

- [ ] Create `.husky/` directory
- [ ] Create `.husky/pre-commit` hook script
- [ ] Create `.husky/commit-msg` hook script
- [ ] Create `.husky/pre-push` hook script
- [ ] Create `.husky/prepare-commit-msg` hook script
- [ ] Create `.husky/_/.gitignore` file
- [ ] Make all hook scripts executable (`chmod +x .husky/*`)
- [ ] Update CONTRIBUTING.md with Git Hooks section
- [ ] Update README.md with development setup info
- [ ] Test pre-commit hook with invalid JSON
- [ ] Test pre-commit hook with invalid shell script
- [ ] Test commit-msg hook with invalid message
- [ ] Test commit-msg hook with valid message
- [ ] Test pre-push hook with OpenSpec changes
- [ ] Test pre-push hook with secret patterns
- [ ] Verify hooks don't break normal workflow
- [ ] Create git commit with changes
- [ ] Update CLAUDE.md if needed (mention hooks in validation section)

## Post-Implementation

After implementing hooks:

1. **Test thoroughly** with real workflow scenarios
2. **Monitor for false positives** in validation
3. **Iterate on hook scripts** based on team feedback
4. **Consider adding more validations** as needed:
   - Markdown linting (if CLI tool added)
   - shellcheck (if tool added)
   - Custom plugin validation rules

## Notes and Considerations

**Advantages:**
- No npm/package.json dependencies required
- Uses system tools already available
- Lightweight and fast
- Easy to understand shell scripts
- Enforces quality standards automatically

**Limitations:**
- Markdown linting limited (no markdownlint-cli available)
- shellcheck not available (only basic syntax checking)
- Assumes `jq` and `openspec` available in environment
- May have platform differences (Windows vs Unix)

**Future Enhancements:**
- Add shellcheck if installed in environment
- Add markdownlint-cli if available
- Create helper scripts in `.husky/scripts/` for complex validations
- Add hook for automatically running plugin installation tests
- Consider commit message length limits for first line

## References

- CONTRIBUTING.md validation checklist (lines 362-376)
- CLAUDE.md validation section (lines 240-280)
- Existing commit message patterns from git log
- OpenSpec validation documentation in openspec/AGENTS.md
