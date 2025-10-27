# Git Branch Manager

A comprehensive branch management system for safe Git operations with intelligent conflict resolution, automated workflows, and seamless GitHub integration.

## 🚀 Features

- **Safe Branch Operations**: Create, switch, and merge branches with comprehensive safety checks
- **Intelligent Conflict Resolution**: Automated conflict detection and guided resolution
- **Remote Synchronization**: Seamless upstream tracking and synchronization
- **Interactive UI**: Beautiful command-line interface with menu-driven operations
- **Workflow Management**: Support for GitFlow, GitHub Flow, and custom workflows
- **Error Recovery**: Comprehensive error handling with rollback capabilities
- **Audit Trail**: Detailed operation logging and statistics
- **GitHub Integration**: Seamless integration with existing push_to_github.sh script

## 📦 Installation

1. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/your-repo/branch_manager.sh
   # or clone the repository
   git clone https://github.com/your-repo/git-branch-manager.git
   ```

2. **Make it executable:**
   ```bash
   chmod +x branch_manager.sh
   ```

3. **Run initial setup:**
   ```bash
   ./branch_manager.sh config
   ```

## 🎯 Quick Start

### Interactive Mode
```bash
./branch_manager.sh
```
Navigate through the beautiful menu system with numbered options.

### Command Line Mode
```bash
# Create a new feature branch
./branch_manager.sh create feature/user-authentication

# Switch to a branch
./branch_manager.sh switch main

# Merge a branch
./branch_manager.sh merge feature/user-authentication main

# Sync with upstream
./branch_manager.sh sync

# Show status
./branch_manager.sh status --all

# Clean up merged branches
./branch_manager.sh cleanup
```

## 📚 Usage Guide

### Branch Operations

#### Creating Branches
```bash
# Basic branch creation
./branch_manager.sh create feature/new-feature

# Create from specific base branch
./branch_manager.sh create feature/new-feature develop

# Workflow-based creation
./branch_manager.sh create --workflow-type=feature user-authentication

# With options
./branch_manager.sh create feature/test --no-confirm --base=develop
```

#### Switching Branches
```bash
# Switch to existing branch
./branch_manager.sh switch main

# Force switch (handles uncommitted changes)
./branch_manager.sh switch feature/branch --force
```

#### Merging Branches
```bash
# Interactive merge
./branch_manager.sh merge feature/branch

# Merge with specific strategy
./branch_manager.sh merge feature/branch main --strategy=fast-forward

# Merge with workflow validation
./branch_manager.sh merge feature/branch --workflow-validate
```

### Remote Operations

#### Synchronization
```bash
# Sync current branch
./branch_manager.sh sync

# Sync specific branch
./branch_manager.sh sync feature/branch

# Sync with rebase strategy
./branch_manager.sh sync --strategy=rebase
```

### Status and Information

#### Branch Status
```bash
# Current branch status
./branch_manager.sh status

# All branches status
./branch_manager.sh status --all

# Verbose status with remote info
./branch_manager.sh status --verbose --remote
```

### Cleanup Operations

#### Branch Cleanup
```bash
# Clean up merged branches
./branch_manager.sh cleanup

# Dry run (show what would be deleted)
./branch_manager.sh cleanup --dry-run

# Auto-confirm cleanup
./branch_manager.sh cleanup --auto
```

### Workflow Commands

#### Complete Workflows
```bash
# Complete feature development workflow
./branch_manager.sh workflow complete-feature

# Merge and push in one command
./branch_manager.sh workflow merge-and-push feature/branch main

# Set up shared configuration
./branch_manager.sh workflow setup-config
```

## ⚙️ Configuration

### Configuration File
The configuration file is located at `~/.config/branch_manager/config`.

#### Default Settings
```bash
# Default base branch for new feature branches
DEFAULT_BASE_BRANCH=main

# Workflow pattern (github-flow, gitflow, custom)
DEFAULT_WORKFLOW=github-flow

# Automatically cleanup merged branches
AUTO_CLEANUP_MERGED=true

# Conflict resolution tool command
CONFLICT_RESOLUTION_TOOL="code --wait"

# Backup retention in days
BACKUP_RETENTION_DAYS=7

# Logging level (DEBUG, INFO, WARN, ERROR)
LOG_LEVEL=INFO

# Automatically fetch from remote before operations
AUTO_FETCH=true

# Require confirmation for destructive operations
REQUIRE_CONFIRMATION=true
```

### Workflow Patterns

#### GitHub Flow
- **Branches**: `feature/`, `hotfix/`
- **Flow**: Create feature branches from main, merge back to main
- **Best for**: Continuous deployment, simple workflows

#### GitFlow
- **Branches**: `feature/`, `develop/`, `release/`, `hotfix/`
- **Flow**: Structured branching with develop and main branches
- **Best for**: Scheduled releases, complex projects

#### Custom
- **Branches**: Configurable prefixes
- **Flow**: Team-specific conventions
- **Best for**: Existing team workflows

### Command Line Options

#### Global Options
- `--debug`: Enable debug logging
- `--no-confirm`: Skip confirmation prompts
- `--no-fetch`: Skip automatic fetching
- `--workflow=<name>`: Use specific workflow
- `--base=<branch>`: Override default base branch

## 🛠️ Advanced Features

### Error Handling and Recovery

#### Rollback Points
The system automatically creates rollback points before destructive operations:
```bash
# Access rollback management
./branch_manager.sh
# Navigate to: Cleanup Operations → Manage rollback points
```

#### Error Categories
- **Network Issues**: Connection problems, remote access
- **Authentication**: Credential and permission issues
- **Repository**: Git repository integrity problems
- **Conflicts**: Merge and rebase conflicts
- **Permissions**: File system access issues

### Logging and Audit Trail

#### Log Files
- **Main Log**: `~/.config/branch_manager/logs/branch_manager.log`
- **Operations Log**: `~/.config/branch_manager/logs/operations.log`
- **Daily Logs**: `~/.config/branch_manager/logs/operations_YYYYMMDD.log`

#### Operation Statistics
Track success rates and performance:
```bash
# Access via interactive menu
./branch_manager.sh
# Navigate to: Cleanup Operations → Logging and audit trail → Show operation statistics
```

### Backup System

#### Automatic Backups
- Created before all destructive operations
- Configurable retention period
- Includes repository state and metadata

#### Backup Management
```bash
# Access backup management
./branch_manager.sh
# Navigate to: Cleanup Operations → Manage backups
```

## 🔧 Troubleshooting

### Common Issues

#### "Working tree is not clean"
**Solution**: Stash or commit your changes before operations
```bash
git stash push -m "Work in progress"
# or
git add . && git commit -m "WIP: temporary commit"
```

#### "Branch does not exist"
**Solution**: Check branch name and create if needed
```bash
./branch_manager.sh status --all  # List all branches
./branch_manager.sh create branch-name  # Create if needed
```

#### "Merge conflicts"
**Solution**: Use the interactive conflict resolution
```bash
./branch_manager.sh  # Interactive mode
# Navigate to: Merge Operations → Resolve conflicts
```

#### "Remote connection failed"
**Solution**: Check network and credentials
```bash
git remote -v  # Check remote URLs
ssh -T git@github.com  # Test SSH connection
git config --list | grep user  # Check credentials
```

#### "Permission denied"
**Solution**: Check file permissions and access
```bash
ls -la .git/  # Check Git directory permissions
whoami  # Check current user
```

### Debug Mode
Enable detailed logging for troubleshooting:
```bash
./branch_manager.sh --debug
# or via interactive menu: Cleanup Operations → Logging and audit trail → Enable debug mode
```

### Troubleshooting Reports
Generate comprehensive diagnostic reports:
```bash
# Via interactive menu
./branch_manager.sh
# Navigate to: Cleanup Operations → Logging and audit trail → Generate troubleshooting report
```

## 🔗 Integration

### GitHub Integration
The branch manager integrates seamlessly with `push_to_github.sh`:

1. **Automatic Detection**: Finds push script in common locations
2. **Shared Configuration**: Uses consistent settings
3. **Post-Merge Push**: Offers to push after successful merges
4. **Error Handling**: Provides recovery options for push failures

### IDE Integration
Configure your preferred merge tool:
```bash
# VS Code
CONFLICT_RESOLUTION_TOOL="code --wait"

# Sublime Merge
CONFLICT_RESOLUTION_TOOL="smerge"

# KDiff3
CONFLICT_RESOLUTION_TOOL="kdiff3"
```

## 📊 Performance

### Optimization Features
- **Shallow Operations**: Efficient Git operations
- **Parallel Processing**: Where applicable
- **Caching**: Frequently accessed information
- **Log Rotation**: Automatic cleanup of large logs

### Resource Management
- **Memory Efficient**: Minimal memory footprint
- **Disk Space**: Automatic cleanup of old backups and logs
- **Network Optimized**: Efficient remote operations

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Testing
```bash
# Test basic functionality
./branch_manager.sh --version
./branch_manager.sh config
./branch_manager.sh status

# Test interactive interface
./branch_manager.sh
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

### Getting Help
1. **Built-in Help**: `./branch_manager.sh help`
2. **Interactive Guide**: `./branch_manager.sh` → Help & Information
3. **Troubleshooting**: Generate diagnostic reports
4. **Documentation**: This README and in-script help

### Reporting Issues
When reporting issues, please include:
1. Branch manager version: `./branch_manager.sh --version`
2. Git version: `git --version`
3. Operating system and shell
4. Steps to reproduce
5. Error messages and logs
6. Troubleshooting report if available

## 🎉 Acknowledgments

- Git community for excellent documentation
- GitHub for hosting and collaboration tools
- Contributors and testers
- Open source community for inspiration

---

**Happy branching! 🌿**