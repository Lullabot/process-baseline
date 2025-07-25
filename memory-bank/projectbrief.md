# Project Brief: Process Baseline

## Project Overview

**Project Name**: process-baseline  
**Organization**: Lullabot  
**Repository**: https://github.com/Lullabot/process-baseline  
**Type**: Developer tooling and process standardization  
**Status**: Active development

## Goals

Provide reusable Cursor AI rules for internal Lullabot projects to solve specific AI behavior problems experienced across multiple projects.

## Core Problems to Solve

1. **AI skipping branch creation**: AI often makes changes directly to main branch instead of creating feature branches first
2. **Missing AI summaries**: AI completes tasks without posting interaction summaries, losing context for humans  
3. **Inconsistent commit practices**: AI skips review processes, uses poor commit messages

## Solution Approach: "Strict with Context"

Combines:
- **Mandatory enforcement** (MUST language, verification steps, user approval gates) from noko-lsm
- **Educational explanations** (why each step matters, what problems it solves) from repeat-on-repos  
- **Pattern documentation** (good/bad examples, common failure patterns)
- **Customization guidance** (what can vs cannot be overridden by projects)

## Core Requirements (MUST HAVE)

- Branch creation protocol (mandatory before any file changes)
- Commit review process (staged review, scratch files, user approval)
- AI summary requirements (mandatory interaction documentation with specific format)
- Task switching protocol (required status updates when changing focus)
- PR finalization workflow (complete review process before merge)

## Success Criteria

- AI consistently follows branch creation before making changes
- AI posts summaries at task completion without being reminded
- Clear documentation that humans can customize per project
- Easy installation and adoption across Lullabot projects
- Combines best practices from all analyzed repos
- Individual projects can override specific guidelines to account for different project lifecycle stages

## Constraints

- Must allow project-specific overrides (critical for adoption)
- Should be installable via simple script (curl | bash pattern)
- Must support merging with existing .cursor/rules rather than replacing them
- Should provide clear upgrade/update process for existing projects

## Stakeholders

- **Primary**: Lullabot development teams using Cursor AI
- **Secondary**: Project maintainers needing consistent AI behavior
- **Tertiary**: New team members requiring clear handoff documentation

## Related Projects

- jira-import-helper (basic process documentation approach)
- repeat-on-repos (comprehensive task switching and workflow patterns)
- noko-lsm (strict enforcement approach with mandatory steps)
- lsm-examples (PR preparation and review insights) 