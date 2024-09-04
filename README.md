# skript-radio-on-RPi
This Bash script automates the setup of a Raspberry Pi to play a specific radio stream automatically on system startup. Just run this script on Raspberry Pi and you will have endlessly playing **phonk**, or any other music that is hosted on the Internet. It simplifies the process by:

**1. Updating and Installing Necessary Packages:**
    Updates the system and installs MPD (Music Player Daemon) and MPC (Music Player Client), essential for playing the radio stream.

**2. Configuring MPD:**
    Customizes the MPD configuration to use ALSA as the audio output, ensuring the audio is routed correctly through your device.

**3. Creating an Autostart Script:**
    Generates a script that clears the current playlist, adds the desired radio stream, sets the volume to 100%, and starts playback.

**4. Setting Up a systemd Servi**ce:
    Creates and enables a systemd service to ensure the radio starts automatically whenever the Raspberry Pi boots up.

**5. Automating Reboots and Service Restarts:**
    Configures crontab to schedule daily reboots at midnight and to restart the radio service every 20 minutes, ensuring continuous playback without interruption.
After running this script, your Raspberry Pi will be fully configured to automatically start the specified radio stream on boot and maintain it with regular restarts.


To change the hosting, just change the line ```mpc add https://radio.real-drift.com/stream``` url address in _/usr/local/bin/start-radio.sh_
To change the playback volume, change the numerical value in the line ```mpc volume 100``` in _/usr/local/bin/start-radio.sh_

```systemctl enable start-radio.service```
![image](https://github.com/user-attachments/assets/1da1b9e2-f21a-4e90-8ccb-aa49e5d6fe17)

