# Product Context: Process Baseline

## Product Overview

Process Baseline is a standardization toolkit that provides reusable Cursor AI rules for Lullabot internal projects. It addresses systemic AI behavior problems that cause workflow inefficiencies and context loss.

## Target Users

### Primary Users
- **Lullabot developers** using Cursor AI for daily development work
- **Project leads** wanting consistent AI behavior across team members
- **New team members** needing clear workflow guidance

### User Needs
- Predictable AI behavior that follows established Lullabot processes
- Context preservation during task handoffs and project switches
- Ability to customize rules for specific project requirements
- Easy installation and maintenance of process standards

## Product Features

### Core Features
1. **Workflow Enforcement Rules** (`workflow-enforcement.mdc`)
   - Branch creation protocol
   - Commit review process with scratch files
   - AI summary requirements with differentiated character limits
   - Task switching protocol
   - PR finalization workflow

2. **Memory Bank Requirements** (`memory-bank.mdc`)
   - Standardized memory bank structure
   - Six core files with defined purposes
   - Update triggers and quality standards
   - Integration guidelines

3. **Plan/Act Mode System** (`core.mdc`)
   - Controlled AI execution with user approval
   - Mode awareness and switching protocols
   - Safety mechanisms for code changes

### Installation Features
- `install.sh` script with merge/replace options
- Automatic backup of existing rules
- Project customization template generation
- `.gitignore` updates for scratch files

### Documentation Features
- Comprehensive customization guide
- Pain points addressed with before/after examples
- Memory bank templates
- Best practices and common pitfalls

## Value Proposition

### For Development Teams
- **Reduced context loss** during handoffs and task switching
- **Consistent workflow** regardless of team member experience
- **Better documentation** through mandatory AI summaries
- **Safer changes** through branch creation and review processes

### For Project Management
- **Predictable AI behavior** across projects and team members
- **Audit trail** of AI interactions and decision-making
- **Customizable standards** that can adapt to project needs
- **Reduced onboarding time** for new team members

## Market Position

Process Baseline sits at the intersection of:
- **AI Development Tools**: Enhances Cursor AI capabilities
- **Process Standardization**: Provides consistent workflow enforcement
- **Team Collaboration**: Improves handoffs and documentation
- **Developer Experience**: Reduces friction while maintaining quality

## Success Metrics

- Number of Lullabot projects using the baseline rules
- Reduction in context loss incidents during project handoffs
- Team satisfaction with AI behavior consistency
- Frequency of AI following branch creation protocols
- Quality of AI summary documentation 