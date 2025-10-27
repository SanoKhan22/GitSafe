# Git Branch Manager Command Reference

Complete reference for all Git Branch Manager commands, options, and usage patterns.

## 📋 Table of Contents

- [Core Commands](#core-commands)
- [Workflow Commands](#workflow-commands)
- [Global Options](#global-options)
- [Command-Specific Options](#command-specific-options)
- [Interactive Mode](#interactive-mode)
- [Examples](#examples)

## 🔧 Core Commands

### `create`
Create a new branch with safety checks and workflow validation.

**Syntax:**
```bash
./branch_manager.sh create <branch-name> [base-branch] [options]
./branch_manager.sh create --workflow-type=<type> <description> [options]
```

**Arguments:**
- `branch-name`: Name of the new branch to create
- `base-branch`: Base branch to create from (default: configured base branch)
- `description`: Description for workflow-based naming

**Options:**
- `--workflow-type=<type>`: Create workflow-specific branch (feature, hotfix, release)
- `--base=<branch>`: Override default base branch
- `--no-fetch`: Skip fetching from remote
- `--no-confirm`: Skip confirmation prompts

**Examples:**
```bash
# Basic branch creation
./branch_manager.sh create feature/user-authentication

# Create from specific base
./branch_manager.sh create feature/api-integration develop

# Workflow-based creation
./branch_manager.sh create --workflow-type=feature user-dashboard

# With options
./branch_manager.sh create hotfix/security-fix --base=main --no-confirm
```

### `switch`
Switch to an existing branch with uncommitted change handling.

**Syntax:**
```bash
./branch_manager.sh switch <branch-name> [options]
```

**Arguments:**
- `branch-name`: Name of the branch to switch to

**Options:**
- `--force`: Force switch even with uncommitted changes
- `--no-confirm`: Skip confirmation prompts

**Examples:**
```bash
# Basic branch switch
./branch_manager.sh switch main

# Force switch with uncommitted changes
./branch_manager.sh switch feature/branch --force
```

### `merge`
Merge branches with intelligent conflict resolution.

**Syntax:**
```bash
./branch_manager.sh merge <source-branch> [target-branch] [options]
```

**Arguments:**
- `source-branch`: Branch to merge from
- `target-branch`: Branch to merge into (default: current branch)

**Options:**
- `--strategy=<type>`: Merge strategy (auto, fast-forward, merge-commit)
- `--no-sync`: Skip syncing target branch
- `--workflow-validate`: Enable workflow validation
- `--no-confirm`: Skip confirmation prompts

**Examples:**
```bash
# Basic merge
./branch_manager.sh merge feature/user-login

# Merge with specific target
./branch_manager.sh merge feature/api main

# Fast-forward merge
./branch_manager.sh merge feature/hotfix --strategy=fast-forward

# With workflow validation
./branch_manager.sh merge feature/branch --workflow-validate
```

### `sync`
Synchronize branches with upstream repositories.

**Syntax:**
```bash
./branch_manager.sh sync [branch-name] [options]
```

**Arguments:**
- `branch-name`: Branch to sync (default: current branch)

**Options:**
- `--strategy=<type>`: Sync strategy (auto, pull, rebase)
- `--no-confirm`: Skip confirmation prompts

**Examples:**
```bash
# Sync current branch
./branch_manager.sh sync

# Sync specific branch
./branch_manager.sh sync main

# Sync with rebase
./branch_manager.sh sync feature/branch --strategy=rebase
```

### `status`
Display branch and repository status information.

**Syntax:**
```bash
./branch_manager.sh status [options]
```

**Options:**
- `--all`: Show all branches
- `--remote`: Include remote branch information
- `--verbose`: Show detailed information

**Examples:**
```bash
# Basic status
./branch_manager.sh status

# All branches
./branch_manager.sh status --all

# Verbose with remote info
./branch_manager.sh status --verbose --remote
```

### `cleanup`
Clean up merged branches and perform maintenance.

**Syntax:**
```bash
./branch_manager.sh cleanup [target-branch] [options]
```

**Arguments:**
- `target-branch`: Branch to check merges against (default: configured base branch)

**Options:**
- `--auto`: Auto-confirm all deletions
- `--dry-run`: Show what would be deleted without deleting
- `--no-confirm`: Skip confirmation prompts

**Examples:**
```bash
# Basic cleanup
./branch_manager.sh cleanup

# Dry run to see what would be deleted
./branch_manager.sh cleanup --dry-run

# Auto-confirm cleanup
./branch_manager.sh cleanup main --auto
```

## 🔄 Workflow Commands

### `workflow complete-feature`
Complete the entire feature development workflow.

**Syntax:**
```bash
./branch_manager.sh workflow complete-feature [target-branch]
```

**Description:**
1. Syncs current feature branch
2. Switches to target branch and syncs
3. Merges feature branch
4. Cleans up merged branch
5. Pushes to GitHub

**Example:**
```bash
./branch_manager.sh workflow complete-feature main
```

### `workflow merge-and-push`
Merge a branch and push to GitHub in one operation.

**Syntax:**
```bash
./branch_manager.sh workflow merge-and-push <source-branch> [target-branch]
```

**Example:**
```bash
./branch_manager.sh workflow merge-and-push feature/api main
```

### `workflow setup-config`
Set up shared configuration between branch manager and push script.

**Syntax:**
```bash
./branch_manager.sh workflow setup-config
```

## 🌐 Global Options

These options can be used with any command:

- `--debug`: Enable debug logging for detailed operation information
- `--no-confirm`: Skip all confirmation prompts (useful for automation)
- `--no-fetch`: Skip automatic fetching from remote repositories
- `--workflow=<name>`: Use specific workflow (github-flow, gitflow, custom)
- `--base=<branch>`: Override default base branch for operations
- `-h, --help`: Show command-specific help information
- `-v, --version`: Show version information

## 🎛️ Command-Specific Options

### Create Command Options
- `--workflow-type=feature|hotfix|release`: Create workflow-specific branch
- `--base=<branch>`: Create from specific base branch

### Merge Command Options
- `--strategy=auto|fast-forward|merge-commit`: Choose merge strategy
- `--no-sync`: Skip syncing target branch before merge
- `--workflow-validate`: Enable workflow-specific validation

### Sync Command Options
- `--strategy=auto|pull|rebase`: Choose synchronization strategy

### Status Command Options
- `--all`: Show information for all branches
- `--remote`: Include remote repository information
- `--verbose`: Show detailed diagnostic information

### Cleanup Command Options
- `--auto`: Automatically confirm all branch deletions
- `--dry-run`: Show what would be deleted without actually deleting

## 🖥️ Interactive Mode

Launch interactive mode by running without arguments:
```bash
./branch_manager.sh
```

### Menu Structure
1. **Branch Operations**
   - Create new branch
   - Switch to branch
   - List all branches
   - Show branch details
   - Delete branch

2. **Merge Operations**
   - Merge branch (interactive)
   - Show merge preview
   - Resolve conflicts
   - Complete merge
   - Abort merge

3. **Remote Synchronization**
   - Sync current branch with upstream
   - Fetch from all remotes
   - Manage upstream tracking
   - Show remote status
   - Handle sync conflicts

4. **Repository Status**
   - Show branch status (current)
   - Show all branches status
   - Repository health check
   - Working tree status
   - Remote repositories info
   - Recent operations log

5. **Cleanup Operations**
   - Clean up merged branches
   - Manage backups
   - Manage rollback points
   - Logging and audit trail
   - Clean up old backups
   - Repository maintenance

6. **Configuration**
   - View current configuration
   - Edit configuration file
   - Reset to defaults
   - Workflow patterns

7. **Help & Information**
   - Command line usage
   - Workflow examples
   - Troubleshooting guide
   - About Branch Manager

## 📚 Examples

### Basic Workflow Examples

**GitHub Flow:**
```bash
# Create feature branch
./branch_manager.sh create feature/user-auth

# Work on feature, then merge
./branch_manager.sh merge feature/user-auth main

# Clean up
./branch_manager.sh cleanup
```

**GitFlow:**
```bash
# Create feature from develop
./branch_manager.sh create feature/shopping-cart develop

# Merge back to develop
./branch_manager.sh merge feature/shopping-cart develop

# Create release
./branch_manager.sh create release/v1.2.0 develop
```

### Advanced Usage Examples

**Automated Workflow:**
```bash
# Create and work on feature (no confirmations)
./branch_manager.sh create feature/api --no-confirm
./branch_manager.sh merge feature/api main --no-confirm --strategy=fast-forward
./branch_manager.sh cleanup --auto
```

**Debugging and Troubleshooting:**
```bash
# Enable debug mode
./branch_manager.sh --debug status --all

# Check specific operation
./branch_manager.sh --debug merge feature/branch main
```

**Offline Development:**
```bash
# Work without fetching
./branch_manager.sh create feature/offline --no-fetch
./branch_manager.sh switch main --no-fetch
./branch_manager.sh merge feature/offline --no-sync
```

### Error Recovery Examples

**Rollback Operations:**
```bash
# Access via interactive mode
./branch_manager.sh
# Navigate to: Cleanup Operations → Manage rollback points
```

**Conflict Resolution:**
```bash
# Start merge that has conflicts
./branch_manager.sh merge feature/conflicted

# Use interactive conflict resolution
./branch_manager.sh
# Navigate to: Merge Operations → Resolve conflicts
```

## 🔍 Command Help

Get help for specific commands:
```bash
./branch_manager.sh create --help
./branch_manager.sh merge --help
./branch_manager.sh status --help
```

## 📊 Exit Codes

- `0`: Success
- `1`: General error or user cancellation
- `2`: Invalid arguments or configuration
- `124`: Timeout (in non-interactive mode)
- `130`: Interrupted by user (Ctrl+C)

## 🚀 Tips and Best Practices

1. **Use Interactive Mode**: Great for learning and complex operations
2. **Enable Debug Mode**: When troubleshooting issues
3. **Dry Run First**: Use `--dry-run` with cleanup operations
4. **Workflow Validation**: Use `--workflow-validate` for team consistency
5. **Automation**: Use `--no-confirm` for scripts and CI/CD
6. **Regular Sync**: Keep branches synchronized with `sync` command
7. **Status Checks**: Use `status --all` to monitor repository health

---

For more information, see [README.md](README.md) and [CONFIGURATION.md](CONFIGURATION.md).