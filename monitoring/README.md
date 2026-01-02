# System Monitor

Lightweight CLI tool for quick system health checks and monitoring.

## Features

- **CPU usage monitoring** — Real-time processor utilization
- **Memory tracking** — RAM usage percentage
- **Disk space monitoring** — Root filesystem usage
- **Error detection** — System errors from the last hour (journalctl)
- **Exit codes** — Automation-friendly (exits 1 if errors detected)
- **Modular checks** — Run individual or combined metrics

## Requirements

- Linux system with bash
- systemd with journalctl (for error checking)
- Standard utilities: `top`, `free`, `df`, `awk`

## Usage

### Basic Syntax
```bash
./system-monitor.sh [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `-c` | Show CPU usage |
| `-m` | Show memory usage |
| `-d` | Show disk usage |
| `-e` | Show error count (last 1 hour) |
| `-a` | Show all metrics |

### Examples

**1. Check all metrics**
```bash
./system-monitor.sh -a
```
Output:
```
CPU Usage 15.3%
Memory used 42%
Disk usage 67%
Number of errors 0
```

**2. Check specific metric**
```bash
# CPU only
./system-monitor.sh -c

# Memory only
./system-monitor.sh -m

# Disk only
./system-monitor.sh -d
```

**3. Check for system errors**
```bash
./system-monitor.sh -e
```
Exit code:
- `0` — No errors found
- `1` — Errors detected in the last hour

**4. Combine multiple checks**
```bash
# Check CPU and memory
./system-monitor.sh -c -m
```

## Automation Examples

### Simple Health Check Script
```bash
#!/bin/bash
if ./system-monitor.sh -e; then
    echo "✅ System healthy - no errors"
else
    echo "⚠️  System errors detected!"
    # Send notification or alert here
fi
```

### Cron Job for Regular Monitoring
```bash
# Check every 15 minutes and log results
*/15 * * * * /path/to/system-monitor.sh -a >> /var/log/system-health.log 2>&1

# Alert if errors detected (every hour)
0 * * * * /path/to/system-monitor.sh -e || echo "Errors detected on $(hostname)" | mail -s "System Alert" admin@example.com
```

### Integration with Other Tools
```bash
# Use in monitoring dashboards
curl -X POST https://monitoring.example.com/metrics \
  -d "cpu=$(./system-monitor.sh -c | awk '{print $3}')"

# Use in Slack notifications
if ! ./system-monitor.sh -e; then
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"System errors detected!"}' \
      YOUR_SLACK_WEBHOOK_URL
fi
```

## Understanding the Output

### CPU Usage
```
CPU Usage 15.3%
```
- Shows current CPU utilization
- Calculated as: 100% - idle%
- Based on instantaneous snapshot from `top`

### Memory Usage
```
Memory used 42%
```
- Shows used RAM percentage
- Calculated as: (Total - Available) / Total × 100
- Based on `free -m` output

### Disk Usage
```
Disk usage 67%
```
- Shows root filesystem (/) usage
- Percentage of used space
- Based on `df /` output

### Error Count
```
Number of errors 5
```
- Counts error-level messages in systemd journal
- Searches last 1 hour of logs
- Priority level: `err` and above

## Exit Codes

The script uses standard exit codes for automation:

| Exit Code | Meaning |
|-----------|---------|
| `0` | Success / No errors found |
| `1` | Errors detected (when using `-e` or `-a`) |

This allows for conditional execution:
```bash
# Run backup only if system is healthy
./system-monitor.sh -e && ./backup.sh -s /data -d /backup -f
```

## Thresholds & Alerts

To add custom thresholds, modify the script or wrap it:
```bash
#!/bin/bash
CPU=$(./system-monitor.sh -c | grep -oP '\d+\.\d+')
if (( $(echo "$CPU > 80" | bc -l) )); then
    echo "⚠️  High CPU usage: ${CPU}%"
    # Send alert
fi
```

## Common Use Cases

### Pre-deployment Health Check
```bash
# Verify system health before deploying
if ./system-monitor.sh -a; then
    echo "Proceeding with deployment..."
    ./deploy.sh
else
    echo "System unhealthy - aborting deployment"
    exit 1
fi
```

### Scheduled System Reports
```bash
# Daily system health report at 9 AM
0 9 * * * /path/to/system-monitor.sh -a | mail -s "Daily System Report - $(date +\%F)" admin@example.com
```

### Quick Troubleshooting
```bash
# Check if recent errors correlate with performance issues
./system-monitor.sh -a
journalctl -p err --since "1 hour ago"
```

## Troubleshooting

**Command not found errors**
- Ensure `top`, `free`, `df`, `awk` are installed
- Check script has execute permissions: `chmod +x system-monitor.sh`

**journalctl permission denied**
- Error checking requires journal read permissions
- Run with sudo or add user to `systemd-journal` group:
```bash
  sudo usermod -aG systemd-journal $USER
```

**Inaccurate CPU readings**
- Script takes single snapshot (not average)
- For better accuracy, run multiple times or use longer sampling

## Technical Details

**Dependencies:**
- `top` — CPU usage calculation
- `free` — Memory statistics
- `df` — Disk space usage
- `journalctl` — System error logs
- `awk` — Text processing

**Error detection:**
- Uses `journalctl -p err` to find error-level logs
- Searches last 60 minutes: `--since "1 hour ago"`
- Counts total error messages with `wc -l`


## Author

**M. Irwan Asikin**
- GitHub: [@mirwanasikin](https://github.com/mirwanasikina)

