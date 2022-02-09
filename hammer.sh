#!/bin/bash

while true; do
  PROFILE=$(cat /sys/firmware/acpi/platform_profile)
  POWER_LIMIT=$(cat /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw)
  TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

  if [ "$PROFILE" == "performance" ]; then
    if [ "$POWER_LIMIT" -lt "20000000" ]; then
      if [ "$TEMP" -lt "85000" ]; then
        echo "Throttling detected in performance profile. Resetting to full wattage (64W) because temp is okish at $TEMP"
        echo 64000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      else
        echo "Throttling detected. Temperature is $TEMP so reducing to an hopefully sane level of 23W"
        # play safe
        echo 23000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      fi
    elif [ "$POWER_LIMIT" != "64000000" ] && [ "$TEMP" -lt "85000" ]; then
      echo "Resetting performance power limit to 64W"
      echo 64000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
    fi
  elif [ "$PROFILE" == "balanced" ]; then
    if [ "$POWER_LIMIT" -lt "15000000" ]; then
      if [ "$TEMP" -lt "85000" ]; then
        echo "Throttling detected in balanced profile. Resetting to full wattage (15W) because temp is okish at $TEMP"
        # default
        echo 15000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      elif [ "$POWER_LIMIT" -lt "12000000" ]; then
        echo "Throttling detected. Temperature is $TEMP so reducing to an hopefully sane level of 12W"
        # lower by 3 watt and pray that is enough
        echo 12000000 > /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw
      fi
    fi
  fi
  # it seems it take quite a while for throttling to happen
  sleep 5
done