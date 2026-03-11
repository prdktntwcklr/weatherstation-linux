#!/bin/python

import datetime
import os
import random
import sqlite3
import sys

from sht31 import sht31

# smbus only exists on RaspberryPi
try:
    import smbus
    smbus_exists = True
except ImportError:
    smbus_exists = False
    pass


class Database:
    def __init__(self, filename):
        # database file is created by web app
        self.filename = filename
        self.connection = sqlite3.connect(filename)
        self.cursor = self.connection.cursor()

    def insert(self, data):
        print(f"Inserting data into {self.filename}: {data}")

        insertQuery = """INSERT INTO database VALUES (?, ?, ?);"""

        self.cursor.execute(insertQuery, data)

    def close(self):
        self.connection.commit()
        self.cursor.close()
        self.connection.close()

        self.filename = None
        self.connection = None
        self.cursor = None


class Sensor:
    def __init__(self):
        if smbus_exists:
            self.address = 0x44  # default address
            self.bus = smbus.SMBus(1)

            try:
                self.instance = sht31.SHT31(address=self.address, bus=self.bus)
            except Exception as e:
                print("Initializing SHT31 failed:", e)
                sys.exit(1)
        else:
            self.address = None
            self.bus = None
            self.instance = None

    def get_values(self):
        curr_time = get_formatted_datetime()

        if self.instance is not None:
            curr_temp, curr_humi = self.instance.get_temp_and_humidity()

            if curr_temp is None or curr_humi is None:
                # error in reading values from sensor, use dummy values
                curr_temp = -99.99
                curr_humi = -99.99
        else:
            # no sensor available, use random values
            curr_temp = random.uniform(-10, 40)
            curr_humi = random.uniform(0, 100)

        return (curr_time, round(curr_temp, 2), round(curr_humi, 2))


def get_formatted_datetime(date_format="%Y-%m-%dT%H:%M+00:00"):
    now = datetime.datetime.now()

    # TODO: should be able to deal with different timezones
    return now.strftime(date_format)


def main():
    try:
        db = Database('/var/www/web-app/weather.db')
        sens = Sensor()

        values = sens.get_values()

        db.insert(values)

    finally:
        db.close()


if __name__ == '__main__':
    main()
