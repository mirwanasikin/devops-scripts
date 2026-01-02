# DevOps Scripts

Collection of production-ready bash scripts for system administration, automation, and monitoring tasks.

## 📦 Scripts

### Backup Utilities
**[backup/backup.sh](backup/)** — Incremental backup tool with safety checks
- Dry-run mode by default
- Root directory protection  
- rsync-based with permission preservation

### System Monitoring
**[monitoring/system-monitor.sh](monitoring/)** — Lightweight health check tool
- CPU, memory, disk metrics
- System error detection (journalctl)
- Exit codes for automation

## 🚀 Quick Start
```bash
# Clone repository
git clone https://github.com/mirwanasikin/devops-scripts.git
cd devops-scripts

# Make scripts executable
chmod +x backup/backup.sh monitoring/system-monitor.sh

# Run with --help for usage
./backup/backup.sh -h
./monitoring/system-monitor.sh
```

## 📋 Requirements

- Linux system (tested on Fedora 43)
- Bash 4.0+
- rsync (for backup scripts)
- systemd/journalctl (for monitoring)

## 🤝 Contributing

Feel free to open issues or submit PRs for improvements.

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 👤 Author

**M. Irwan Asikin**
- GitHub: [@mirwanasikin](https://github.com/mirwanasikina)
- Email: mirwanasikin@gmail.com


