# Linux IoT Weatherstation

Embedded Linux system for the [Raspberry Pi 3 Model B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/)
using Buildroot ([https://buildroot.org/](https://buildroot.org/)). Continuously
reads temperature & humidity from an SHT31 sensor, logs data to SQLite, and
serves a dashboard via a Python web app.

For the individual projects providing sensor readings and dashboard
functionality, see [prdktntwcklr/python-sht31](https://github.com/prdktntwcklr/python-sht31)
and [prdktntwcklr/weatherman](https://github.com/prdktntwcklr/weatherman),
respectively.

## Features

- Automated sensor logging (SHT31 sensor via I2C)
- SQLite database storage
- Web dashboard for data visualization
- Cron job for periodic sampling
- Docker-based build environment
- Fallback mode for development/testing (random values)

## Hardware Requirements

- Raspberry Pi 3 Model B+
- MicroSD card
- Sensirion SHT31 sensor (I2C)
- Jumper wires
- USB Micro-B cable
- RJ45 cable (optional)

## Quick Start

### 1. Clone the repository

**Important for Windows Users**: Do not clone this repository into a standard
Windows folder (e.g., `C:\Users\...`). Docker performance on Windows-mounted
drives is extremely slow, and Buildroot will likely fail due to
case-insensitivity and line-ending issues.
**Always clone and build inside the WSL2 internal filesystem.**

```bash
git clone https://github.com/prdktntwcklr/weatherstation-linux.git
cd weatherstation-linux
git submodule update --init --recursive
```

### 2. Build with Docker Compose

```bash
docker compose run --rm --build build-app
```

### 3. Flash SD card

- Copy build output to SD card
- Insert into Raspberry Pi
- Power on and connect via serial
- Login: `root` / `root`

## Project Structure

See `buildroot-external/board/weatherstation/rootfs_overlay/` for overlays and
scripts.

## Building & Installation

Build with Docker Compose:

```bash
docker compose run --rm --build build-app
```

Copy build output to SD card, insert into Pi, power on, and login as `root`.

## Data Logging (Cron Job)

Environmental data is sampled every 5 minutes via cron `/var/spool/cron/crontabs/root`:

```text
*/5 * * * * /bin/python /root/log_data.py
```

## Python Script Overview

The script `/root/log_data.py`:

- Opens SQLite database (`/var/www/web-app/weather.db`)
- Reads sensor values
- Inserts timestamped data
- Handles sensor errors with dummy values (`-99.99`)
- Simulates readings if no sensor is detected (for development)

## Web Dashboard

The web server (Python, Gunicorn, Nginx) visualizes the collected data. Access
via browser on the Pi's IP address.

## Troubleshooting

- Dummy values (`-99.99`) indicate sensor read failure.
- Random values are used for development/testing.
- Ensure Docker is installed and running.
- Check logs in `/var/www/web-app/` for web app issues.
