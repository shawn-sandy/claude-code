# AI Agent Instructions for Cursor

Instructions for AI assistants working in this project with Cursor IDE.

## Project Overview

This is a Claude Code plugins workspace for developing and managing AI assistant extensions, skills, and hooks.

## Quick Start for Cursor

1. **Read `openspec/project.md`** for project conventions before making changes
2. **Check `plugins/`** directory for existing plugin structure and patterns
3. **Use conventional commits** for all git operations
4. **Follow TypeScript** for type safety when applicable

## Technology Stack

- **Documentation**: Markdown
- **Type Safety**: TypeScript
- **UI Components**: React (when applicable)
- **Styling**: CSS Modules or SASS/SCSS (no Tailwind)
- **Testing**: Playwright for E2E
- **Code Quality**: ESLint + Prettier
- **Documentation**: JSDoc for functions, classes, and components

## Directory Structure

```text
claude-code/
├── AGENTS.md              # This file - AI instructions
├── openspec/              # Spec-driven development
│   ├── AGENTS.md          # Detailed OpenSpec instructions
│   ├── project.md         # Project conventions
│   ├── specs/             # Current specifications
│   └── changes/           # Proposed changes
├── plugins/               # Plugin implementations
│   └── starter-plugin/    # Example plugin structure
│       ├── agents/        # Agent definitions
│       ├── commands/      # Slash commands
│       ├── hooks/         # Hook configurations
│       └── skills/        # Skill definitions
└── plans/                 # Planning documents
```

## Working with Plugins

When creating or modifying plugins:

1. Follow the structure in `plugins/starter-plugin/` as a template
2. Create agent definitions in `agents/` subdirectory
3. Define commands in `commands/` as Markdown files
4. Configure hooks in `hooks/hooks.json`
5. Document skills in `skills/[skill-name]/SKILL.md`

## Code Style Guidelines

- Use meaningful variable and function names
- Document functions with JSDoc comments
- Prefer explicit types over `any`
- Keep functions small and focused
- Write tests for new functionality

## Commit Message Format

Use conventional commits:

```text
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

<!-- OPENSPEC:START -->

## OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:

- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:

- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

## MCP Tools Available

This workspace has access to:

- **Playwright**: Browser automation and testing
- **Context7**: Up-to-date library documentation
- **Supabase**: Database operations
- **Browser**: Frontend testing and interaction

## Best Practices

### Before Making Changes

- [ ] Understand the existing code structure
- [ ] Check for related specs in `openspec/specs/`
- [ ] Review active changes in `openspec/changes/`
- [ ] Follow established patterns in the codebase

### When Writing Code

- [ ] Use TypeScript for type safety
- [ ] Add JSDoc documentation
- [ ] Follow existing code style
- [ ] Keep changes focused and minimal

### After Making Changes

- [ ] Run linting (`eslint`)
- [ ] Format code (`prettier`)
- [ ] Write tests for new functionality
- [ ] Use conventional commit messages
