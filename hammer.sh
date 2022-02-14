#!/bin/bash

# limit gpu to 1000MHz (instead of 1350) all the time. power reduced from 13W to ~7.5W
echo 1000 > /sys/class/drm/card0/gt_boost_freq_mhz

while true; do
  PROFILE=$(cat /sys/firmware/acpi/platform_profile)
  POWER_LIMIT=$(cat /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw)
  TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

  if [ "$PROFILE" == "performance" ]; then
    if [ "$POWER_LIMIT" -lt "20000000" ]; then
      if [ "$TEMP" -lt "75000" ]; then
        echo "Throttling to $POWER_LIMIT detected in performance profile. Resetting to full wattage (28W) because temp is okish at $TEMP"
        echo 28000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      else
        echo "Throttling to $POWER_LIMIT detected. Temperature is $TEMP so reducing to an hopefully sane level of 20W"
        # play safe
        echo 20000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      fi
    elif [ "$POWER_LIMIT" != "28000000" ] && [ "$TEMP" -lt "80000" ]; then
      echo "Resetting performance power limit to 28W"
      echo 28000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
    fi
  elif [ "$PROFILE" == "balanced" ]; then
    if [ "$POWER_LIMIT" -lt "15000000" ]; then
      if [ "$TEMP" -lt "75000" ]; then
        echo "Throttling to $POWER_LIMIT detected in balanced profile. Resetting to full wattage (15W) because temp is okish at $TEMP"
        # default
        echo 15000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      elif [ "$POWER_LIMIT" -lt "12000000" ]; then
        echo "Throttling to $POWER_LIMIT detected. Temperature is $TEMP so reducing to an hopefully sane level of 12W"
        # lower by 3 watt and pray that is enough
        echo 12000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      fi
    fi
  fi
  # it seems it take quite a while for throttling to happen
  sleep 5
done
