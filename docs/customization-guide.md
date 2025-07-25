# Customization Guide

This guide shows how to customize the process baseline for your project's specific needs while maintaining core safety principles.

## Philosophy

The baseline provides **mandatory safety nets** that prevent common mistakes while allowing **flexible customization** for different project contexts. Think of it as guardrails, not rigid constraints.

## Customization Levels

### Level 1: Configuration (Most Common)
Adjust behavior without changing core requirements:
- Branch naming conventions
- Commit message formats  
- Summary frequency
- Review timing

### Level 2: Process Adaptation (Moderate)
Modify workflows for specific project phases:
- Prototype/spike work patterns
- Hotfix emergency procedures
- Different client review processes

### Level 3: Override (Careful)
Disable specific requirements with documented justification:
- Skip branch creation (very limited cases)
- Alternative approval processes
- Different memory bank structures

## How to Customize

### Step 1: Identify Your Needs

**Common Project Variations:**
- **Early Development**: More iteration, less ceremony
- **Maintenance Mode**: Streamlined for small changes
- **Client Prototype**: Rapid iteration with client feedback
- **Production Support**: Emergency procedures needed
- **Large Team**: More coordination overhead
- **Solo Developer**: Simplified approval processes

### Step 2: Choose Customization Approach

**Option A: Add Project Rules (Recommended)**
```bash
# Create new rule file alongside baseline
.cursor/rules/project-specific.mdc
```

**Option B: Override Baseline Rules** 
```bash
# Edit baseline files directly (loses upgrade path)
.cursor/rules/workflow-enforcement.mdc
```

**Option C: Conditional Rules**
```bash
# Rules that apply only to specific tickets/branches
.cursor/rules/prototype-mode.mdc
```

### Step 3: Implement Your Customization

See examples below for common patterns.

## Customization Examples

### Example 1: Fast Prototyping Mode

**Problem**: Early development needs rapid iteration  
**Solution**: Streamlined process for experimental work

```markdown
---
description: "Streamlined process for prototype work"
globs: ["**/*"]
alwaysApply: true
---
# Project Override: Fast Prototype Mode

## Scope
For tickets tagged `prototype` or branch names starting with `spike/`:

## Branch Creation Override
- MAY skip branch creation for experimental work under 4 hours
- MUST create proper branch before any production-bound changes
- MUST document "prototype work" reason in all commit messages

## Commit Process Override
- MAY use simplified commit messages during prototyping:
  ```
  prototype: Brief description of experiment
  
  Note: This is experimental work, not production-ready
  ```
- MUST still get user approval before committing
- MUST provide detailed summary when transitioning to production code

## Documentation Override
- MAY reduce memory bank update frequency during rapid iteration
- MUST complete comprehensive memory bank update before task handoff
- SHOULD include learning summary in activeContext.md

## Example Usage
```bash
# Create prototype branch
git checkout -b spike/new-ui-concept

# Work with simplified process
# When ready for production:
git checkout -b feature/implement-new-ui  # Follow full baseline process
```
```

### Example 2: Emergency Hotfix Protocol

**Problem**: Production issues need immediate attention  
**Solution**: Streamlined emergency procedures

```markdown
---
description: "Emergency hotfix protocol"
globs: ["**/*"]  
alwaysApply: true
---
# Project Override: Emergency Hotfix Protocol

## Scope
For tickets tagged `URGENT` or `HOTFIX` only.

## Branch Creation Override
- MAY work directly on `hotfix/` branches from main
- Branch naming: `hotfix/TICKET-ID--brief-description`
- MUST document emergency justification in first commit

## Plan/Act Mode Override
- MAY skip Plan mode for well-defined fixes under 2 hours
- MUST include detailed problem/solution summary in commit message
- MUST document rollback plan in commit or PR

## Review Process Override
- MAY streamline to single reviewer approval
- MUST include before/after evidence (screenshots, logs)
- MUST document testing performed under time pressure

## Example Emergency Commit Message
```
hotfix(auth): Fix login timeout causing user lockouts - URGENT

Problem: Session timeout misconfiguration causing mass user lockouts
Solution: Corrected timeout value from 30s to 30min in config
Testing: Verified on staging, manual login test successful
Rollback: Revert this commit and restart auth service

Emergency justification: 200+ users locked out, revenue impact
```
```

### Example 3: Client Review Integration

**Problem**: Client needs to review before internal merge  
**Solution**: Additional approval gate

```markdown
---
description: "Client review integration"
globs: ["**/*"]
alwaysApply: true
---
# Project Override: Client Review Process

## Additional Review Gate
After AI summary and before merge:

1. **Tag Client**: Add `@client-reviewer` to PR
2. **Wait for Approval**: Don't merge until client approves
3. **Document Client Feedback**: Update PR with client comments
4. **Handle Client Changes**: If client requests changes, update summary

## Modified Summary Format
Include client-specific context:
```
## AI Summary
[Standard AI summary]

## Client Impact
- Features affected: [list]
- User-facing changes: [description]  
- Testing recommendations: [specific items for client to test]

## Next Steps
- [ ] Client review and approval
- [ ] Address any client feedback
- [ ] Final merge after approval
```

## Client Communication
- Use non-technical language in PR descriptions
- Include screenshots/videos for UI changes
- Provide clear testing instructions
- Explain any temporary limitations
```

### Example 4: Solo Developer Simplification

**Problem**: Single developer doesn't need complex approval processes  
**Solution**: Simplified workflow while maintaining documentation

```markdown
---
description: "Solo developer streamlined workflow"
globs: ["**/*"]
alwaysApply: true
---
# Project Override: Solo Developer Mode

## Simplified Approval Process
Since there's only one developer:

- **Auto-approve commits**: Skip user approval step for commit messages
- **Self-review**: Use commit message as review documentation
- **Simplified summaries**: Focus on what was accomplished, less on handoff

## Modified Commit Process
1. Review changes: `git diff --cached`
2. Write detailed commit message in scratch file
3. Auto-commit without additional approval
4. Include summary in commit message extended description

## Enhanced Commit Messages
Since no PR reviews, commit messages must be comprehensive:
```
feat(api): Add user authentication endpoints

Changes:
- POST /auth/login with email/password validation
- GET /auth/profile for authenticated users  
- JWT token generation and validation middleware

Testing:
- Unit tests for auth functions (100% coverage)
- Manual testing with Postman collection
- Error handling for invalid credentials

Files modified:
- src/auth/routes.js (new)
- src/middleware/auth.js (new)
- tests/auth.test.js (new)

Next work: Add password reset functionality
```

## Memory Bank Adaptation
- **Combine files**: Merge activeContext.md and progress.md for simplicity
- **Focus on decisions**: Document why choices were made
- **Include blockers**: Note any issues for future reference
```

## Customization Best Practices

### 1. Start Small
Begin with minimal overrides and add more as needed:
```markdown
# Phase 1: Just change branch naming
- Use JIRA-123--description format

# Phase 2: Add prototype mode  
- Allow simplified commits for spikes

# Phase 3: Add client review process
- Additional approval gates
```

### 2. Document Why
Always explain the reasoning:
```markdown
## Why This Override Exists
Our client requires visual approval before any UI changes merge.
This adds an additional review step to ensure client satisfaction
before code reaches staging environment.
```

### 3. Set Clear Boundaries
Define exactly when overrides apply:
```markdown
## Scope Limitations
- ONLY applies to tickets tagged 'client-review'
- ONLY for UI/UX changes (not backend logic)  
- DOES NOT apply to emergency hotfixes
```

### 4. Maintain Safety
Keep core safety principles even when customizing:
```markdown
## Non-Negotiable Requirements
Even in prototype mode:
- MUST get user approval before commits (prevents accidents)
- MUST document changes in memory bank (preserves context)
- MUST create proper branches for production code
```

### 5. Review and Iterate
Customize based on team feedback:
```markdown
## Customization Review Schedule
- Weekly team review of process effectiveness
- Monthly review of override usage patterns
- Quarterly assessment of baseline rule updates needed
```

## Common Pitfalls

### ❌ Over-Customizing
**Problem**: Creating too many exceptions reduces consistency  
**Solution**: Start with minimal overrides, add only when clear need

### ❌ Ignoring Safety Principles  
**Problem**: Removing all guardrails leads to the original problems  
**Solution**: Maintain core principles (user approval, documentation, branch hygiene)

### ❌ Not Documenting Changes
**Problem**: Team forgets why customizations exist  
**Solution**: Include rationale in every override

### ❌ Static Customizations
**Problem**: Rules don't evolve with project needs  
**Solution**: Regular review and update cycles

## Testing Your Customizations

### 1. Pilot with One Developer
Test new rules with willing team member before rolling out

### 2. Trial Period
Set time-bounded trials: "Try this for 2 weeks, then evaluate"

### 3. Measure Impact
Track metrics:
- Time to complete tasks
- Number of process violations
- Team satisfaction scores
- Commit message quality

### 4. Gather Feedback
Regular team surveys:
- What's working well?
- What's frustrating?
- What would you change?

## Getting Help

**Process Questions**: Ask team lead about project-specific needs  
**Technical Issues**: Check baseline repository documentation  
**Rule Conflicts**: Review existing rules before adding overrides  
**Team Adoption**: Start small, get feedback, iterate

Remember: The goal is to help your team work more effectively while maintaining quality and safety standards. Customize thoughtfully! 