# Pentagonus Network Scanner

**Pentagonus** is a Bash script for scanning TCP ports on a target host. It is designed for system administrators, penetration testers, and network enthusiasts who need a quick and effective way to check open ports and associated services on Linux systems.

## Features

- Scan a single host for open TCP ports
- Supports custom port ranges and lists (e.g., `22,80,443` or `1-1024`)
- Customizable timeout per port
- Verbose mode for detailed output
- Displays common service names for open ports
- Simple and clear command-line interface

## Usage

```bash
./pentagonus.sh -t <target> [-p <ports>] [-T <timeout>] [-v]
```

### Options

- `-t <target>`  Target IP address or hostname (required)
- `-p <ports>`  Ports to scan (e.g., `22,80,443` or `1-1000`, default: `1-1024`)
- `-T <timeout>` Timeout per port in seconds (default: `1`)
- `-v`      Verbose output (shows closed ports)
- `-h`      Show help message

### Examples

Scan the default port range on a host:
```bash
./pentagonus.sh -t example.com
```

Scan specific ports with a custom timeout:
```bash
./pentagonus.sh -t 192.168.1.1 -p 22,80,443 -T 2
```

Verbose scan of a port range:
```bash
./pentagonus.sh -t localhost -p 1-100 -v
```

## Requirements

- Bash shell
- Linux system with `/dev/tcp` support
- `getent`, `awk`, `grep`, `timeout`, and `ping` utilities

## Disclaimer

This tool is intended for educational purposes and authorized network testing only. Always obtain proper permission before scanning any network or host.

## License

MIT License

---

**Author:** X2X0  
**Version:** 1.0
