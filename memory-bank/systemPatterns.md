# System Patterns: Process Baseline

## Architecture Patterns

### Repository Structure Pattern
```
process-baseline/
├── README.md                    # Main documentation & usage
├── baseline-rules/              # Core .cursor/rules files
│   ├── core.mdc                # Plan/Act mode system  
│   ├── memory-bank.mdc         # Memory bank requirements
│   ├── workflow-enforcement.mdc # Branch/commit/summary rules
│   └── examples/               # Customization templates
├── install/                    # Installation tooling
│   └── install.sh              # Copy/merge script
├── docs/                       # Documentation
│   ├── customization-guide.md
│   └── pain-points-addressed.md
└── memory-bank/                # Project memory bank
```

### Rule File Pattern (MDC Structure)
```yaml
---
description: "Clear description of rule purpose"
globs:
alwaysApply: true
---

# Rule Content with:
- Problem Solved sections (explaining why)
- Implementation sections (explaining how)
- Customization Guidelines (what can be overridden)
- Examples (good vs bad practices)
```

## Workflow Patterns

### Branch Naming Convention
- `feature/BASELINE-{issue-number}--{short-description}`
- Example: `feature/BASELINE-2--improve-character-limits`

### Scratch File Pattern
Used for commit messages, PR descriptions, and AI summaries to avoid shell escaping:
```bash
# Create content in scratch file
cat > temp_scratch_commit_msg.md << 'EOF'
commit message content
EOF

# Use scratch file
git commit -F temp_scratch_commit_msg.md

# Cleanup
rm temp_scratch_commit_msg.md
```

### Issue/PR Workflow
1. **Create issue** with detailed problem analysis
2. **Create feature branch** following naming convention
3. **Implement solution** with clear commit messages
4. **Create PR** with comprehensive description
5. **Post AI summary** following new character limit guidelines

## Code Patterns

### Installation Script Pattern
- Support `--merge` (default) and `--replace` modes
- Automatic backup with timestamp: `.cursor/rules-backup-YYYYMMDD-HHMMSS`
- Environment validation before making changes
- Detailed logging of all actions taken
- Error handling with graceful failures

### Memory Bank Integration Pattern
- Six core files with defined purposes and relationships
- Update triggers based on specific events
- Mermaid diagrams showing file relationships
- Clear guidelines for when and how to update

### Character Limit Management Pattern
- **Differentiated treatment**: Initial vs follow-up prompts
- **Priority ordering**: Full initial prompt > key decisions > details
- **Smart truncation**: Preserve decision-making context over minor details
- **Clear rationale**: Explain why different limits for different prompt types

## Documentation Patterns

### Problem-Solution Documentation
Every rule includes:
- **Problem Solved**: Clear explanation of what issue this addresses
- **Implementation Steps**: Specific actions required
- **Customization Guidelines**: What CAN and CANNOT be overridden
- **Examples**: Good vs bad practices with explanations

### Customization Support Pattern
- Allow project-specific overrides through documented mechanisms
- Provide clear guidance on what should vs shouldn't be customized
- Include examples for common customization scenarios
- Maintain compatibility with baseline updates

## Error Recovery Patterns

### Installation Failures
- Automatic restoration from backup if installation fails
- Clear error messages with suggested fixes
- Environment validation before attempting changes
- Rollback procedures for partial installations

### Rule Conflicts
- Detection of conflicting rules during merge
- User prompts for resolution strategies
- Backup preservation during conflict resolution
- Documentation of override decisions

## Quality Patterns

### Validation Patterns
- YAML frontmatter validation in MDC files
- Markdown linting standards (80-char line length, proper heading structure)
- File ending requirements (single trailing newline)
- Content validation for required sections

### Testing Patterns
- Examples that can be validated against real scenarios
- Documentation that includes both positive and negative examples
- Clear success criteria for each implementation
- Verification steps for installation and usage

## Security Patterns

### File Handling
- Use of `.gitignore` to prevent committing scratch files
- Secure backup naming to avoid conflicts
- Proper cleanup of temporary files
- Safe file operations with error checking

### User Approval Gates
- Mandatory user approval for commits using scratch files
- Plan/Act mode requiring explicit user permission to proceed
- Clear indication of what actions will be taken before execution
- Ability to abort operations at approval gates

## Performance Patterns

### Character Limit Optimization
- Total limit increase (4048 → 8000) balanced against readability
- Smart truncation that preserves most valuable information
- Priority-based space allocation when approaching limits
- Efficient storage of context without redundancy

### Installation Efficiency
- Single script handles multiple installation modes
- Parallel processing where safe (file operations)
- Minimal dependencies (standard Unix tools)
- Fast backup and restore operations

## Integration Patterns

### GitHub CLI Integration
- Consistent use of `gh` commands for issues, PRs, and comments
- Scratch file pattern for complex GitHub operations
- Issue linking through commit messages and PR descriptions
- Automated comment posting for AI summaries

### Cursor IDE Integration
- MDC file format for maximum Cursor compatibility
- Rule precedence understanding (alwaysApply: true)
- Memory bank integration with Cursor's context system
- Plan/Act mode that works with Cursor's execution model 