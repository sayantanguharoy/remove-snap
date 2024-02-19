#!/bin/bash
#
# automatic removal of firefox-snap and snap/snapd,
# with ensurance that they won't return.
#
# paste this into snapremove.sh and do:
# chmod a+x ./snapremove.sh; sudo ./snapremove.sh
#
# this must be run as root, so be careful.
#
# NOTE: if you have more snap packages installed,
#       then you will have to remove these manually
#
# NOTE: uncomment the line at the bottom to enable
#       unattended upgrades of firefox
#
 
# remove snap packages, via snap packaging system
snap remove --purge firefox
snap remove --purge snap-store
snap remove --purge gnome-3-38-2004
snap remove --purge gtk-common-themes
snap remove --purge snapd-desktop-integration
snap remove --purge bare
snap remove --purge core20
snap remove --purge snapd
 
# remove snap itself, via apt
apt remove --purge --autoremove snapd -y
 
# make sure it never comes crawling back, via apt preferences
NOSNAP_APT_PREF_FILE='/etc/apt/preferences.d/no_snap.pref'
echo 'Package: snapd' > $NOSNAP_APT_PREF_FILE
echo 'Pin: release a=*' >> $NOSNAP_APT_PREF_FILE
echo 'Pin-Priority: -10' >> $NOSNAP_APT_PREF_FILE
 
# get mozilla team's PPA for firefox
add-apt-repository ppa:mozillateam/ppa
apt update
 
# make sure ppa is preferred so ubuntu doesn't "oopsie!" pull it all back in
FIREFOX_APT_PREF_FILE='/etc/apt/preferences.d/use_mozillateam_firefox_ppa.pref'
echo 'Package: firefox*' > $FIREFOX_APT_PREF_FILE
echo 'Pin: release o=LP-PPA-mozillateam' >> $FIREFOX_APT_PREF_FILE
echo 'Pin-Priority: 501' >> $FIREFOX_APT_PREF_FILE
 
# install mozillateam firefox
apt install -t 'o=LP-PPA-mozillateam' firefox -y
 
# NOTE: UNCOMMENT if you want unattended firefox upgrades:
#echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
 
