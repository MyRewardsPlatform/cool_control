#!/bin/bash

CONFIG_FILE="/etc/cool_control.conf"
DEFAULT_LOW_TEMP=40
DEFAULT_HIGH_TEMP=60
DEFAULT_FAN_SPEED=50

# Function to load configuration from file
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        echo "Configuration file not found. Using default settings."
        LOW_TEMP=$DEFAULT_LOW_TEMP
        HIGH_TEMP=$DEFAULT_HIGH_TEMP
        FAN_SPEED=$DEFAULT_FAN_SPEED
    fi
}

# Function to override configuration with command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--low-temp)
                LOW_TEMP=$2
                shift
                ;;
            -h|--high-temp)
                HIGH_TEMP=$2
                shift
                ;;
            -s|--fan-speed)
                FAN_SPEED=$2
                shift
                ;;
            start)
                # Start the PWM fan service
                sudo systemctl start cool_control.service
                exit
                ;;
            stop)
                # Stop the PWM fan service
                sudo systemctl stop cool_control.service
                exit
                ;;
            restart)
                # Restart the PWM fan service
                sudo systemctl restart cool_control.service
                exit
                ;;
            status)
                # Check the status of the PWM fan service
                sudo systemctl status cool_control.service
                exit
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done
}

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -l, --low-temp    Set the low temperature threshold"
    echo "  -h, --high-temp   Set the high temperature threshold"
    echo "  -s, --fan-speed   Set the fan speed (0-100)"
    echo "Service Controls:"
    echo "  start              Start the PWM fan service"
    echo "  stop               Stop the PWM fan service"
    echo "  restart            Restart the PWM fan service"
    echo "  status             Check the status of the PWM fan service"
    echo "  -h, --help         Display this help message"
}

# Main function
main() {
    load_config
    parse_args "$@"

    # Add your fan control logic here, using $LOW_TEMP, $HIGH_TEMP, and $FAN_SPEED
    echo "Low Temp Threshold: $LOW_TEMP"
    echo "High Temp Threshold: $HIGH_TEMP"
    echo "Fan Speed: $FAN_SPEED"
}

# Parse command line arguments
main "$@"
