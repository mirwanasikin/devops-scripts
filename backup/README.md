# Backup Utility

Incremental backup tool using rsync with built-in safety checks and dry-run mode.

## Features

- **Dry-run by default** — Preview changes before executing actual backup
- **Safety validations** — Prevents accidental deletion or root directory operations
- **Incremental backups** — Only copies changed files (rsync-based)
- **Permission preservation** — Maintains file permissions, ownership, and timestamps
- **Detailed output** — Shows transfer progress and statistics

## Requirements

- Linux system with bash
- rsync installed (`dnf install rsync` or `apt install rsync`)

## Usage

### Basic Syntax
```bash
./backup.sh -s /source/path -d /destination/path [-f]
```

### Options

| Option | Description |
|--------|-------------|
| `-s` | Source directory (required) |
| `-d` | Destination directory (required) |
| `-f` | Force live run (skip dry-run) |
| `-h` | Show help guide |

### Examples

**1. Preview backup (dry-run mode)**
```bash
./backup.sh -s /home/user/documents -d /mnt/backup
```
This will show what would be copied/deleted without making actual changes.

**2. Execute actual backup**
```bash
./backup.sh -s /home/user/documents -d /mnt/backup -f
```

**3. Backup with trailing slash behavior**
```bash
# Copies contents of documents/ into backup/
./backup.sh -s /home/user/documents/ -d /mnt/backup

# Creates documents/ folder inside backup/
./backup.sh -s /home/user/documents -d /mnt/backup
```

## Safety Features

### Root Directory Protection
```bash
# These will be rejected:
./backup.sh -s / -d /mnt/backup     # ❌ Source is root
./backup.sh -s /home -d /           # ❌ Destination is root
```

### Directory Validation
- Checks if source directory exists
- Checks if destination directory exists
- Prevents typos that could cause data loss

### Delete Sync Behavior
The script uses `rsync --delete` which means:
- Files removed from source will be removed from destination
- **Always run dry-run first** to verify changes

## How It Works

1. **Validates inputs** — Checks all directories exist and aren't root
2. **Normalizes paths** — Ensures consistent trailing slash behavior
3. **Shows configuration** — Displays source, destination, and mode
4. **Executes rsync** — Performs the backup operation

## Automation Example

Create a cron job for automated backups:
```bash
# Edit crontab
crontab -e

# Run backup daily at 2 AM
0 2 * * * /path/to/backup.sh -s /home/user/documents -d /mnt/backup -f >> /var/log/backup.log 2>&1
```

## Common Use Cases

### Daily Document Backup
```bash
./backup.sh -s ~/documents -d /mnt/external/docs-backup -f
```

### Project Code Backup
```bash
./backup.sh -s ~/projects -d /backup/code -f
```

### Server Configuration Backup
```bash
./backup.sh -s /etc -d /backup/server-config -f
```

## Troubleshooting

**"Source not found" error**
- Verify the source path exists
- Check for typos in the path
- Ensure you have read permissions

**"Destiny not found" error**
- Create the destination directory first: `mkdir -p /destination/path`
- Verify mount points are accessible (for external drives)

**Permission denied errors**
- Run with appropriate permissions (may need sudo for system directories)
- Check ownership of destination directory

## Technical Details

**rsync flags used:**
- `-a` — Archive mode (preserves permissions, timestamps, symlinks)
- `-v` — Verbose output
- `-h` — Human-readable file sizes
- `--delete` — Remove files from destination that don't exist in source
- `--dry-run` — Preview mode (default behavior)

## Author

**M. Irwan Asikin**
- GitHub: [@mirwanasikin](https://github.com/mirwanasikina)
