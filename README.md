# Linux Weatherstation

This repository contains an embedded Linux system built for the
[Raspberry Pi 3 Model B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/)
using Buildroot ([https://buildroot.org/](https://buildroot.org/)).

This project runs a Python application that continuously reads from an
I2C-connected SHT31 temperature & humidity sensor, then writes the environmental
data to an SQLite database and functions as a web server to visualize the
results on a dashboard.

For the individual projects providing sensor readings and dashboard
functionality, see [prdktntwcklr/python-sht31](https://github.com/prdktntwcklr/python-sht31)
and [prdktntwcklr/weatherman](https://github.com/prdktntwcklr/weatherman),
respectively.

## Hardware

- Raspberry Pi 3 Model B+
- MicroSD card
- Sensirion SHT31 temperature & humidity sensor
- Jumper wires
- USB Micro-B cable
- RJ45 cable

## Building the project

To build the project, simply use the provided `docker-compose.yaml` file by
running:

```bash
docker compose run --rm --build build-app
```

## Installing

After copying the build products over to an SD card, insert the card into the
Raspberry Pi and apply power to the board. You should be able to follow the boot
messages over a serial port. When you reach the login prompt, enter `root` for
both username and password.

## Cron Job

The system is set up to sample environmental data from the attached SHT31 sensor
by use of a Python script. Running the script continuously is defined as a cron
job as part of the rootfs overlay under `var/spool/cron/crontabs/root`:

```bash
*/5 * * * * /bin/python /root/log-data.py
```

This ensures the `log-data.py` script runs every five minutes.

## Python Script

The `log-data.py` Python script first opens an SQLite database file, reads
environmental values from the sensor and inserts these values into the database
together with the current timestamp:

```Python
def main():
    try:
        db = Database('/var/www/web-app/weather.db')
        sens = Sensor()

        values = sens.get_values()

        db.insert(values)

    finally:
        db.close()
```

If reading from the sensor fails for any reason, the script is configured to use
dummy values of `-99.99` instead. Seeing these values should alert the user that
a read from the sensor was unsuccessful.

```Python
class Sensor:
    # class initialization omitted

    def get_values(self):
        curr_time = get_formatted_datetime()

        if self.instance is not None:
            curr_temp, curr_humi = self.instance.get_temp_and_humidity()

            if curr_temp is None or curr_humi is None:
                # error in reading values from sensor, use dummy values
                curr_temp = -99.99
                curr_humi = -99.99
        # else case omitted

        return (curr_time, round(curr_temp, 2), round(curr_humi, 2))
```

To allow for testing the script on a regular PC without having a sensor
attached, random values are used when no instance of the sensor device has been
defined. This is the default fallback solution if the SMBus library is not
available, which only exists on the Raspberry Pi:

```Python
class Sensor:
    def __init__(self):
        if smbus_exists:
            # initialization of regular sensor omitted
        else:
            self.address = None
            self.bus = None
            self.instance = None

    def get_values(self):
        curr_time = get_formatted_datetime()
    
        if self.instance is not None:
            # reading data from regular sensor omitted
        else:
            # no sensor available, use random values
            curr_temp = random.uniform(-10, 40)
            curr_humi = random.uniform(0, 100)
    
        return (curr_time, round(curr_temp, 2), round(curr_humi, 2))
```
