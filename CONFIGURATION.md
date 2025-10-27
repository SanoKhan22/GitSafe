# Git Branch Manager Configuration Guide

This guide provides comprehensive information about configuring the Git Branch Manager for your specific needs.

## 📁 Configuration File Location

The main configuration file is located at:
```
~/.config/branch_manager/config
```

## ⚙️ Configuration Options

### Core Settings

#### `DEFAULT_BASE_BRANCH`
- **Default**: `main`
- **Description**: The default branch to create new feature branches from
- **Example**: `DEFAULT_BASE_BRANCH=develop`
- **Use Case**: Set to `develop` for GitFlow, `main` for GitHub Flow

#### `DEFAULT_WORKFLOW`
- **Default**: `github-flow`
- **Options**: `github-flow`, `gitflow`, `custom`
- **Description**: The workflow pattern to use for branch naming and operations
- **Example**: `DEFAULT_WORKFLOW=gitflow`

#### `AUTO_CLEANUP_MERGED`
- **Default**: `true`
- **Options**: `true`, `false`
- **Description**: Automatically offer to delete merged branches
- **Example**: `AUTO_CLEANUP_MERGED=false`

### User Interface Settings

#### `REQUIRE_CONFIRMATION`
- **Default**: `true`
- **Options**: `true`, `false`
- **Description**: Require user confirmation for destructive operations
- **Example**: `REQUIRE_CONFIRMATION=false`
- **Note**: Use `false` for automation scripts

#### `CONFLICT_RESOLUTION_TOOL`
- **Default**: `"code --wait"`
- **Description**: Command to launch for manual conflict resolution
- **Examples**:
  - VS Code: `"code --wait"`
  - Sublime Merge: `"smerge"`
  - KDiff3: `"kdiff3"`
  - Vim: `"vim"`
  - Nano: `"nano"`

### Remote Operations

#### `AUTO_FETCH`
- **Default**: `true`
- **Options**: `true`, `false`
- **Description**: Automatically fetch from remote before operations
- **Example**: `AUTO_FETCH=false`
- **Note**: Disable for offline work or slow connections

### Logging and Debugging

#### `LOG_LEVEL`
- **Default**: `INFO`
- **Options**: `DEBUG`, `INFO`, `WARN`, `ERROR`
- **Description**: Minimum log level to record
- **Example**: `LOG_LEVEL=DEBUG`
- **Note**: `DEBUG` provides detailed operation information

### Backup and Retention

#### `BACKUP_RETENTION_DAYS`
- **Default**: `7`
- **Description**: Number of days to keep backups and logs
- **Example**: `BACKUP_RETENTION_DAYS=30`
- **Note**: Longer retention uses more disk space

## 🔄 Workflow Patterns

### GitHub Flow Configuration
```bash
DEFAULT_WORKFLOW=github-flow
DEFAULT_BASE_BRANCH=main
AUTO_CLEANUP_MERGED=true
```

**Branch Prefixes**: `feature/`, `hotfix/`
**Best For**: Continuous deployment, simple workflows

### GitFlow Configuration
```bash
DEFAULT_WORKFLOW=gitflow
DEFAULT_BASE_BRANCH=develop
AUTO_CLEANUP_MERGED=false
```

**Branch Prefixes**: `feature/`, `develop/`, `release/`, `hotfix/`
**Best For**: Scheduled releases, complex projects

### Custom Workflow Configuration
```bash
DEFAULT_WORKFLOW=custom
DEFAULT_BASE_BRANCH=main
```

**Branch Prefixes**: Configurable in `WORKFLOW_PATTERNS`
**Best For**: Existing team conventions

## 🛠️ Advanced Configuration

### Custom Workflow Patterns
Edit the script to modify `WORKFLOW_PATTERNS`:
```bash
declare -A WORKFLOW_PATTERNS=(
    ["github-flow"]="feature/,hotfix/"
    ["gitflow"]="feature/,develop/,release/,hotfix/"
    ["custom"]="feat/,fix/,chore/,docs/"
)
```

### Environment Variables
Override configuration with environment variables:
```bash
export BRANCH_MANAGER_LOG_LEVEL=DEBUG
export BRANCH_MANAGER_AUTO_FETCH=false
./branch_manager.sh status
```

### Command Line Overrides
Use command line options to override configuration:
```bash
# Override workflow
./branch_manager.sh create feature/test --workflow=gitflow

# Override base branch
./branch_manager.sh create feature/test --base=develop

# Disable confirmations
./branch_manager.sh merge feature/test --no-confirm

# Disable auto-fetch
./branch_manager.sh sync --no-fetch
```

## 📂 Directory Structure

The Branch Manager creates the following directory structure:
```
~/.config/branch_manager/
├── config                          # Main configuration file
├── logs/
│   ├── branch_manager.log          # Main application log
│   ├── operations.log              # Operation audit trail
│   ├── operations_YYYYMMDD.log     # Daily operation logs
│   └── operation_stats.txt         # Operation statistics
└── backups/
    ├── OPERATION_branch_timestamp/ # Automatic backups
    └── ROLLBACK_operation_timestamp/ # Rollback points
```

## 🔧 Configuration Examples

### Development Team Setup
```bash
# For active development with frequent merges
DEFAULT_BASE_BRANCH=develop
DEFAULT_WORKFLOW=gitflow
AUTO_CLEANUP_MERGED=true
REQUIRE_CONFIRMATION=false
AUTO_FETCH=true
LOG_LEVEL=INFO
BACKUP_RETENTION_DAYS=14
```

### Production Environment
```bash
# For production deployments with safety checks
DEFAULT_BASE_BRANCH=main
DEFAULT_WORKFLOW=github-flow
AUTO_CLEANUP_MERGED=false
REQUIRE_CONFIRMATION=true
AUTO_FETCH=true
LOG_LEVEL=WARN
BACKUP_RETENTION_DAYS=30
```

### CI/CD Integration
```bash
# For automated CI/CD pipelines
DEFAULT_BASE_BRANCH=main
DEFAULT_WORKFLOW=github-flow
AUTO_CLEANUP_MERGED=true
REQUIRE_CONFIRMATION=false
AUTO_FETCH=true
LOG_LEVEL=ERROR
BACKUP_RETENTION_DAYS=7
```

### Offline Development
```bash
# For offline or slow connection environments
DEFAULT_BASE_BRANCH=main
DEFAULT_WORKFLOW=github-flow
AUTO_CLEANUP_MERGED=true
REQUIRE_CONFIRMATION=true
AUTO_FETCH=false
LOG_LEVEL=INFO
BACKUP_RETENTION_DAYS=7
```

## 🎯 Configuration Best Practices

### Team Consistency
1. **Standardize Workflow**: Choose one workflow pattern for the entire team
2. **Share Configuration**: Use the same base configuration across team members
3. **Document Conventions**: Clearly document branch naming conventions
4. **Regular Updates**: Keep configurations synchronized

### Security Considerations
1. **Confirmation Prompts**: Keep `REQUIRE_CONFIRMATION=true` for production
2. **Backup Retention**: Balance security needs with disk space
3. **Log Levels**: Use appropriate log levels to avoid sensitive information exposure
4. **Access Control**: Ensure configuration files have proper permissions

### Performance Optimization
1. **Auto-Fetch**: Disable for slow connections or large repositories
2. **Log Rotation**: Configure appropriate retention periods
3. **Backup Cleanup**: Regular cleanup of old backups
4. **Debug Mode**: Only enable when troubleshooting

## 🔄 Configuration Management

### Backup Configuration
```bash
# Backup current configuration
cp ~/.config/branch_manager/config ~/.config/branch_manager/config.backup

# Restore configuration
cp ~/.config/branch_manager/config.backup ~/.config/branch_manager/config
```

### Reset to Defaults
```bash
# Via interactive menu
./branch_manager.sh
# Navigate to: Configuration → Reset to defaults

# Or delete configuration file to regenerate
rm ~/.config/branch_manager/config
./branch_manager.sh config
```

### Validate Configuration
```bash
# View current configuration
./branch_manager.sh config

# Test configuration with debug mode
./branch_manager.sh --debug status
```

## 🚀 Quick Configuration Commands

```bash
# View current configuration
./branch_manager.sh config

# Edit configuration file
./branch_manager.sh
# Navigate to: Configuration → Edit configuration file

# Reset to defaults
./branch_manager.sh
# Navigate to: Configuration → Reset to defaults

# View workflow patterns
./branch_manager.sh
# Navigate to: Configuration → Workflow patterns
```

## 📞 Configuration Support

If you need help with configuration:

1. **Built-in Help**: Use the interactive configuration menu
2. **Examples**: Check the examples in this guide
3. **Validation**: Use `./branch_manager.sh config` to verify settings
4. **Reset**: Use reset to defaults if configuration becomes corrupted
5. **Debug**: Enable debug mode to troubleshoot configuration issues

---

For more information, see the main [README.md](README.md) or use the built-in help system.