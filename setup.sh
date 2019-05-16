#!/usr/bin/bash
# Runs a one time setup from this repo to link all the configuration files.
# iDigitalFlame

SETUP_DIRECTORY=$(pwd)
SETUP_PATH=$(realpath $0)

yes() {
    empty=0
    printf "[?] $1 ["
    if [[ $# -eq 2 && "$2" == "1" ]]; then
        empty=1
        printf "Y/n]? "
    else
        printf "y/N]? "
    fi
    read check
    if [[ $empty -eq 1 && -z "$check" ]]; then
        return 0
    fi
    if [[ "$check" == "Y" || "$check" == "y" ]]; then
        return 0
    fi
    return 1
}

do_setup() {
    printf "Setting up server..\n"
    if [ -d "/etc/systemd/network" ]; then
        mv "/etc/systemd/network" "$SETUP_DIRECTORY/etc/systemd/"
    fi
    if [ -e "/etc/hosts" ]; then
        mv "/etc/hosts" "$SETUP_DIRECTORY/etc/hosts"
    else
        printf "127.0.0.1    localhost\n172.0.0.1    $(hostname)\n" >> "$SETUP_DIRECTORY/etc/hosts"
    fi
    printf "$(hostname)\n" > "$SETUP_DIRECTORY/etc/motd"
    printf "$(hostname)" > "$SETUP_DIRECTORY/etc/hostname"
    chmod 444 "$SETUP_DIRECTORY/etc/hostname"
    printf "SYSCONFIG=${SETUP_DIRECTORY}\n" > "/etc/sysconfig.conf"
    chmod 444 "/etc/sysconfig.conf"
    bash "$SETUP_DIRECTORY/bin/relink" "$SETUP_DIRECTORY" "/"
    bash "$SETUP_DIRECTORY/bin/syslink"
    usermod -c "Server $(hostname)" root
    git config --global user.name "Server $(hostname)"
    git config --global user.email "$(hostname)@archlinux.com"
    systemctl enable checkupdates.service
    systemctl enable checkupdates.timer
    systemctl enable reflector.service
    systemctl enable reflector.timer
    systemctl enable fstrim.timer
    rm /setup.sh
}

printf "!!! THIS WILL COMPLETLY OVERRITE ALL CURRENT CONFIGURATIONS WITH THE CURRENT REPO ONES !!!"
printf "Network Settings and Hostname will be preserved through!"
if ! yes "Cool with that"; then
    printf "Alright, not making any changes!\n"
    exit 1
fi

printf "Here we go, LERRRROOYY JENNNKINS!!\n"
do_setup
rm "$SETUP_PATH"
printf "All Done!\n"
exit 0
