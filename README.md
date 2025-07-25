# Process Baseline

Reusable Cursor AI rules for internal Lullabot projects. This repository provides baseline workflow enforcement to solve common AI behavior problems: branch creation, commit practices, and interaction summaries.

## Quick Start

Install into your project with one command:

```bash
# From your project root
curl -fsSL https://raw.githubusercontent.com/Lullabot/process-baseline/main/install/install.sh | bash
```

Or clone and install manually:

```bash
git clone https://github.com/Lullabot/process-baseline.git /tmp/process-baseline
cd /tmp/process-baseline
./install/install.sh --help  # See options
./install/install.sh         # Install with merge (default)
```

## Problems This Solves

Based on analysis of multiple Lullabot tool repositories, this baseline addresses specific AI behavior problems:

### 1. AI Skipping Branch Creation ❌→✅
**Problem**: AI often makes changes directly to main branch  
**Solution**: Mandatory branch creation before ANY file changes  
**Impact**: Prevents accidental commits to main, enables proper review workflow

### 2. Missing AI Summaries ❌→✅  
**Problem**: AI completes tasks without documenting interaction history  
**Solution**: Required interaction summaries with standardized format  
**Impact**: Preserves context for humans, enables better handoffs

### 3. Inconsistent Commit Practices ❌→✅
**Problem**: AI skips review processes, uses poor commit messages  
**Solution**: Mandatory commit review with user approval gates  
**Impact**: Better commit history, prevents accidental changes

### 4. Lost Context on Task Switching ❌→✅
**Problem**: Context loss when AI changes focus  
**Solution**: Required status updates and clean handoff protocols  
**Impact**: Smoother collaboration, less repeated work

## Core Components

### Baseline Rules (`baseline-rules/`)

- **`core.mdc`** - Plan/Act mode system for controlled execution
- **`workflow-enforcement.mdc`** - Branch creation, commit, and summary requirements  
- **`memory-bank.mdc`** - Documentation standards for AI memory continuity

### Installation (`install/`)

- **`install.sh`** - Smart installation script with merge/replace options
- Automatic backup of existing rules
- `.gitignore` setup for temp files
- Project customization templates

### Documentation (`docs/`)

- Customization guides and examples
- Pain points addressed with before/after scenarios
- Project-specific override patterns

## How It Works

### "Strict with Context" Approach

Combines the best practices from existing Lullabot repositories:

- **Mandatory enforcement** (MUST language, verification steps) from `noko-lsm`
- **Educational explanations** (why each step matters) from `repeat-on-repos`  
- **Pattern documentation** (good/bad examples) from `jira-import-helper`
- **Customization guidance** for project-specific needs

### Enforcement vs. Flexibility

**MUST** requirements (non-negotiable):
- Branch creation before file changes
- User approval before commits  
- Documentation of exceptions and reasoning
- AI summary inclusion in deliverables

**MAY** be customized per project:
- Branch naming conventions
- Commit message formats
- Summary frequency for prototype work
- Review process timing

## Installation Options

### Default (Merge Mode)
```bash
./install/install.sh
```
- Preserves existing project-specific rules
- Adds baseline rules alongside them
- Safe for projects with existing `.cursor/rules`

### Replace Mode  
```bash
./install/install.sh --replace
```
- Replaces all existing rules with baseline
- Use for new projects or complete reset
- Creates backup before replacing

### Preview Mode
```bash
./install/install.sh --dry-run
```
- Shows what would be installed without making changes
- Useful for understanding impact before installation

## Customizing for Your Project

### Override Examples

Create project-specific rule files in `.cursor/rules/`:

**Fast Prototyping** (`prototype-mode.mdc`):
```markdown
---
description: "Streamlined process for spike work"
alwaysApply: true
---
# Project Override: Fast Prototype Mode

For tickets PROJ-100 through PROJ-199:
- MAY skip branch creation for experimental work under 4 hours
- MUST create proper branch before production-bound changes
- MUST document "prototype work" in commit messages
```

**Emergency Hotfixes** (`hotfix-process.mdc`):
```markdown  
---
description: "Emergency hotfix protocol"
alwaysApply: true
---
# Project Override: Emergency Protocol

For URGENT tagged tickets only:
- MAY work directly on hotfix branches from main
- MAY skip Plan mode for well-defined fixes
- MUST include detailed testing summary
```

### Customization Guidelines

**What you CAN override:**
- Branch naming conventions (document alternatives)
- Commit message formats (maintain detail requirements)
- Summary frequency (reduce for prototype work)
- Review timing (streamline for hotfixes)

**What you CANNOT override:**
- Branch creation requirement (safety critical)
- User approval for commits (prevents accidents)  
- Documentation of exceptions
- AI summary inclusion in final deliverables

## Directory Structure

```
process-baseline/
├── README.md                    # This file
├── baseline-rules/              # Core .cursor/rules files
│   ├── core.mdc                # Plan/Act mode system
│   ├── memory-bank.mdc         # Memory bank requirements  
│   ├── workflow-enforcement.mdc # Branch/commit/summary rules
│   └── examples/               # Customization templates
├── install/                    # Installation tooling
│   ├── install.sh             # Main installation script
│   └── merge-rules.sh         # Advanced rule merging (future)
└── docs/                      # Documentation
    ├── customization-guide.md  # Detailed customization guide
    ├── pain-points-addressed.md # Before/after scenarios
    └── examples/              # Project-specific examples
```

## Memory Bank Integration

The baseline includes comprehensive memory bank requirements adapted from successful Lullabot projects. After installation, initialize your project's memory bank:

```bash
mkdir -p memory-bank
# Create the six required files:
touch memory-bank/{projectbrief,productContext,activeContext,systemPatterns,techContext,progress}.md
```

See [`baseline-rules/memory-bank.mdc`](baseline-rules/memory-bank.mdc) for detailed requirements.

## Updating

Keep your baseline rules current:

```bash
# In the process-baseline repo directory
git pull origin main

# Re-run installation in your projects  
cd /path/to/your/project
/path/to/process-baseline/install/install.sh
```

The installation script safely merges updates while preserving your project customizations.

## Integration Examples

### Development Workflow
```bash
# 1. AI checks current branch (automatic)
git branch --show-current

# 2. Creates feature branch if needed (automatic)  
git checkout -b feature/new-feature

# 3. Makes changes with proper commit review (user approval required)
# 4. Posts AI summary to PR (automatic)
# 5. Runs through proper merge checklist (enforced)
```

### Project Setup
```bash
# Install baseline rules
curl -fsSL https://raw.githubusercontent.com/Lullabot/process-baseline/main/install/install.sh | bash

# Initialize memory bank
mkdir -p memory-bank
cp baseline-rules/examples/memory-bank-template/* memory-bank/

# Customize for your project
cp .cursor/rules/project-overrides.md.example .cursor/rules/project-custom.mdc
# Edit project-custom.mdc with your specific needs
```

## Contributing

This repository improves through real project experience. Contribute by:

1. **Using it** in your projects and documenting what works/doesn't
2. **Filing issues** for problems or missing patterns  
3. **Proposing improvements** based on team feedback
4. **Sharing examples** of successful project customizations

## Supported Projects

The baseline rules are designed to work across different project types:

- **Tool repositories** (CLI tools, scripts)
- **Web applications** (React, Node.js, Drupal)  
- **Documentation projects** (wikis, guides)
- **Prototyping work** (with appropriate overrides)

## Getting Help

- **Installation issues**: Check `install/install.sh --help`
- **Customization questions**: See `docs/customization-guide.md`
- **Rule conflicts**: Review existing project rules before installation
- **Team adoption**: Start with one project, iterate based on feedback

## Architecture Decisions

Based on analysis of existing Lullabot repositories:

- **jira-import-helper**: Provided basic Plan/Act mode foundation
- **repeat-on-repos**: Contributed comprehensive workflow patterns  
- **noko-lsm**: Supplied strict enforcement and approval gate concepts
- **lsm-examples wiki**: Informed PR preparation and review processes

The baseline synthesizes these approaches into a cohesive, customizable system that addresses observed pain points while maintaining flexibility for different project needs.

---

**Repository**: https://github.com/Lullabot/process-baseline  
**Issues**: Report problems or suggest improvements via GitHub Issues  
**License**: Internal use within Lullabot organization
