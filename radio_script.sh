#!/bin/bash

# Функция для вывода сообщений с форматированием
function print_message {
    echo -e "\e[33m=====================================================================\e[0m"
    echo -e "\e[33m$1\e[0m"
    echo -e "\e[33m=====================================================================\e[0m"
}
# Обновление системы и установка необходимых пакетов
print_message "Updating the system and installing necessary packages..."
sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
sudo apt-get install -y mpd mpc > /dev/null

# Настройка MPD конфигурации
print_message "Setting up MPD configuration..."
sudo sed -i '233,241c\
audio_output {\
	type		"alsa"\
	name		"My ALSA Device"\
	device		"default"	# optional\
	mixer_type      "hardware"	# optional\
	mixer_device	"default"	# optional\
	mixer_control	"PCM"		# optional\
	mixer_index	"0"		# optional\
}' /etc/mpd.conf

sudo systemctl enable mpd

# Создание скрипта для автозапуска радио с фонк волной
print_message "Creating a script for autostart radio... https://radio.real-drift.com/stream "
sudo tee /usr/local/bin/start-radio.sh > /dev/null << 'EOF'
#!/bin/sh
mpc clear
mpc add https://radio.real-drift.com/stream
mpc volume 100
mpc play
EOF
sudo chmod +x /usr/local/bin/start-radio.sh

# Создание и активация systemd сервиса для радио
sudo tee /etc/systemd/system/start-radio.service > /dev/null << 'EOF'
[Unit]
Description=Start Radio on Boot
After=mpd.service
Requires=mpd.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/start-radio.sh

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable start-radio.service

# Настройка crontab для автоматического рестарта
print_message "Setting up crontab to automatically restart..."
(sudo crontab -l 2>/dev/null; echo "1 0 * * * /sbin/shutdown -r now") | sudo crontab -
(sudo crontab -l 2>/dev/null; echo "*/20 * * * * systemctl restart start-radio.service") | sudo crontab -

print_message "The installation is complete. The Raspberry Pi is configured to automatically start the radio when the system starts."
print_message "The system will reboot in 15 seconds..."

sleep 15

sudo reboot

