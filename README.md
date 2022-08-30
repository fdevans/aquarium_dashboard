# Apex Dashboard using Grafana/Influx/Telegraf Notes

[Details how this is used on Reef2Reef](https://www.reef2reef.com/threads/dashboard-and-data-gave-me-a-successful-tank.908217/)

This is written very quickly.  Please feel free to comment on the thread or open GitHub issues if you have trouble.  Pull Requests also welcome to improve docs, etc.

## Base Installation

1. Setup RPI - Follow Docs to get to base setup.  I used a 3B+ with the 32bit Raspberry Pi OS. ([raspberrypi.com instructions](https://www.raspberrypi.com/documentation/computers/getting-started.html))
    1. Wired or Wireless is fine, but make sure the IP address is “fixed” so you know where to find it all the time.
    2. Make sure you run all the updates.
2. Install InfluxDB
    3. [https://pimylifeup.com/raspberry-pi-influxdb/](https://pimylifeup.com/raspberry-pi-influxdb/)
    4. Should be good after step 7 of the setup.
    5. If you want to test using the remaining steps it’s recommended and won’t impact future steps.
3. Install Telegraf
    6. With the repos setup in steps 2a above we can also run: \
`sudo apt-get install telegraf`
4. Install Grafana
    7. [https://grafana.com/tutorials/install-grafana-on-raspberry-pi/](https://grafana.com/tutorials/install-grafana-on-raspberry-pi/)
    8. Command has a warning, but seems to still work. \
`sudo apt-key add -`
    9. Had to do the following as 8.5.0 didn’t work and has posts about it failing on RPi
        1. `sudo apt install grafana=8.4.7`


Included is an `install.sh` file that can be used to perform the steps above quickly and easily.  You'll likely need to make it executable after you copy it to the Pi.  `chmod +x ./install.sh`


## Configuration

### Get Data from the APEX

1. Navigate to `/etc/telegraf` on the RPi
1. Copy _telegraf.conf_ to _telegraf.conf.default_ (to save it as a backup)
1. Edit the _telegraf.conf_ and include the following to get things started.
    1. File contents in repo. (telegraf.conf)
    1. Change IP Address of `192.111.5.5` to whatever your APEX is using. (Can be found in network setup of Apex.)
1. Restart Telegraf `sudo systemctl restart telegraf`
1. Check Influx is gathering Data
    1. Enter Influx Console: `influx`
    1. Type: `show databases`
        1. If you don’t see “Apex” stop and troubleshoot
    1. Type: `use apex`
    1. Type: `show measurements`
        1. Mine shows: `apex_dosing, apex_inputs, neptune_apex, trident_levels`
    1. Type: `select * from neptune_apex`


### Starting your Dashboard

My Dashboard (Grafana-Apex-Dashboard.json) can be used as a start, but some of it will not be the same for your setup.  Device IDs are dynamically assigned as new devices are plugged into the Apex so each panel will need to be built individually for your setup.

I will write some basics on how to create the Temperature panel shown in my example and will add more as I have time.  

Start by Creating a new Dashboard and giving it a name and saving it.

> Note: Because I am recreating my examples I’m using my preferences.  Feel free to adjust as needed for your own needs.


#### Configuring the InfluxDB Datasource in Grafana

1. Login to Grafana
1. Navigate to _Configuration Menu_ > _DataSources_ (Gear Icon on left)
1. Click _Add data source_
1. Choose _InfluxDB_
1. URL: `http://localhost:8086`
1. Database: `apex`
    (all other settings can be left default)
1. Click **Save and Test** and make sure connection works.


#### Temperature Gauge Panel

1. Add a New Panel
2. In the upper right choose “Gauge” as the Visualization Type
    1. In the Query Section under the “A” entry
        1. The “From” line should read: `default neptune_apex WHERE name = Tmp`
        2. The “Select” line should read: `field(value) last()`
        3. Click on `mean()` and choose **remove**
        4. Click on + and choose `Selectors > Last`
    2. In the right panel
        5. Panel Options
            1. Set Title and Description as you see fit
        6. Standard Options
            2. Choose `Farenheight`
            3. Set Min to `73`
            4. Set Max to `82`
            5. Make sure Color Scheme is “From Thresholds (by Value)”
        7. Thresholds.  These can be adjusted for your own version of success.  The key below offers a nicely balanced visual but adjust for tank success. The numbers are where that color starts as you count from zero.  So from 0 to 75 is Red, 75 to 76 is Yellow, 76-79 is green, 79-81 yellow, over 81 is red.
            6. Remove any existing entries.
            7. Change Base to Red Color
            8. Add a new Threshold set to `75 and Yellow`
            9. Add a new Threshold set to `76 and Green`
            10. Add a new Threshold set to `79 and Yellow`
            11. Add a new Threshold set to `81 and Red`
3. Click Apply to return to the dashboard view with your new panel
4. Click Save to save the changes to the dashboard.
