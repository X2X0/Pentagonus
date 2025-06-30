#!/bin/bash

# Pentagonus Network Scanner
# Author: X2X0

VERSION="1.0"
CREATOR="X2X0"

print_banner() {
    echo "=============================================="
    echo "        Pentagonus Network Scanner v$VERSION"
    echo "                Created by $CREATOR"
    echo "=============================================="
}

usage() {
    echo "Usage: $0 -t <target> [-p <ports>] [-T <timeout>] [-v]"
    echo "  -t <target>     Target IP address or hostname (required)"
    echo "  -p <ports>      Ports to scan (e.g., 22,80,443 or 1-1000, default: 1-1024)"
    echo "  -T <timeout>    Timeout per port in seconds (default: 1)"
    echo "  -v              Verbose output"
    echo "  -h              Show this help message"
    exit 1
}

resolve_host() {
    local host="$1"
    ip=$(getent hosts "$host" | awk '{ print $1 }')
    if [[ -z "$ip" ]]; then
        ip=$(ping -c 1 "$host" 2>/dev/null | grep "PING" | awk -F'[()]' '{print $2}')
    fi
    echo "$ip"
}

scan_port() {
    local ip=$1
    local port=$2
    local timeout=$3
    (echo > /dev/tcp/$ip/$port) >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        service=$(get_service_name $port)
        echo -e "Port $port/tcp \t OPEN \t $service"
    else
        [ "$VERBOSE" = true ] && echo -e "Port $port/tcp \t CLOSED"
    fi
}

get_service_name() {
    local port=$1
    grep -w "$port/tcp" /etc/services 2>/dev/null | head -n1 | awk '{print $1}' || echo "unknown"
}

# Default values
PORTS="1-1024"
TIMEOUT=1
VERBOSE=false

# Parse arguments
while getopts ":t:p:T:vh" opt; do
    case $opt in
        t) TARGET="$OPTARG" ;;
        p) PORTS="$OPTARG" ;;
        T) TIMEOUT="$OPTARG" ;;
        v) VERBOSE=true ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [ -z "$TARGET" ]; then
    usage
fi

print_banner

IP=$(resolve_host "$TARGET")
if [ -z "$IP" ]; then
    echo "Error: Unable to resolve target $TARGET"
    exit 2
fi

echo "Target: $TARGET ($IP)"
echo "Ports: $PORTS"
echo "Timeout: $TIMEOUT sec"
echo "----------------------------------------------"

# Parse port range
IFS=',' read -ra ADDR <<< "$PORTS"
PORT_LIST=()
for range in "${ADDR[@]}"; do
    if [[ "$range" =~ ^[0-9]+-[0-9]+$ ]]; then
        IFS='-' read -r start end <<< "$range"
        for ((p=start; p<=end; p++)); do
            PORT_LIST+=($p)
        done
    else
        PORT_LIST+=($range)
    fi
done

for port in "${PORT_LIST[@]}"; do
    timeout $TIMEOUT bash -c "scan_port $IP $port $TIMEOUT"
done

echo "----------------------------------------------"
echo "Scan completed."
