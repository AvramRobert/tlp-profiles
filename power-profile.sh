#!/bin/bash

TLPPATH='/etc/default/'
PROFILES='/home/robert/Tools/power-modes/profiles/'
ORIG='tlp_orig'
TLP='tlp'
CURFILE=''

function exchange() {
  if [ -e "$TLPPATH$ORIG" ]; then
    rm $TLPPATH$TLP
  else
    mv $TLPPATH$TLP $TLPPATH$ORIG
  fi
    cp "$PROFILES$CURFILE" "$PROFILES$TLP"
    mv $PROFILES$TLP $TLPPATH$TLP
    tlp start
  return 0
}

function reset() {

  if [ -e "$TLPPATH$ORIG" ]
  then
    rm $TLPPATH$TLP
    mv $TLPPATH$ORIG $TLPPATH$TLP
    tlp start
  else
    echo 'No TLP original config file found'
  fi
  return 0
}

function status() {
  echo 'CPU Governor'
  tlp stat -c | grep CPU_SCALING_GOVERNOR_ON_AC
  tlp stat -c | grep CPU_SCALING_GOVERNOR_ON_BAT
  echo ''
  echo 'Turbo Boost [1 = on, 0 = off]'
  tlp stat -c | grep CPU_BOOST_ON_AC
  tlp stat -c | grep CPU_BOOST_ON_BAT
  echo ''
  echo 'Minimize CPU Cores on light conditions [1 = on, 0 = off]'
  tlp stat -c | grep SCHED_POWERSAVE_ON_AC
  tlp stat -c | grep SCHED_POWERSAVE_ON_BAT
  echo ''
  echo 'CPU energy policy'
  tlp stat -c | grep ENERGY_PERF_POLICY_ON_AC
  tlp stat -c | grep ENERGY_PERF_POLICY_ON_BAT
  echo ''
  echo 'Wifi powersave [1 = off, 5 = on]'
  tlp stat -c | grep WIFI_PWR_ON_AC
  tlp stat -c | grep WIFI_PWR_ON_BAT
  echo ''
  echo 'PCIE ASPM'
  tlp stat -c | grep PCIE_ASPM_ON_AC
  tlp stat -c | grep PCIE_ASPM_ON_BAT
  echo ''
  echo 'Audio powersave [1 = on, 0 = off]'
  tlp stat -c | grep SOUND_POWER_SAVE_ON_AC
  tlp stat -c | grep SOUND_POWER_SAVE_ON_BAT
  return 0
}

if [ "$1" = "status" ]
then
  status
elif [ "$1" = "perform" ]
then
  echo 'Option: Performance'
  CURFILE='tlp_performance'
  exchange
elif [ "$1" = "save" ]
then
  echo 'Option: Powersave'
  CURFILE='tlp_powersave'
  exchange
elif [ "$1" = "conserve" ]
then
  echo 'Option: Conservative'
  CURFILE='tlp_conserve'
  exchange
elif [ "$1" = "default" ]
then
  echo 'Option: Default'
  CURFILE='tlp_default'
  exchange
else
  echo 'Option: Reset'
  reset
fi
