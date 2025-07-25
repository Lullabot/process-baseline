#!/bin/bash

# Process Baseline Installation Script
# Installs Lullabot process baseline cursor rules into a project

set -euo pipefail

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/Lullabot/process-baseline/main"

# Determine if we're running locally or remotely
if [[ -n "${BASH_SOURCE[0]:-}" ]] && [[ -f "${BASH_SOURCE[0]}" ]]; then
    # Running locally from the repository
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    BASELINE_DIR="$(dirname "$SCRIPT_DIR")/baseline-rules"
    LOCAL_MODE=true
else
    # Running remotely via curl | bash
    SCRIPT_DIR=""
    BASELINE_DIR=""
    LOCAL_MODE=false
fi

TARGET_DIR=".cursor/rules"
BACKUP_DIR=".cursor/rules-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Usage information
usage() {
    cat << EOF
Process Baseline Installation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --merge         Merge with existing rules (default)
    --replace       Replace existing rules completely
    --backup-only   Create backup without installing
    --dry-run       Show what would be done without making changes
    --help          Show this help message

EXAMPLES:
    $0                          # Merge baseline rules with existing
    $0 --replace               # Replace all existing rules  
    $0 --dry-run --merge       # Preview merge operation
    $0 --backup-only           # Just backup existing rules

REMOTE USAGE:
    curl -fsSL https://raw.githubusercontent.com/Lullabot/process-baseline/main/install/install.sh | bash

The script will:
1. Backup existing .cursor/rules if they exist
2. Install baseline rules (core.mdc, workflow-enforcement.mdc, memory-bank.mdc)
3. Merge or replace based on chosen mode
4. Create .gitignore entries for temp files

EOF
}

# Download file from GitHub
download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl > /dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget > /dev/null 2>&1; then
        wget -q "$url" -O "$output"
    else
        log_error "Neither curl nor wget found. Cannot download files."
        exit 1
    fi
}

# Parse command line arguments
MODE="merge"
DRY_RUN=false
BACKUP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --merge)
            MODE="merge"
            shift
            ;;
        --replace)
            MODE="replace"
            shift
            ;;
        --backup-only)
            BACKUP_ONLY=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validation
validate_environment() {
    log_info "Validating environment..."
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository. Please run from project root."
        exit 1
    fi
    
    if [[ "$LOCAL_MODE" == "true" ]]; then
        # Check if baseline files exist locally
        if [[ ! -d "$BASELINE_DIR" ]]; then
            log_error "Baseline rules directory not found: $BASELINE_DIR"
            exit 1
        fi
        
        local required_files=("core.mdc" "workflow-enforcement.mdc" "memory-bank.mdc")
        for file in "${required_files[@]}"; do
            if [[ ! -f "$BASELINE_DIR/$file" ]]; then
                log_error "Required baseline file missing: $file"
                exit 1
            fi
        done
    else
        log_info "Running in remote mode - files will be downloaded from GitHub"
    fi
    
    log_success "Environment validation passed"
}

# Create backup of existing rules
backup_existing_rules() {
    if [[ -d "$TARGET_DIR" ]]; then
        log_info "Creating backup of existing rules..."
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] Would create backup: $BACKUP_DIR"
            return
        fi
        
        cp -r "$TARGET_DIR" "$BACKUP_DIR"
        log_success "Backup created: $BACKUP_DIR"
    else
        log_info "No existing rules to backup"
    fi
}

# Install baseline rules
install_baseline_rules() {
    log_info "Installing baseline rules..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would create directory: $TARGET_DIR"
        log_info "[DRY RUN] Would install: core.mdc, workflow-enforcement.mdc, memory-bank.mdc"
        return
    fi
    
    # Create target directory
    mkdir -p "$TARGET_DIR"
    
    local required_files=("core.mdc" "workflow-enforcement.mdc" "memory-bank.mdc")
    
    if [[ "$LOCAL_MODE" == "true" ]]; then
        # Copy from local baseline directory
        for file in "${required_files[@]}"; do
            cp "$BASELINE_DIR/$file" "$TARGET_DIR/"
            log_info "Installed: $file"
        done
    else
        # Download from GitHub
        for file in "${required_files[@]}"; do
            local url="$GITHUB_REPO/baseline-rules/$file"
            log_info "Downloading: $file"
            download_file "$url" "$TARGET_DIR/$file"
            log_info "Installed: $file"
        done
    fi
    
    log_success "Baseline rules installed"
}

# Merge existing project-specific rules
merge_project_rules() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_info "No existing rules to merge"
        return
    fi
    
    log_info "Merging existing project-specific rules..."
    
    # Find project-specific files (not baseline files)
    local baseline_files=("core.mdc" "workflow-enforcement.mdc" "memory-bank.mdc")
    
    while IFS= read -r -d '' file; do
        local filename=$(basename "$file")
        local is_baseline=false
        
        for baseline_file in "${baseline_files[@]}"; do
            if [[ "$filename" == "$baseline_file" ]]; then
                is_baseline=true
                break
            fi
        done
        
        if [[ "$is_baseline" == "false" ]]; then
            if [[ "$DRY_RUN" == "true" ]]; then
                log_info "[DRY RUN] Would preserve project file: $filename"
            else
                cp "$file" "$TARGET_DIR/"
                log_info "Preserved project file: $filename"
            fi
        fi
    done < <(find "$BACKUP_DIR" -type f -print0)
}

# Setup gitignore entries
setup_gitignore() {
    log_info "Setting up .gitignore entries..."
    
    local gitignore_entries=(
        "# Process baseline temp files"
        "temp_scratch_*.md"
        ".cursor/rules-backup-*"
    )
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would add to .gitignore:"
        printf '%s\n' "${gitignore_entries[@]}"
        return
    fi
    
    # Add entries to .gitignore if not already present
    for entry in "${gitignore_entries[@]}"; do
        if [[ -f ".gitignore" ]] && grep -Fxq "$entry" .gitignore; then
            continue
        fi
        echo "$entry" >> .gitignore
    done
    
    log_success ".gitignore entries added"
}

# Create project customization template
create_customization_template() {
    local template_file="$TARGET_DIR/project-overrides.md.example"
    
    if [[ -f "$template_file" ]]; then
        log_info "Customization template already exists"
        return
    fi
    
    log_info "Creating project customization template..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would create: $template_file"
        return
    fi
    
    cat > "$template_file" << 'EOF'
# Project-Specific Overrides

This file provides examples of how to override baseline process rules for project-specific needs.

## Example Override: Fast Prototype Mode

```markdown
---
description: "Project-specific overrides for fast prototyping"
globs: 
alwaysApply: true
---

# Project Override: Fast Prototype Mode

For spike/prototype tickets PROJ-XXX through PROJ-YYY:

## Branch Creation Override
- MAY skip branch creation for experimental work under 4 hours
- MUST create proper branch before any production-bound changes
- MUST document "prototype work" reason in commit messages

## Commit Process Override  
- MAY use simplified commit messages for prototype commits
- MUST still get user approval before committing
- MUST include detailed summary in final handoff

## Documentation Override
- MAY reduce memory bank update frequency during rapid iteration
- MUST complete comprehensive update before task handoff
```

## Example Override: Hotfix Process

```markdown
# Project Override: Emergency Hotfix Protocol

For URGENT tagged tickets only:

## Streamlined Process
- MAY work directly on hotfix branches from main
- MAY skip Plan mode for well-defined emergency fixes
- MUST still document all changes thoroughly
- MUST include detailed testing summary
```

## How to Activate Overrides

1. Copy desired override content above
2. Paste into new `.mdc` file in `.cursor/rules/`
3. Customize for your project's specific needs
4. Document when and why overrides apply
5. Test with team to ensure effectiveness

## Guidelines for Good Overrides

- Be specific about when override applies
- Maintain core safety principles (user approval, documentation)
- Explain reasoning for deviation from baseline
- Include examples of proper usage
- Set clear boundaries and exceptions
EOF

    log_success "Customization template created: $template_file"
}

# Display summary
display_summary() {
    log_info "Installation Summary"
    echo "=================="
    echo "Mode: $MODE"
    echo "Local Mode: $LOCAL_MODE"
    echo "Dry Run: $DRY_RUN"
    echo "Backup Only: $BACKUP_ONLY"
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "Backup Created: $BACKUP_DIR"
    fi
    
    if [[ "$BACKUP_ONLY" == "false" ]]; then
        echo "Files Installed:"
        echo "  - core.mdc (Plan/Act mode system)"
        echo "  - workflow-enforcement.mdc (Branch/commit/summary rules)"
        echo "  - memory-bank.mdc (Documentation requirements)"
        echo "  - project-overrides.md.example (Customization template)"
    fi
    
    echo ""
    log_success "Installation complete!"
    
    if [[ "$BACKUP_ONLY" == "false" && "$DRY_RUN" == "false" ]]; then
        echo ""
        log_info "Next Steps:"
        echo "1. Review installed rules in .cursor/rules/"
        echo "2. Customize using project-overrides.md.example as guide"
        echo "3. Initialize memory-bank/ directory if not exists"
        echo "4. Test with your team and iterate as needed"
        echo ""
        log_info "For updates: Re-run this script to get latest baseline rules"
    fi
}

# Main execution
main() {
    log_info "Starting Process Baseline Installation"
    log_info "Repository: https://github.com/Lullabot/process-baseline"
    echo ""
    
    validate_environment
    
    if [[ "$BACKUP_ONLY" == "true" ]]; then
        backup_existing_rules
        display_summary
        return
    fi
    
    backup_existing_rules
    
    if [[ "$MODE" == "replace" ]]; then
        log_warning "Replace mode: existing rules will be overwritten"
        install_baseline_rules
    else
        install_baseline_rules
        merge_project_rules
    fi
    
    setup_gitignore
    create_customization_template
    display_summary
}

# Execute main function
main "$@" 